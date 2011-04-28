Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756895Ab1D1AGU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 20:06:20 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:57504 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809Ab1D1AGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 20:06:04 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Oren Weil <oren.jer.weil@intel.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        alan@linux.intel.com, david@woodhou.se
Subject: Re: [PATCH 8/8] staging/mei: Updates to staging/Kconfig ane staging/Makefile and a new Makefile and Kconfig
In-Reply-To: Your message of "Wed, 27 Apr 2011 13:27:37 +0300."
             <1303900057-21694-9-git-send-email-oren.jer.weil@intel.com>
From: Valdis.Kletnieks@vt.edu
References: <1303900057-21694-1-git-send-email-oren.jer.weil@intel.com>
            <1303900057-21694-9-git-send-email-oren.jer.weil@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1303949150_5598P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 27 Apr 2011 20:05:50 -0400
Message-ID: <10935.1303949150@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020202.4DB8AF62.0083,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1303949150_5598P
Content-Type: text/plain; charset=us-ascii

On Wed, 27 Apr 2011 13:27:37 +0300, Oren Weil said:
> Changes of Kconfig and Makefile in drivers/staging
> for adding the Intel MEI Driver to the Linux kernel.
> New Makefile and Kconfig building for MEI Driver.

> +++ b/drivers/staging/mei/Kconfig
> @@ -0,0 +1,10 @@
> +config INTEL_MEI
> +	tristate "Intel Management Engine Interface (Intel MEI)"
> +	depends on X86 && EXPERIMENTAL
> +	help
> +		The Intel Management Engine (Intel ME) provides Manageability,
> +		Security and Media services for system containing Intel chipsets.
> +		if selected /dev/mei misc device will be created.
> +
> +		For more information see
> +		<http://software.intel.com/en-us/manageability/>

Can this be expanded a bit to give a better hint *which* Intel chipsets support
this? I just spent an honest 10 minutes looking around that website, and am no
clearer on whether the 82801I in my laptop supports this.  Having a line like
"server chipsets XY948 and later and ICH10 and later" or similar would be a big
help to all those who hit this when it goes into the tree.


--==_Exmh_1303949150_5598P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFNuK9ecC3lWbTT17ARAjFLAKDd6zBGXOARZNWzrV24i82DZt9BygCdHL1a
k2QwyIauj8Gohq0it3y6YeU=
=2ddy
-----END PGP SIGNATURE-----

--==_Exmh_1303949150_5598P--

