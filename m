Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933416Ab1IBKxM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 06:53:12 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:41935 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933313Ab1IBKxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 06:53:08 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Ravishankar K Mallikarjunayya <ravishankar.km@greenturtles.in>
Cc: gregkh@suse.de, wfp5p@virginia.edu, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Staging: comedi: fix line over 80 character issue in s626.c
In-Reply-To: Your message of "Fri, 02 Sep 2011 12:58:07 +0530."
             <1314948487-3475-1-git-send-email-ravishankar.km@greenturtles.in>
From: Valdis.Kletnieks@vt.edu
References: <[PATCH 1/2]Staging: comedi: fix line over 80 character issue in s626.c>
            <1314948487-3475-1-git-send-email-ravishankar.km@greenturtles.in>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1314960779_2654P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 02 Sep 2011 06:52:59 -0400
Message-ID: <6154.1314960779@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020205.4E60B58E.005C,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1314960779_2654P
Content-Type: text/plain; charset=us-ascii

On Fri, 02 Sep 2011 12:58:07 +0530, Ravishankar K Mallikarjunayya said:
> This is a patch to the s626.c file that fixes up a line over 80 character

Patch looks mostly good - but a question:

> diff --git a/drivers/staging/comedi/drivers/s626.c b/drivers/staging/comedi/drivers/s626.c

> @@ -266,7 +267,11 @@ module_exit(driver_s626_cleanup_module);
>  static int s626_ai_insn_config(struct comedi_device *dev,
>  			       struct comedi_subdevice *s,
>  			       struct comedi_insn *insn, unsigned int *data);
> -/* static int s626_ai_rinsn(struct comedi_device *dev,struct comedi_subdevice *s,struct comedi_insn *insn,unsigned int *data); */
> +/*
> + * static int s626_ai_rinsn(struct comedi_device *dev,
> + * struct comedi_subdevice *s, struct comedi_insn *insn,
> + * unsigned int *data);
> + */

At 4 places, you fix commented-out function prototypes.  Maybe they should
just be deleted instead?

--==_Exmh_1314960779_2654P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOYLWLcC3lWbTT17ARApHEAJ9eRTHc4wX3abfQl4aJPfyKTGsodQCeMGrx
aLTIrb/BzIzwW5kKaKOak8Q=
=0O0n
-----END PGP SIGNATURE-----

--==_Exmh_1314960779_2654P--

