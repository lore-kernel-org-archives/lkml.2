Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977Ab0JGWJP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 18:09:15 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:46013 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430Ab0JGWJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 18:09:14 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: linux-kernel@vger.kernel.org
Cc: mm-commits@vger.kernel.org
Subject: Re: mmotm 2010-10-07-14-08 uploaded
In-Reply-To: Your message of "Thu, 07 Oct 2010 14:08:45 PDT."
             <201010072140.o97Le69i025659@imap1.linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <201010072140.o97Le69i025659@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1286489353_11396P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 07 Oct 2010 18:09:13 -0400
Message-ID: <37921.1286489353@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A02020A.4CAE4509.00F7,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1286489353_11396P
Content-Type: text/plain; charset="us-ascii"
Content-Id: <37903.1286489344.1@localhost>

On Thu, 07 Oct 2010 14:08:45 PDT, akpm@linux-foundation.org said:
> The mm-of-the-moment snapshot 2010-10-07-14-08 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/

'make oldconfig' splatted this at the very end:

  NCP file system support (to mount NetWare volumes) (NCP_FS) [N/m/y/?] n
  Coda file system support (advanced network fs) (CODA_FS) [N/m/y/?] n
  Andrew File System support (AFS) (EXPERIMENTAL) (AFS_FS) [N/m/y/?] n
warning: (IEEE1394_PCILYNX && (PCI || BROKEN) && PCI && IEEE1394 && I2C || SFC && NETDEVICES && NETDEV_10000 && PCI && INET || I2C_VIA && I2C && PCI && EXPERIMENTAL || I2C_HYDRA && I2C && PCI && PPC_CHRP && EXPERIMENTAL || I2C_GPIO && I2C && GENERIC_GPIO || I2C_IXP2000 && I2C && ARCH_IXP2000 || I2C_SIMTEC && I2C || I2C_VERSATILE && I2C && (ARCH_VERSATILE || ARCH_REALVIEW || ARCH_VEXPRESS) || I2C_PARPORT && I2C && PARPORT || I2C_PARPORT_LIGHT && I2C || I2C_ACORN && I2C && ARCH_ACORN || SCx200_I2C && I2C && SCx200_GPIO || VIDEO_BT848 && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_DEV && PCI && I2C && VIDEO_V4L2 && INPUT && VIDEO_IR || VIDEO_CX88 && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && VIDEO_DEV && PCI && I2C && INPUT && VIDEO_IR || VIDEO_CX23885 && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && DVB_CORE && VIDEO_DEV && PCI && I2C && INPUT && IR_CORE || VIDEO_AU0828 && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && I2C && INPUT && DVB_CORE && USB && V!
 IDEO_V4L2 || VIDEO_IVTV && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && PCI && I2C && INPUT && VIDEO_IR || VIDEO_CX18 && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && DVB_CORE && PCI && I2C && EXPERIMENTAL && INPUT && VIDEO_IR || VIDEO_SAA7164 && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && DVB_CORE && PCI && I2C || DVB_PLUTO2 && MEDIA_SUPPORT && DVB_CAPTURE_DRIVERS && DVB_CORE && PCI && I2C || DRM && HAS_IOMEM && (AGP || AGP=n) && !EMULATED_CMPXCHG && MMU || FB_DDC && HAS_IOMEM && FB || FB_VIA && HAS_IOMEM && FB && PCI && X86 || VIDEO_CX25821 && STAGING && !STAGING_EXCLUDE_BUILD && DVB_CORE && VIDEO_DEV && PCI && I2C && INPUT && BKL) selects I2C_ALGOBIT which has unmet direct dependencies (I2C && !I2C_HELPER_AUTO)
warning: (NETFILTER_XT_MATCH_REALM && NET && INET && NETFILTER && NETFILTER_XTABLES && NETFILTER_ADVANCED || NET_CLS_ROUTE4 && NET && NET_SCHED) selects NET_CLS_ROUTE which has unmet direct dependencies (NET && NET_SCHED)
#
# configuration written to .config
#

Haven't had a chance to research it yet.

--==_Exmh_1286489353_11396P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFMrkUJcC3lWbTT17ARAt16AJ9xl4eImnbw1JJ/T8Wx9cq//BgVPgCeIrie
qxcLgKsaKqtVMVNCyvjbgRs=
=8Kbm
-----END PGP SIGNATURE-----

--==_Exmh_1286489353_11396P--

