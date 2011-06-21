Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756875Ab1FUUDo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 16:03:44 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:43420 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753946Ab1FUUDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 16:03:43 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Jonas Bonn <jonas@southpole.se>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/19] OpenRISC: Module support
In-Reply-To: Your message of "Sun, 19 Jun 2011 13:43:40 +0200."
             <1308483825-6023-15-git-send-email-jonas@southpole.se>
From: Valdis.Kletnieks@vt.edu
References: <1308483825-6023-1-git-send-email-jonas@southpole.se>
            <1308483825-6023-15-git-send-email-jonas@southpole.se>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1308686616_2609P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 21 Jun 2011 16:03:36 -0400
Message-ID: <31626.1308686616@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Info: (0) 
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020201.4E00F91A.002B,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1308686616_2609P
Content-Type: text/plain; charset=us-ascii

On Sun, 19 Jun 2011 13:43:40 +0200, Jonas Bonn said:

Arnd already did a number of comments - two things I didn't see him note:

>  arch/openrisc/kernel/module.c |  126 +++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 126 insertions(+), 0 deletions(-)
>  create mode 100644 arch/openrisc/kernel/module.c
> 
> diff --git a/arch/openrisc/kernel/module.c b/arch/openrisc/kernel/module.c
> new file mode 100644
> index 0000000..952b129
> --- /dev/null
> +++ b/arch/openrisc/kernel/module.c
> @@ -0,0 +1,126 @@
> +/*
> + * OpenRISC module.c

Lose the filenames in the headers - you do this in multiple files.

Also, do you even *need* a module.c? There isn't much in here, will the main
kernel/module.c do the work needed?  Or did you end up with one because the
arch you cloned had one?


--==_Exmh_1308686616_2609P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOAPkYcC3lWbTT17ARAr1WAKDbPd0kTRmBqpa1sthVBIJxJLX2oACdH/N0
Z+lsfkZdybWHFJo34Yk17Sc=
=F8lN
-----END PGP SIGNATURE-----

--==_Exmh_1308686616_2609P--

