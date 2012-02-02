Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932254Ab2BBVYE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 16:24:04 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46172 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754885Ab2BBVYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 16:24:00 -0500
Date: Thu, 2 Feb 2012 22:23:53 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: stigge@antcom.de
Cc: bangaragiri.g@nxp.com, srinivas.bakki@nxp.com,
        sundarapandian.andithevar@nxp.com, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH v3 1/7] ARM: LPC32xx: Added lpc32xx_defconfig
Message-ID: <20120202212353.GA15298@pengutronix.de>
References: <1328210388-21296-1-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MGYHOYXEY6WxJCY8"
Content-Disposition: inline
In-Reply-To: <1328210388-21296-1-git-send-email-stigge@antcom.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MGYHOYXEY6WxJCY8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 02, 2012 at 08:19:42PM +0100, stigge@antcom.de wrote:
> This patch adds a working defconfig for the LPC32XX architecture. It is a
> general default configuration for the PHY3250 reference board and others
> based on LPC32XX.
>=20
> Signed-off-by: Roland Stigge <stigge@antcom.de>
> Tested-by: Wolfram Sang <w.sang@pengutronix.de>

Well, I said I will create a branch, but this series looks pretty much
appliable as is to me (except maybe that the defconfig patch should come
last).

Arnd, Olof: Can you pick it up, or do you need some more preparation?

Thanks,

   Wolfram

>=20
> diff --git a/arch/arm/configs/lpc32xx_defconfig b/arch/arm/configs/lpc32x=
x_defconfig
> new file mode 100644
> index 0000000..fb20881
> --- /dev/null
> +++ b/arch/arm/configs/lpc32xx_defconfig
> @@ -0,0 +1,145 @@
> +CONFIG_EXPERIMENTAL=3Dy
> +CONFIG_SYSVIPC=3Dy
> +CONFIG_IKCONFIG=3Dy
> +CONFIG_IKCONFIG_PROC=3Dy
> +CONFIG_LOG_BUF_SHIFT=3D14
> +CONFIG_SYSFS_DEPRECATED=3Dy
> +CONFIG_SYSFS_DEPRECATED_V2=3Dy
> +CONFIG_BLK_DEV_INITRD=3Dy
> +CONFIG_CC_OPTIMIZE_FOR_SIZE=3Dy
> +CONFIG_SYSCTL_SYSCALL=3Dy
> +CONFIG_EMBEDDED=3Dy
> +CONFIG_SLAB=3Dy
> +CONFIG_MODULES=3Dy
> +CONFIG_MODULE_UNLOAD=3Dy
> +# CONFIG_BLK_DEV_BSG is not set
> +CONFIG_PARTITION_ADVANCED=3Dy
> +CONFIG_ARCH_LPC32XX=3Dy
> +CONFIG_NO_HZ=3Dy
> +CONFIG_HIGH_RES_TIMERS=3Dy
> +CONFIG_PREEMPT=3Dy
> +CONFIG_AEABI=3Dy
> +CONFIG_ZBOOT_ROM_TEXT=3D0x0
> +CONFIG_ZBOOT_ROM_BSS=3D0x0
> +CONFIG_CMDLINE=3D"console=3DttyS0,115200n81 root=3D/dev/ram0"
> +CONFIG_CPU_IDLE=3Dy
> +CONFIG_FPE_NWFPE=3Dy
> +CONFIG_VFP=3Dy
> +# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
> +CONFIG_BINFMT_AOUT=3Dy
> +CONFIG_NET=3Dy
> +CONFIG_PACKET=3Dy
> +CONFIG_UNIX=3Dy
> +CONFIG_INET=3Dy
> +CONFIG_IP_MULTICAST=3Dy
> +CONFIG_IP_PNP=3Dy
> +CONFIG_IP_PNP_DHCP=3Dy
> +CONFIG_IP_PNP_BOOTP=3Dy
> +# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
> +# CONFIG_INET_XFRM_MODE_TUNNEL is not set
> +# CONFIG_INET_XFRM_MODE_BEET is not set
> +# CONFIG_INET_LRO is not set
> +# CONFIG_INET_DIAG is not set
> +# CONFIG_IPV6 is not set
> +# CONFIG_WIRELESS is not set
> +CONFIG_UEVENT_HELPER_PATH=3D"/sbin/hotplug"
> +# CONFIG_FW_LOADER is not set
> +CONFIG_MTD=3Dy
> +CONFIG_MTD_CMDLINE_PARTS=3Dy
> +CONFIG_MTD_CHAR=3Dy
> +CONFIG_MTD_BLOCK=3Dy
> +CONFIG_MTD_NAND=3Dy
> +CONFIG_MTD_NAND_MUSEUM_IDS=3Dy
> +CONFIG_BLK_DEV_LOOP=3Dy
> +CONFIG_BLK_DEV_CRYPTOLOOP=3Dy
> +CONFIG_BLK_DEV_RAM=3Dy
> +CONFIG_BLK_DEV_RAM_COUNT=3D1
> +CONFIG_BLK_DEV_RAM_SIZE=3D16384
> +CONFIG_MISC_DEVICES=3Dy
> +CONFIG_EEPROM_AT25=3Dy
> +CONFIG_SCSI=3Dy
> +CONFIG_BLK_DEV_SD=3Dy
> +CONFIG_NETDEVICES=3Dy
> +CONFIG_MII=3Dy
> +CONFIG_PHYLIB=3Dy
> +CONFIG_SMSC_PHY=3Dy
> +# CONFIG_WLAN is not set
> +# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
> +CONFIG_INPUT_MOUSEDEV_SCREEN_X=3D240
> +CONFIG_INPUT_MOUSEDEV_SCREEN_Y=3D320
> +CONFIG_INPUT_EVDEV=3Dy
> +# CONFIG_INPUT_MOUSE is not set
> +CONFIG_INPUT_TOUCHSCREEN=3Dy
> +CONFIG_TOUCHSCREEN_LPC32XX=3Dy
> +# CONFIG_LEGACY_PTYS is not set
> +CONFIG_SERIAL_8250=3Dy
> +CONFIG_SERIAL_8250_CONSOLE=3Dy
> +# CONFIG_HW_RANDOM is not set
> +CONFIG_I2C=3Dy
> +CONFIG_I2C_CHARDEV=3Dy
> +CONFIG_I2C_PNX=3Dy
> +CONFIG_SPI=3Dy
> +CONFIG_SPI_PL022=3Dy
> +CONFIG_GPIO_SYSFS=3Dy
> +# CONFIG_HWMON is not set
> +CONFIG_WATCHDOG=3Dy
> +CONFIG_PNX4008_WATCHDOG=3Dy
> +CONFIG_FB=3Dy
> +CONFIG_FB_ARMCLCD=3Dy
> +CONFIG_FRAMEBUFFER_CONSOLE=3Dy
> +CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=3Dy
> +CONFIG_LOGO=3Dy
> +# CONFIG_LOGO_LINUX_MONO is not set
> +# CONFIG_LOGO_LINUX_VGA16 is not set
> +CONFIG_SOUND=3Dy
> +CONFIG_SND=3Dy
> +CONFIG_SND_SEQUENCER=3Dy
> +CONFIG_SND_MIXER_OSS=3Dy
> +CONFIG_SND_PCM_OSS=3Dy
> +CONFIG_SND_SEQUENCER_OSS=3Dy
> +CONFIG_SND_DYNAMIC_MINORS=3Dy
> +# CONFIG_SND_VERBOSE_PROCFS is not set
> +# CONFIG_SND_DRIVERS is not set
> +# CONFIG_SND_ARM is not set
> +# CONFIG_SND_SPI is not set
> +CONFIG_SND_SOC=3Dy
> +# CONFIG_HID_SUPPORT is not set
> +CONFIG_USB=3Dy
> +CONFIG_USB_STORAGE=3Dy
> +CONFIG_USB_LIBUSUAL=3Dy
> +CONFIG_MMC=3Dy
> +# CONFIG_MMC_BLOCK_BOUNCE is not set
> +CONFIG_MMC_ARMMMCI=3Dy
> +CONFIG_NEW_LEDS=3Dy
> +CONFIG_LEDS_CLASS=3Dy
> +CONFIG_LEDS_GPIO=3Dy
> +CONFIG_LEDS_TRIGGERS=3Dy
> +CONFIG_LEDS_TRIGGER_HEARTBEAT=3Dy
> +CONFIG_RTC_CLASS=3Dy
> +CONFIG_RTC_INTF_DEV_UIE_EMUL=3Dy
> +CONFIG_RTC_DRV_LPC32XX=3Dy
> +CONFIG_EXT2_FS=3Dy
> +CONFIG_AUTOFS4_FS=3Dy
> +CONFIG_MSDOS_FS=3Dy
> +CONFIG_VFAT_FS=3Dy
> +CONFIG_TMPFS=3Dy
> +CONFIG_JFFS2_FS=3Dy
> +CONFIG_JFFS2_FS_WBUF_VERIFY=3Dy
> +CONFIG_CRAMFS=3Dy
> +CONFIG_NFS_FS=3Dy
> +CONFIG_NFS_V3=3Dy
> +CONFIG_ROOT_NFS=3Dy
> +CONFIG_NLS_CODEPAGE_437=3Dy
> +CONFIG_NLS_ASCII=3Dy
> +CONFIG_NLS_ISO8859_1=3Dy
> +CONFIG_NLS_UTF8=3Dy
> +# CONFIG_SCHED_DEBUG is not set
> +# CONFIG_DEBUG_PREEMPT is not set
> +CONFIG_DEBUG_INFO=3Dy
> +# CONFIG_FTRACE is not set
> +# CONFIG_ARM_UNWIND is not set
> +CONFIG_DEBUG_LL=3Dy
> +CONFIG_EARLY_PRINTK=3Dy
> +CONFIG_CRYPTO_ANSI_CPRNG=3Dy
> +# CONFIG_CRYPTO_HW is not set
> +CONFIG_CRC_CCITT=3Dy

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--MGYHOYXEY6WxJCY8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk8q/ukACgkQD27XaX1/VRuOqQCgoHnD8nT6JfhB5Sn6vj1UFiYF
kuIAn3WVErggknXi+bfI71nevu5x4D5A
=dFjH
-----END PGP SIGNATURE-----

--MGYHOYXEY6WxJCY8--
