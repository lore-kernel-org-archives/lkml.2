Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102Ab1KFTue (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 14:50:34 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:42200 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544Ab1KFTud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 14:50:33 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Ismail Donmez <idoenmez@suse.de>
Cc: Thomas Renninger <trenn@suse.de>, linux-kernel@vger.kernel.org,
        x86@kernel.org, stable@kernel.org
Subject: Re: [PATCH] x86: Fix reboot issue for Dell Optiplex 990 V2
In-Reply-To: Your message of "Fri, 04 Nov 2011 08:16:09 BST."
             <4EB39139.3090709@suse.de>
From: Valdis.Kletnieks@vt.edu
References: <1320373797-4393-1-git-send-email-trenn@suse.de>
            <4EB39139.3090709@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1320608935_135101P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sun, 06 Nov 2011 14:48:55 -0500
Message-ID: <195573.1320608935@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A02020A.4EB6E4AB.0152,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1320608935_135101P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

On Fri, 04 Nov 2011 08:16:09 BST, Ismail Donmez said:
> On 11/04/2011 03:29 AM, Thomas Renninger wrote:
> > This was the only (reboot=3Dp) option that worked for this desktop.
> > Default does not reboot as well.

> >   			DMI_MATCH(DMI_PRODUCT_NAME, =22Latitude E6420=22),

> > +			DMI_MATCH(DMI_PRODUCT_NAME, =22OptiPlex 990=22),

> I have this machine and can confirm reboot=3Dpci is only way to get it =
to=20
> reboot. But also Dell's very recent Latitude E6520 laptop needs the sam=
e=20
> workaround. It would be nice to send a patch for it too.

Just as another data point, my Latitude E6500 does *not* need this, as it=
's perfectly
happy using the default reboot method.  So please avoid the temptation to=
 do
a match on =22Latitude E6=22 ;)

--==_Exmh_1320608935_135101P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOtuSncC3lWbTT17ARAixYAJ9zf5qYef7IwlDEGUF46GmXo1lyOACdG8Zl
HbbMq/JJXdTFVijolbLtGBA=
=6D7x
-----END PGP SIGNATURE-----

--==_Exmh_1320608935_135101P--

