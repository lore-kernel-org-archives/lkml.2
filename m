Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756369Ab0FODuG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 23:50:06 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:39603 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713Ab0FODuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 23:50:02 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: linux-kernel@vger.kernel.org, reiserfs-devel@vger.kernel.org,
       linux-bluetooth@vger.kernel.org, clemens@ladisch.de,
       debora@linux.vnet.ibm.com, dri-devel@lists.freedesktop.org,
       linux-i2c@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
       linux-media@vger.kernel.org
Subject: Re: [PATCH 4/8]drivers:tmp.c Fix warning: variable 'rc' set but not used
In-Reply-To: Your message of "Mon, 14 Jun 2010 19:12:31 PDT."
             <4C16E18F.9050901@gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <1276547208-26569-1-git-send-email-justinmattock@gmail.com> <1276547208-26569-5-git-send-email-justinmattock@gmail.com> <21331.1276560832@localhost>
            <4C16E18F.9050901@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1276573789_4860P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 14 Jun 2010 23:49:49 -0400
Message-ID: <9275.1276573789@localhost>
X-Mirapoint-Received-SPF: 128.173.34.98 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A010203.4C16F85F.0066,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1276573789_4860P
Content-Type: text/plain; charset=us-ascii

On Mon, 14 Jun 2010 19:12:31 PDT, "Justin P. Mattock" said:

> what I tried was this:
> 
> if (!rc)
> 	printk("test........"\n")
> 
> and everything looked good,
> but as a soon as I changed
> 
> rc = transmit_cmd(chip,&tpm_cmd, TPM_INTERNAL_RESULT_SIZE,
>     			"attempting to determine the timeouts");
> 
> to this:
> 
> rc = transmit_cmd(chip,&tpm_cmd, TPM_INTERNAL_RESULT_SIZE);
> 
> if (!rc)
> 	printk("attempting to determine the timeouts\n");

*baffled* Why did you think that would work? transmit_cmd()s signature
has 4 parameters.

--==_Exmh_1276573789_4860P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFMFvhdcC3lWbTT17ARAoaDAJsFnmHjFcoQL0nTEuY8H8yGQYdpqQCglYgf
HqrVXnNW5QE2b8CWdDVStzE=
=d/C0
-----END PGP SIGNATURE-----

--==_Exmh_1276573789_4860P--

