Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756673Ab1DLD2C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 23:28:02 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:37712 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756386Ab1DLD2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 23:28:00 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Michal Marek <mmarek@suse.cz>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org
Subject: Re: [PATCH 09/34] x86: Allow to override the ROOT_DEV variable
In-Reply-To: Your message of "Mon, 11 Apr 2011 17:08:21 +0200."
             <20110411150820.GA22004@sepie.suse.cz>
From: Valdis.Kletnieks@vt.edu
References: <1302015561-21047-1-git-send-email-mmarek@suse.cz> <1302015561-21047-10-git-send-email-mmarek@suse.cz> <4D9B3581.6080105@zytor.com> <4D9C1AA0.9030008@suse.cz>
            <20110411150820.GA22004@sepie.suse.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1302578741_5348P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 11 Apr 2011 23:25:41 -0400
Message-ID: <17983.1302578741@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020205.4DA3C63C.008F,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1302578741_5348P
Content-Type: text/plain; charset=us-ascii

On Mon, 11 Apr 2011 17:08:21 +0200, Michal Marek said:

> Like this?

> Subject: [PATCH] x86: Do not set the rood_dev field in bzImage

'rood'? ;)

> -# ROOT_DEV specifies the default root-device when making the image.
> -# This can be either FLOPPY, CURRENT, /dev/xxxx or empty, in which case
> -# the default of FLOPPY is used by 'build'.

Does the default of FLOPPY still get used after this patch, or is this a stale comment?
Also, I sort of expected to see more code removed that *used* the no-longer-passed
value of ROOT_DEV.

(All my boxes have grub pass a root=, so I don't have a dog in this fight...)

--==_Exmh_1302578741_5348P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFNo8Y1cC3lWbTT17ARAurkAJoDkG+Qo8pmW8VhIfelBHD0a7LBMwCfXNgq
dsz+PNqVniDXc0QfDc1zE7w=
=Vkdy
-----END PGP SIGNATURE-----

--==_Exmh_1302578741_5348P--

