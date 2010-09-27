Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759547Ab0I0PEj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 11:04:39 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:33102 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759517Ab0I0PEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 11:04:38 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: matt mooney <mfm@muteddisk.com>
Cc: kernel-janitors@vger.kernel.org, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/24] hwmon: change to new flag variable
In-Reply-To: Your message of "Fri, 24 Sep 2010 12:17:14 PDT."
             <ffbd189ef2d414ea7c87ffe2b40fce87877dc014.1285355033.git.mfm@muteddisk.com>
From: Valdis.Kletnieks@vt.edu
References: <e0bdab5d2e8c52041c003de68ba774c3e706716c.1285355033.git.mfm@muteddisk.com> <9968d4260be8850200cc9c7dfe08addf611468b4.1285355033.git.mfm@muteddisk.com> <036514b5dd23c5af14303519d79d60d79adccbee.1285355033.git.mfm@muteddisk.com> <e0bdab5d2e8c52041c003de68ba774c3e706716c.1285355033.git.mfm@muteddisk.com>
            <ffbd189ef2d414ea7c87ffe2b40fce87877dc014.1285355033.git.mfm@muteddisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1285599840_7757P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 27 Sep 2010 11:04:00 -0400
Message-ID: <12873.1285599840@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020202.4CA0B261.0054,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1285599840_7757P
Content-Type: text/plain; charset=us-ascii

On Fri, 24 Sep 2010 12:17:14 PDT, matt mooney said:
> Replace EXTRA_CFLAGS with ccflags-y.
> 
> Signed-off-by: matt mooney <mfm@muteddisk.com>
> ---
>  drivers/hwmon/Makefile |    4 +---
>  1 files changed, 1 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/hwmon/Makefile b/drivers/hwmon/Makefile
> index e3c2484..764b4db 100644
> --- a/drivers/hwmon/Makefile
> +++ b/drivers/hwmon/Makefile
> @@ -109,7 +109,5 @@ obj-$(CONFIG_SENSORS_W83L786NG)	+= w83l786ng.o
>  obj-$(CONFIG_SENSORS_WM831X)	+= wm831x-hwmon.o
>  obj-$(CONFIG_SENSORS_WM8350)	+= wm8350-hwmon.o
>  
> -ifeq ($(CONFIG_HWMON_DEBUG_CHIP),y)
> -EXTRA_CFLAGS += -DDEBUG
> -endif
> +ccflags-$(CONFIG_HWMON_DEBUG_CHIP) := -DDEBUG

Was this series intended as := rather than += as it seems that
overriding the entirely of a passed-in ccflags-y may not be what
we wanted to do.

--==_Exmh_1285599840_7757P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD4DBQFMoLJgcC3lWbTT17ARAnB9AJ43etrGzs3rpT2wWlkSvoxsalabnQCVETvx
uT13wbvrHiv2Eu5nrnWPoA==
=7AZa
-----END PGP SIGNATURE-----

--==_Exmh_1285599840_7757P--

