Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751515Ab0GLTJ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 15:09:26 -0400
Received: from relais.videotron.ca ([24.201.245.36]:18546 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920Ab0GLTJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 15:09:25 -0400
MIME-version: 1.0
Content-type: multipart/mixed; boundary="Boundary_(ID_YdAI2/JX+r5wVUKOeROmKA)"
Date: Mon, 12 Jul 2010 15:09:23 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Daniel Walker <dwalker@codeaurora.org>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Eric Miao <eric.miao@canonical.com>, linux-omap@vger.kernel.org
Subject: Re: ARM defconfig files
In-reply-to: <20100712185029.GB14425@pengutronix.de>
Message-id: <alpine.LFD.2.00.1007121502300.10598@xanadu.home>
References: <alpine.LFD.2.00.1006030725420.8175@i5.linux-foundation.org>
 <20100603181010.GA25779@flint.arm.linux.org.uk>
 <1275589230.23384.19.camel@c-dwalke-linux.qualcomm.com>
 <alpine.LFD.2.00.1006031119440.8175@i5.linux-foundation.org>
 <20100614083214.GA2104@pengutronix.de> <20100630104043.GG11746@pengutronix.de>
 <20100712155518.GA24144@pengutronix.de>
 <AANLkTilhI9O6YwnuAylo_jNgwR8VXmpSVJ1kylIYPCGT@mail.gmail.com>
 <20100712173228.GC9897@n2100.arm.linux.org.uk>
 <AANLkTinxUqzxClVDTyruJ6kzFTganXUGJJHJ5wRi9Iak@mail.gmail.com>
 <20100712185029.GB14425@pengutronix.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--Boundary_(ID_YdAI2/JX+r5wVUKOeROmKA)
Content-type: TEXT/PLAIN; charset=iso-8859-1
Content-transfer-encoding: 8BIT

On Mon, 12 Jul 2010, Uwe Kleine-König wrote:
> On Mon, Jul 12, 2010 at 10:40:36AM -0700, Linus Torvalds wrote:
> > I hope you at least do agree that the current situation is a steaming
> > pile of sh*t. And yes, I _will_ remove the crap, both from POWER and
> > ARM, unless I see some serious tries at fixing it.

We all agree this is a pile of sh*t, as the truly valuable data is 
drawned down into it.  The diffstat numbers below certainly shows it 
rather clearly.

Linus, please pull this git tree.  This should functionally be a no op, 
while giving us a better footing to develop a final solution.

> I'm willing to try my solution, some others on the linux-arm-kernel
> lists considered it worth trying, too.  Feel free to pull my tree[1].
> Russell refused to take defconfig changes for a while now, so I don't
> expect merge problems if you do.

ACK.

> If it helps the powerpc people I can reduce their defconfigs, too.
> 
> Best regards
> Uwe
> 
> [1] The following changes since commit 67a3e12b05e055c0415c556a315a3d3eb637e29e:
> 
>   Linux 2.6.35-rc1 (2010-05-30 13:21:02 -0700)
> 
> are available in the git repository at:
>   git://git.pengutronix.de/git/ukl/linux-2.6.git arm/defconfig/reduced-v2.6.35-rc1
> 
> Uwe Kleine-König (1):
>       ARM: reduce defconfigs
> 
>  arch/arm/configs/acs5k_defconfig               | 1146 --------------
>  arch/arm/configs/acs5k_tiny_defconfig          |  860 ----------
>  arch/arm/configs/afeb9260_defconfig            | 1157 +--------------
>  arch/arm/configs/am200epdkit_defconfig         | 1044 +------------
>  arch/arm/configs/am3517_evm_defconfig          | 1250 ---------------
>  arch/arm/configs/ams_delta_defconfig           | 1224 +--------------
>  arch/arm/configs/ap4evb_defconfig              |  722 ---------
>  arch/arm/configs/assabet_defconfig             |  862 +----------
>  arch/arm/configs/at572d940hfek_defconfig       | 1318 +---------------
>  arch/arm/configs/at91cap9adk_defconfig         | 1107 +-------------
>  arch/arm/configs/at91rm9200dk_defconfig        |  955 +-----------
>  arch/arm/configs/at91rm9200ek_defconfig        |  942 +-----------
>  arch/arm/configs/at91sam9260ek_defconfig       |  958 +-----------
>  arch/arm/configs/at91sam9261ek_defconfig       | 1087 +-------------
>  arch/arm/configs/at91sam9263ek_defconfig       | 1103 +-------------
>  arch/arm/configs/at91sam9g20ek_defconfig       | 1049 +------------
>  arch/arm/configs/at91sam9rlek_defconfig        |  864 +----------
>  arch/arm/configs/ateb9200_defconfig            | 1222 +--------------
>  arch/arm/configs/badge4_defconfig              | 1178 +--------------
>  arch/arm/configs/bcmring_defconfig             |  721 ---------
>  arch/arm/configs/cam60_defconfig               | 1089 +-------------
>  arch/arm/configs/carmeva_defconfig             |  696 +--------
>  arch/arm/configs/cerfcube_defconfig            |  851 +----------
>  arch/arm/configs/cm_t35_defconfig              | 1577 +------------------
>  arch/arm/configs/cm_x2xx_defconfig             | 1774 +---------------------
>  arch/arm/configs/cm_x300_defconfig             | 1565 ------------------
>  arch/arm/configs/cns3420vb_defconfig           |  759 ---------
>  arch/arm/configs/colibri_pxa270_defconfig      | 1556 ------------------
>  arch/arm/configs/colibri_pxa300_defconfig      | 1082 -------------
>  arch/arm/configs/collie_defconfig              |  887 +----------
>  arch/arm/configs/corgi_defconfig               | 1621 +-------------------
>  arch/arm/configs/cpu9260_defconfig             | 1225 +--------------
>  arch/arm/configs/cpu9g20_defconfig             | 1215 +--------------
>  arch/arm/configs/cpuat91_defconfig             | 1207 +--------------
>  arch/arm/configs/csb337_defconfig              | 1113 +-------------
>  arch/arm/configs/csb637_defconfig              | 1124 +-------------
>  arch/arm/configs/da8xx_omapl_defconfig         | 1205 --------------
>  arch/arm/configs/davinci_all_defconfig         | 1641 -------------------
>  arch/arm/configs/devkit8000_defconfig          | 1732 +--------------------
>  arch/arm/configs/dove_defconfig                | 1482 -----------------
>  arch/arm/configs/ebsa110_defconfig             |  692 +--------
>  arch/arm/configs/ecbat91_defconfig             | 1226 +--------------
>  arch/arm/configs/edb7211_defconfig             |  554 +-------
>  arch/arm/configs/em_x270_defconfig             | 1554 +------------------
>  arch/arm/configs/ep93xx_defconfig              | 1340 ----------------
>  arch/arm/configs/eseries_pxa_defconfig         | 1128 -------------
>  arch/arm/configs/ezx_defconfig                 | 1582 +-------------------
>  arch/arm/configs/footbridge_defconfig          | 1185 +--------------
>  arch/arm/configs/fortunet_defconfig            |  538 +-------
>  arch/arm/configs/g3evm_defconfig               |  717 ---------
>  arch/arm/configs/g4evm_defconfig               |  722 ---------
>  arch/arm/configs/h3600_defconfig               | 1084 -------------
>  arch/arm/configs/h5000_defconfig               |  917 +-----------
>  arch/arm/configs/h7201_defconfig               |  542 +-------
>  arch/arm/configs/h7202_defconfig               |  697 +--------
>  arch/arm/configs/hackkit_defconfig             |  735 +---------
>  arch/arm/configs/htcherald_defconfig           | 1073 +-------------
>  arch/arm/configs/igep0020_defconfig            | 1467 -----------------
>  arch/arm/configs/imote2_defconfig              | 1649 +-------------------
>  arch/arm/configs/integrator_defconfig          |  817 +----------
>  arch/arm/configs/iop13xx_defconfig             | 1061 +------------
>  arch/arm/configs/iop32x_defconfig              | 1282 +---------------
>  arch/arm/configs/iop33x_defconfig              | 1300 ---------------
>  arch/arm/configs/ixp2000_defconfig             | 1024 +------------
>  arch/arm/configs/ixp23xx_defconfig             | 1315 +---------------
>  arch/arm/configs/ixp4xx_defconfig              | 1394 +----------------
>  arch/arm/configs/jornada720_defconfig          | 1062 -------------
>  arch/arm/configs/kafa_defconfig                |  830 +----------
>  arch/arm/configs/kb9202_defconfig              | 1179 +--------------
>  arch/arm/configs/kirkwood_defconfig            | 1700 --------------------
>  arch/arm/configs/ks8695_defconfig              |  946 -----------
>  arch/arm/configs/lart_defconfig                |  824 +----------
>  arch/arm/configs/loki_defconfig                | 1028 +------------
>  arch/arm/configs/lpd270_defconfig              |  968 +------------
>  arch/arm/configs/lpd7a400_defconfig            |  835 +----------
>  arch/arm/configs/lpd7a404_defconfig            | 1050 +------------
>  arch/arm/configs/lubbock_defconfig             |  762 +---------
>  arch/arm/configs/lusl7200_defconfig            |  436 +-----
>  arch/arm/configs/magician_defconfig            | 1358 +----------------
>  arch/arm/configs/mainstone_defconfig           |  755 +---------
>  arch/arm/configs/mini2440_defconfig            | 1722 +--------------------
>  arch/arm/configs/mmp2_defconfig                | 1135 -------------
>  arch/arm/configs/msm_defconfig                 |  830 +----------
>  arch/arm/configs/mv78xx0_defconfig             | 1547 ------------------
>  arch/arm/configs/mx1_defconfig                 | 1018 +------------
>  arch/arm/configs/mx21_defconfig                | 1072 -------------
>  arch/arm/configs/mx27_defconfig                | 1152 --------------
>  arch/arm/configs/mx31pdk_defconfig             |  728 ---------
>  arch/arm/configs/mx3_defconfig                 | 1089 -------------
>  arch/arm/configs/mx51_defconfig                | 1130 -------------
>  arch/arm/configs/n770_defconfig                | 1283 ---------------
>  arch/arm/configs/n8x0_defconfig                | 1134 +-------------
>  arch/arm/configs/neocore926_defconfig          | 1205 +--------------
>  arch/arm/configs/neponset_defconfig            | 1081 +-------------
>  arch/arm/configs/netwinder_defconfig           |  978 +------------
>  arch/arm/configs/netx_defconfig                |  845 +----------
>  arch/arm/configs/nhk8815_defconfig             | 1185 +--------------
>  arch/arm/configs/ns9xxx_defconfig              |   23 -
>  arch/arm/configs/nuc910_defconfig              |  844 ----------
>  arch/arm/configs/nuc950_defconfig              |  896 -----------
>  arch/arm/configs/nuc960_defconfig              |  855 ----------
>  arch/arm/configs/omap3_beagle_defconfig        | 1258 +---------------
>  arch/arm/configs/omap3_defconfig               | 1969 -----------------------
>  arch/arm/configs/omap3_evm_defconfig           | 1429 +-----------------
>  arch/arm/configs/omap3_pandora_defconfig       | 1640 +-------------------
>  arch/arm/configs/omap3_stalker_lks_defconfig   | 1541 ------------------
>  arch/arm/configs/omap3_touchbook_defconfig     | 1809 ---------------------
>  arch/arm/configs/omap_2430sdp_defconfig        | 1181 +--------------
>  arch/arm/configs/omap_3430sdp_defconfig        | 1553 +------------------
>  arch/arm/configs/omap_3630sdp_defconfig        | 1456 -----------------
>  arch/arm/configs/omap_4430sdp_defconfig        | 1157 --------------
>  arch/arm/configs/omap_apollon_2420_defconfig   |  873 +----------
>  arch/arm/configs/omap_generic_1510_defconfig   | 1089 +-------------
>  arch/arm/configs/omap_generic_1610_defconfig   | 1092 +-------------
>  arch/arm/configs/omap_generic_1710_defconfig   | 1014 +------------
>  arch/arm/configs/omap_generic_2420_defconfig   |  619 +--------
>  arch/arm/configs/omap_h2_1610_defconfig        | 1234 +---------------
>  arch/arm/configs/omap_h4_2420_defconfig        | 1018 +------------
>  arch/arm/configs/omap_innovator_1510_defconfig | 1152 +--------------
>  arch/arm/configs/omap_innovator_1610_defconfig |  780 ---------
>  arch/arm/configs/omap_ldp_defconfig            | 1124 -------------
>  arch/arm/configs/omap_osk_5912_defconfig       | 1003 ------------
>  arch/arm/configs/omap_perseus2_730_defconfig   |  862 ----------
>  arch/arm/configs/omap_zoom2_defconfig          | 1408 +-----------------
>  arch/arm/configs/omap_zoom3_defconfig          | 1455 -----------------
>  arch/arm/configs/onearm_defconfig              | 1067 +-------------
>  arch/arm/configs/orion5x_defconfig             | 1693 --------------------
>  arch/arm/configs/overo_defconfig               | 1621 +-------------------
>  arch/arm/configs/palmte_defconfig              |  712 ---------
>  arch/arm/configs/palmtt_defconfig              |  801 +----------
>  arch/arm/configs/palmz71_defconfig             |  839 +----------
>  arch/arm/configs/palmz72_defconfig             |  865 ----------
>  arch/arm/configs/pcm027_defconfig              |  993 ------------
>  arch/arm/configs/picotux200_defconfig          | 1207 +--------------
>  arch/arm/configs/pleb_defconfig                |  712 +--------
>  arch/arm/configs/pnx4008_defconfig             | 1286 +---------------
>  arch/arm/configs/pxa168_defconfig              |  903 -----------
>  arch/arm/configs/pxa255-idp_defconfig          |  753 +---------
>  arch/arm/configs/pxa3xx_defconfig              | 1207 +--------------
>  arch/arm/configs/pxa910_defconfig              |  820 ----------
>  arch/arm/configs/qil-a9260_defconfig           | 1146 +--------------
>  arch/arm/configs/raumfeld_defconfig            | 1690 --------------------
>  arch/arm/configs/realview-smp_defconfig        | 1005 ------------
>  arch/arm/configs/realview_defconfig            | 1001 ------------
>  arch/arm/configs/rpc_defconfig                 |  882 +-----------
>  arch/arm/configs/rx51_defconfig                | 1648 +-------------------
>  arch/arm/configs/s3c2410_defconfig             | 2018 ------------------------
>  arch/arm/configs/s3c6400_defconfig             | 1445 -----------------
>  arch/arm/configs/s5p6440_defconfig             |  947 -----------
>  arch/arm/configs/s5p6442_defconfig             |  842 ----------
>  arch/arm/configs/s5pc100_defconfig             |  977 ------------
>  arch/arm/configs/s5pc110_defconfig             |  858 ----------
>  arch/arm/configs/s5pv210_defconfig             |  861 ----------
>  arch/arm/configs/sam9_l9260_defconfig          |  962 +-----------
>  arch/arm/configs/shannon_defconfig             |  837 +----------
>  arch/arm/configs/shark_defconfig               | 1167 --------------
>  arch/arm/configs/simpad_defconfig              |  886 +----------
>  arch/arm/configs/spear300_defconfig            |  722 ---------
>  arch/arm/configs/spear310_defconfig            |  723 ---------
>  arch/arm/configs/spear320_defconfig            |  723 ---------
>  arch/arm/configs/spear600_defconfig            |  711 ---------
>  arch/arm/configs/spitz_defconfig               | 1547 +------------------
>  arch/arm/configs/stamp9g20_defconfig           | 1327 ----------------
>  arch/arm/configs/stmp378x_defconfig            | 1014 +------------
>  arch/arm/configs/stmp37xx_defconfig            |  895 +-----------
>  arch/arm/configs/sx1_defconfig                 | 1015 +------------
>  arch/arm/configs/tct_hammer_defconfig          |  817 +----------
>  arch/arm/configs/trizeps4_defconfig            | 1502 +-----------------
>  arch/arm/configs/u300_defconfig                | 1118 -------------
>  arch/arm/configs/u8500_defconfig               |  621 --------
>  arch/arm/configs/usb-a9260_defconfig           | 1039 +------------
>  arch/arm/configs/usb-a9263_defconfig           | 1031 +------------
>  arch/arm/configs/versatile_defconfig           |  928 +-----------
>  arch/arm/configs/viper_defconfig               | 1502 ------------------
>  arch/arm/configs/xcep_defconfig                | 1031 +------------
>  arch/arm/configs/yl9200_defconfig              | 1084 +-------------
>  arch/arm/configs/zeus_defconfig                | 1842 ---------------------
>  177 files changed, 652 insertions(+), 194157 deletions(-)
> 
> -- 
> Pengutronix e.K.                           | Uwe Kleine-König            |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
> 

--Boundary_(ID_YdAI2/JX+r5wVUKOeROmKA)--
