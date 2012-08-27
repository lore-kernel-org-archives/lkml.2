Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753Ab2H0Vye (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 17:54:34 -0400
Received: from smtp.outflux.net ([198.145.64.163]:53486 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754531Ab2H0VyU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 17:54:20 -0400
Date: Mon, 27 Aug 2012 14:53:56 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Dave Jones <davej@redhat.com>
Subject: [PATCH] Remove CONFIG_EXPERIMENTAL
Message-ID: <20120827215356.GA27961@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This config item has not carried much meaning for a while now and is
almost always enabled by default. Remove it and adjust various config
logic and documentation.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 Documentation/CodingStyle                          |   10 +--
 Documentation/DocBook/kernel-hacking.tmpl          |    7 --
 Documentation/DocBook/kgdb.tmpl                    |    6 +-
 Documentation/hwmon/submitting-patches             |    3 +-
 Documentation/intel_txt.txt                        |    2 +-
 Documentation/laptops/thinkpad-acpi.txt            |    2 +-
 Documentation/networking/cs89x0.txt                |    8 +-
 Documentation/zh_CN/CodingStyle                    |    7 --
 arch/Kconfig                                       |    4 +-
 arch/alpha/Kconfig                                 |    5 +-
 arch/alpha/defconfig                               |    1 -
 arch/arm/Kconfig                                   |   55 +++++++-------
 arch/arm/Kconfig.debug                             |    4 +-
 arch/arm/configs/acs5k_defconfig                   |    1 -
 arch/arm/configs/acs5k_tiny_defconfig              |    1 -
 arch/arm/configs/afeb9260_defconfig                |    1 -
 arch/arm/configs/ag5evm_defconfig                  |    1 -
 arch/arm/configs/am200epdkit_defconfig             |    1 -
 arch/arm/configs/ap4evb_defconfig                  |    1 -
 arch/arm/configs/armadillo800eva_defconfig         |    1 -
 arch/arm/configs/assabet_defconfig                 |    1 -
 arch/arm/configs/at91_dt_defconfig                 |    1 -
 arch/arm/configs/at91rm9200_defconfig              |    1 -
 arch/arm/configs/at91sam9260_defconfig             |    1 -
 arch/arm/configs/at91sam9261_defconfig             |    1 -
 arch/arm/configs/at91sam9263_defconfig             |    1 -
 arch/arm/configs/at91sam9g20_defconfig             |    1 -
 arch/arm/configs/at91sam9g45_defconfig             |    1 -
 arch/arm/configs/at91sam9rl_defconfig              |    1 -
 arch/arm/configs/at91x40_defconfig                 |    1 -
 arch/arm/configs/badge4_defconfig                  |    1 -
 arch/arm/configs/bcmring_defconfig                 |    1 -
 arch/arm/configs/bonito_defconfig                  |    1 -
 arch/arm/configs/cam60_defconfig                   |    1 -
 arch/arm/configs/cerfcube_defconfig                |    1 -
 arch/arm/configs/cm_x2xx_defconfig                 |    1 -
 arch/arm/configs/cm_x300_defconfig                 |    1 -
 arch/arm/configs/cns3420vb_defconfig               |    1 -
 arch/arm/configs/colibri_pxa270_defconfig          |    1 -
 arch/arm/configs/colibri_pxa300_defconfig          |    1 -
 arch/arm/configs/collie_defconfig                  |    1 -
 arch/arm/configs/corgi_defconfig                   |    1 -
 arch/arm/configs/cpu9260_defconfig                 |    1 -
 arch/arm/configs/cpu9g20_defconfig                 |    1 -
 arch/arm/configs/da8xx_omapl_defconfig             |    1 -
 arch/arm/configs/davinci_all_defconfig             |    1 -
 arch/arm/configs/dove_defconfig                    |    1 -
 arch/arm/configs/ebsa110_defconfig                 |    1 -
 arch/arm/configs/edb7211_defconfig                 |    1 -
 arch/arm/configs/em_x270_defconfig                 |    1 -
 arch/arm/configs/ep93xx_defconfig                  |    1 -
 arch/arm/configs/eseries_pxa_defconfig             |    1 -
 arch/arm/configs/exynos4_defconfig                 |    1 -
 arch/arm/configs/exynos_defconfig                  |    1 -
 arch/arm/configs/ezx_defconfig                     |    1 -
 arch/arm/configs/footbridge_defconfig              |    1 -
 arch/arm/configs/fortunet_defconfig                |    1 -
 arch/arm/configs/g3evm_defconfig                   |    1 -
 arch/arm/configs/g4evm_defconfig                   |    1 -
 arch/arm/configs/h3600_defconfig                   |    1 -
 arch/arm/configs/h5000_defconfig                   |    1 -
 arch/arm/configs/h7201_defconfig                   |    1 -
 arch/arm/configs/h7202_defconfig                   |    1 -
 arch/arm/configs/hackkit_defconfig                 |    1 -
 arch/arm/configs/imote2_defconfig                  |    1 -
 arch/arm/configs/imx_v4_v5_defconfig               |    1 -
 arch/arm/configs/imx_v6_v7_defconfig               |    1 -
 arch/arm/configs/integrator_defconfig              |    1 -
 arch/arm/configs/iop13xx_defconfig                 |    1 -
 arch/arm/configs/iop32x_defconfig                  |    1 -
 arch/arm/configs/iop33x_defconfig                  |    1 -
 arch/arm/configs/ixp4xx_defconfig                  |    1 -
 arch/arm/configs/jornada720_defconfig              |    1 -
 arch/arm/configs/kirkwood_defconfig                |    1 -
 arch/arm/configs/kota2_defconfig                   |    1 -
 arch/arm/configs/ks8695_defconfig                  |    1 -
 arch/arm/configs/kzm9d_defconfig                   |    1 -
 arch/arm/configs/kzm9g_defconfig                   |    1 -
 arch/arm/configs/lart_defconfig                    |    1 -
 arch/arm/configs/lpc32xx_defconfig                 |    1 -
 arch/arm/configs/lpd270_defconfig                  |    1 -
 arch/arm/configs/lubbock_defconfig                 |    1 -
 arch/arm/configs/mackerel_defconfig                |    1 -
 arch/arm/configs/magician_defconfig                |    1 -
 arch/arm/configs/mainstone_defconfig               |    1 -
 arch/arm/configs/marzen_defconfig                  |    1 -
 arch/arm/configs/mini2440_defconfig                |    1 -
 arch/arm/configs/mmp2_defconfig                    |    1 -
 arch/arm/configs/msm_defconfig                     |    1 -
 arch/arm/configs/mv78xx0_defconfig                 |    1 -
 arch/arm/configs/mvebu_defconfig                   |    1 -
 arch/arm/configs/mxs_defconfig                     |    1 -
 arch/arm/configs/neponset_defconfig                |    1 -
 arch/arm/configs/netwinder_defconfig               |    1 -
 arch/arm/configs/netx_defconfig                    |    1 -
 arch/arm/configs/nhk8815_defconfig                 |    1 -
 arch/arm/configs/nuc910_defconfig                  |    1 -
 arch/arm/configs/nuc950_defconfig                  |    1 -
 arch/arm/configs/nuc960_defconfig                  |    1 -
 arch/arm/configs/omap1_defconfig                   |    1 -
 arch/arm/configs/omap2plus_defconfig               |    1 -
 arch/arm/configs/orion5x_defconfig                 |    1 -
 arch/arm/configs/palmz72_defconfig                 |    1 -
 arch/arm/configs/pcm027_defconfig                  |    1 -
 arch/arm/configs/pleb_defconfig                    |    1 -
 arch/arm/configs/pnx4008_defconfig                 |    1 -
 arch/arm/configs/prima2_defconfig                  |    1 -
 arch/arm/configs/pxa168_defconfig                  |    1 -
 arch/arm/configs/pxa255-idp_defconfig              |    1 -
 arch/arm/configs/pxa3xx_defconfig                  |    1 -
 arch/arm/configs/pxa910_defconfig                  |    1 -
 arch/arm/configs/qil-a9260_defconfig               |    1 -
 arch/arm/configs/raumfeld_defconfig                |    1 -
 arch/arm/configs/realview-smp_defconfig            |    1 -
 arch/arm/configs/realview_defconfig                |    1 -
 arch/arm/configs/rpc_defconfig                     |    1 -
 arch/arm/configs/s3c2410_defconfig                 |    1 -
 arch/arm/configs/s3c6400_defconfig                 |    1 -
 arch/arm/configs/s5p64x0_defconfig                 |    1 -
 arch/arm/configs/s5pc100_defconfig                 |    1 -
 arch/arm/configs/s5pv210_defconfig                 |    1 -
 arch/arm/configs/sam9_l9260_defconfig              |    1 -
 arch/arm/configs/shannon_defconfig                 |    1 -
 arch/arm/configs/shark_defconfig                   |    1 -
 arch/arm/configs/simpad_defconfig                  |    1 -
 arch/arm/configs/socfpga_defconfig                 |    1 -
 arch/arm/configs/spear13xx_defconfig               |    1 -
 arch/arm/configs/spear3xx_defconfig                |    1 -
 arch/arm/configs/spear6xx_defconfig                |    1 -
 arch/arm/configs/spitz_defconfig                   |    1 -
 arch/arm/configs/stamp9g20_defconfig               |    1 -
 arch/arm/configs/tct_hammer_defconfig              |    1 -
 arch/arm/configs/tegra_defconfig                   |    1 -
 arch/arm/configs/trizeps4_defconfig                |    1 -
 arch/arm/configs/u300_defconfig                    |    1 -
 arch/arm/configs/u8500_defconfig                   |    1 -
 arch/arm/configs/usb-a9260_defconfig               |    1 -
 arch/arm/configs/versatile_defconfig               |    1 -
 arch/arm/configs/vexpress_defconfig                |    1 -
 arch/arm/configs/viper_defconfig                   |    1 -
 arch/arm/configs/xcep_defconfig                    |    1 -
 arch/arm/configs/zeus_defconfig                    |    1 -
 arch/arm/mach-s3c24xx/Kconfig                      |    4 +-
 arch/avr32/configs/atngw100_defconfig              |    1 -
 arch/avr32/configs/atngw100_evklcd100_defconfig    |    1 -
 arch/avr32/configs/atngw100_evklcd101_defconfig    |    1 -
 arch/avr32/configs/atngw100_mrmt_defconfig         |    1 -
 arch/avr32/configs/atngw100mkii_defconfig          |    1 -
 .../avr32/configs/atngw100mkii_evklcd100_defconfig |    1 -
 .../avr32/configs/atngw100mkii_evklcd101_defconfig |    1 -
 arch/avr32/configs/atstk1002_defconfig             |    1 -
 arch/avr32/configs/atstk1003_defconfig             |    1 -
 arch/avr32/configs/atstk1004_defconfig             |    1 -
 arch/avr32/configs/atstk1006_defconfig             |    1 -
 arch/avr32/configs/favr-32_defconfig               |    1 -
 arch/avr32/configs/hammerhead_defconfig            |    1 -
 arch/avr32/configs/merisc_defconfig                |    1 -
 arch/avr32/configs/mimc200_defconfig               |    1 -
 arch/blackfin/Kconfig                              |    6 +-
 arch/blackfin/configs/BF518F-EZBRD_defconfig       |    1 -
 arch/blackfin/configs/BF526-EZBRD_defconfig        |    1 -
 arch/blackfin/configs/BF527-AD7160-EVAL_defconfig  |    1 -
 arch/blackfin/configs/BF527-EZKIT-V2_defconfig     |    1 -
 arch/blackfin/configs/BF527-EZKIT_defconfig        |    1 -
 arch/blackfin/configs/BF527-TLL6527M_defconfig     |    1 -
 arch/blackfin/configs/BF533-EZKIT_defconfig        |    1 -
 arch/blackfin/configs/BF533-STAMP_defconfig        |    1 -
 arch/blackfin/configs/BF537-STAMP_defconfig        |    1 -
 arch/blackfin/configs/BF538-EZKIT_defconfig        |    1 -
 arch/blackfin/configs/BF548-EZKIT_defconfig        |    1 -
 arch/blackfin/configs/BF561-ACVILON_defconfig      |    1 -
 arch/blackfin/configs/BF561-EZKIT-SMP_defconfig    |    1 -
 arch/blackfin/configs/BF561-EZKIT_defconfig        |    1 -
 arch/blackfin/configs/BF609-EZKIT_defconfig        |    1 -
 arch/blackfin/configs/BlackStamp_defconfig         |    1 -
 arch/blackfin/configs/CM-BF527_defconfig           |    1 -
 arch/blackfin/configs/CM-BF533_defconfig           |    1 -
 arch/blackfin/configs/CM-BF537E_defconfig          |    1 -
 arch/blackfin/configs/CM-BF537U_defconfig          |    1 -
 arch/blackfin/configs/CM-BF548_defconfig           |    1 -
 arch/blackfin/configs/CM-BF561_defconfig           |    1 -
 arch/blackfin/configs/DNP5370_defconfig            |    1 -
 arch/blackfin/configs/H8606_defconfig              |    1 -
 arch/blackfin/configs/IP0X_defconfig               |    1 -
 arch/blackfin/configs/PNAV-10_defconfig            |    1 -
 arch/blackfin/configs/SRV1_defconfig               |    1 -
 arch/blackfin/configs/TCM-BF518_defconfig          |    1 -
 arch/blackfin/configs/TCM-BF537_defconfig          |    1 -
 arch/c6x/configs/dsk6455_defconfig                 |    1 -
 arch/c6x/configs/evmc6457_defconfig                |    1 -
 arch/c6x/configs/evmc6472_defconfig                |    1 -
 arch/c6x/configs/evmc6474_defconfig                |    1 -
 arch/c6x/configs/evmc6678_defconfig                |    1 -
 arch/cris/arch-v32/drivers/Kconfig                 |    4 +-
 arch/cris/configs/artpec_3_defconfig               |    1 -
 arch/cris/configs/etrax-100lx_defconfig            |    1 -
 arch/cris/configs/etrax-100lx_v2_defconfig         |    1 -
 arch/cris/configs/etraxfs_defconfig                |    1 -
 arch/frv/defconfig                                 |    1 -
 arch/h8300/defconfig                               |    1 -
 arch/hexagon/configs/comet_defconfig               |    1 -
 arch/ia64/Kconfig                                  |    8 +-
 arch/ia64/configs/bigsur_defconfig                 |    1 -
 arch/ia64/configs/generic_defconfig                |    1 -
 arch/ia64/configs/gensparse_defconfig              |    1 -
 arch/ia64/configs/sim_defconfig                    |    1 -
 arch/ia64/configs/tiger_defconfig                  |    1 -
 arch/ia64/configs/xen_domu_defconfig               |    1 -
 arch/ia64/configs/zx1_defconfig                    |    1 -
 arch/ia64/kvm/Kconfig                              |    2 +-
 arch/ia64/xen/Kconfig                              |    2 +-
 arch/m32r/configs/m32104ut_defconfig               |    1 -
 arch/m32r/configs/m32700ut.smp_defconfig           |    1 -
 arch/m32r/configs/m32700ut.up_defconfig            |    1 -
 arch/m32r/configs/mappi.nommu_defconfig            |    1 -
 arch/m32r/configs/mappi.smp_defconfig              |    1 -
 arch/m32r/configs/mappi.up_defconfig               |    1 -
 arch/m32r/configs/mappi2.opsp_defconfig            |    1 -
 arch/m32r/configs/mappi2.vdec2_defconfig           |    1 -
 arch/m32r/configs/mappi3.smp_defconfig             |    1 -
 arch/m32r/configs/oaks32r_defconfig                |    1 -
 arch/m32r/configs/opsput_defconfig                 |    1 -
 arch/m32r/configs/usrv_defconfig                   |    1 -
 arch/m68k/Kconfig.bus                              |    4 +-
 arch/m68k/Kconfig.cpu                              |    3 +-
 arch/m68k/Kconfig.debug                            |    2 +-
 arch/m68k/Kconfig.devices                          |    6 +-
 arch/m68k/configs/amiga_defconfig                  |    1 -
 arch/m68k/configs/apollo_defconfig                 |    1 -
 arch/m68k/configs/atari_defconfig                  |    1 -
 arch/m68k/configs/bvme6000_defconfig               |    1 -
 arch/m68k/configs/hp300_defconfig                  |    1 -
 arch/m68k/configs/m5208evb_defconfig               |    1 -
 arch/m68k/configs/m5249evb_defconfig               |    1 -
 arch/m68k/configs/m5272c3_defconfig                |    1 -
 arch/m68k/configs/m5275evb_defconfig               |    1 -
 arch/m68k/configs/m5307c3_defconfig                |    1 -
 arch/m68k/configs/m5407c3_defconfig                |    1 -
 arch/m68k/configs/m5475evb_defconfig               |    1 -
 arch/m68k/configs/mac_defconfig                    |    1 -
 arch/m68k/configs/multi_defconfig                  |    1 -
 arch/m68k/configs/mvme147_defconfig                |    1 -
 arch/m68k/configs/mvme16x_defconfig                |    1 -
 arch/m68k/configs/q40_defconfig                    |    1 -
 arch/m68k/configs/sun3_defconfig                   |    1 -
 arch/m68k/configs/sun3x_defconfig                  |    1 -
 arch/microblaze/configs/mmu_defconfig              |    1 -
 arch/microblaze/configs/nommu_defconfig            |    1 -
 arch/microblaze/platform/Kconfig.platform          |    2 +-
 arch/mips/Kconfig                                  |   21 +----
 arch/mips/configs/ar7_defconfig                    |    1 -
 arch/mips/configs/bcm47xx_defconfig                |    1 -
 arch/mips/configs/bcm63xx_defconfig                |    1 -
 arch/mips/configs/bigsur_defconfig                 |    1 -
 arch/mips/configs/capcella_defconfig               |    1 -
 arch/mips/configs/cavium-octeon_defconfig          |    1 -
 arch/mips/configs/cobalt_defconfig                 |    1 -
 arch/mips/configs/db1000_defconfig                 |    1 -
 arch/mips/configs/db1200_defconfig                 |    1 -
 arch/mips/configs/db1300_defconfig                 |    1 -
 arch/mips/configs/db1550_defconfig                 |    1 -
 arch/mips/configs/decstation_defconfig             |    1 -
 arch/mips/configs/e55_defconfig                    |    1 -
 arch/mips/configs/fuloong2e_defconfig              |    1 -
 arch/mips/configs/gpr_defconfig                    |    1 -
 arch/mips/configs/ip22_defconfig                   |    1 -
 arch/mips/configs/ip27_defconfig                   |    1 -
 arch/mips/configs/ip28_defconfig                   |    1 -
 arch/mips/configs/ip32_defconfig                   |    1 -
 arch/mips/configs/jazz_defconfig                   |    1 -
 arch/mips/configs/lasat_defconfig                  |    1 -
 arch/mips/configs/lemote2f_defconfig               |    1 -
 arch/mips/configs/ls1b_defconfig                   |    1 -
 arch/mips/configs/malta_defconfig                  |    1 -
 arch/mips/configs/markeins_defconfig               |    1 -
 arch/mips/configs/mipssim_defconfig                |    1 -
 arch/mips/configs/mpc30x_defconfig                 |    1 -
 arch/mips/configs/msp71xx_defconfig                |    1 -
 arch/mips/configs/mtx1_defconfig                   |    1 -
 arch/mips/configs/nlm_xlp_defconfig                |    1 -
 arch/mips/configs/nlm_xlr_defconfig                |    1 -
 arch/mips/configs/pb1100_defconfig                 |    1 -
 arch/mips/configs/pb1500_defconfig                 |    1 -
 arch/mips/configs/pb1550_defconfig                 |    1 -
 arch/mips/configs/pnx8335-stb225_defconfig         |    1 -
 arch/mips/configs/pnx8550-jbs_defconfig            |    1 -
 arch/mips/configs/pnx8550-stb810_defconfig         |    1 -
 arch/mips/configs/powertv_defconfig                |    1 -
 arch/mips/configs/rb532_defconfig                  |    1 -
 arch/mips/configs/rm200_defconfig                  |    1 -
 arch/mips/configs/sb1250-swarm_defconfig           |    1 -
 arch/mips/configs/tb0219_defconfig                 |    1 -
 arch/mips/configs/tb0226_defconfig                 |    1 -
 arch/mips/configs/tb0287_defconfig                 |    1 -
 arch/mips/configs/workpad_defconfig                |    1 -
 arch/mips/configs/wrppmc_defconfig                 |    1 -
 arch/mips/jazz/Kconfig                             |    6 +-
 arch/mips/sgi-ip27/Kconfig                         |    1 -
 arch/mn10300/configs/asb2303_defconfig             |    1 -
 arch/mn10300/configs/asb2364_defconfig             |    1 -
 arch/parisc/Kconfig                                |    8 +-
 arch/parisc/configs/712_defconfig                  |    1 -
 arch/parisc/configs/a500_defconfig                 |    1 -
 arch/parisc/configs/c3000_defconfig                |    1 -
 arch/parisc/configs/default_defconfig              |    1 -
 arch/powerpc/Kconfig                               |   14 ++--
 arch/powerpc/configs/40x/acadia_defconfig          |    1 -
 arch/powerpc/configs/40x/ep405_defconfig           |    1 -
 arch/powerpc/configs/40x/kilauea_defconfig         |    1 -
 arch/powerpc/configs/40x/klondike_defconfig        |    1 -
 arch/powerpc/configs/40x/makalu_defconfig          |    1 -
 arch/powerpc/configs/40x/obs600_defconfig          |    1 -
 arch/powerpc/configs/40x/virtex_defconfig          |    1 -
 arch/powerpc/configs/40x/walnut_defconfig          |    1 -
 arch/powerpc/configs/44x/arches_defconfig          |    1 -
 arch/powerpc/configs/44x/bamboo_defconfig          |    1 -
 arch/powerpc/configs/44x/bluestone_defconfig       |    1 -
 arch/powerpc/configs/44x/canyonlands_defconfig     |    1 -
 arch/powerpc/configs/44x/currituck_defconfig       |    1 -
 arch/powerpc/configs/44x/ebony_defconfig           |    1 -
 arch/powerpc/configs/44x/eiger_defconfig           |    1 -
 arch/powerpc/configs/44x/icon_defconfig            |    1 -
 arch/powerpc/configs/44x/iss476-smp_defconfig      |    1 -
 arch/powerpc/configs/44x/katmai_defconfig          |    1 -
 arch/powerpc/configs/44x/rainier_defconfig         |    1 -
 arch/powerpc/configs/44x/redwood_defconfig         |    1 -
 arch/powerpc/configs/44x/sam440ep_defconfig        |    1 -
 arch/powerpc/configs/44x/sequoia_defconfig         |    1 -
 arch/powerpc/configs/44x/taishan_defconfig         |    1 -
 arch/powerpc/configs/44x/virtex5_defconfig         |    1 -
 arch/powerpc/configs/44x/warp_defconfig            |    1 -
 arch/powerpc/configs/52xx/cm5200_defconfig         |    1 -
 arch/powerpc/configs/52xx/lite5200b_defconfig      |    1 -
 arch/powerpc/configs/52xx/motionpro_defconfig      |    1 -
 arch/powerpc/configs/52xx/pcm030_defconfig         |    1 -
 arch/powerpc/configs/52xx/tqm5200_defconfig        |    1 -
 arch/powerpc/configs/83xx/asp8347_defconfig        |    1 -
 arch/powerpc/configs/83xx/kmeter1_defconfig        |    1 -
 arch/powerpc/configs/83xx/mpc8313_rdb_defconfig    |    1 -
 arch/powerpc/configs/83xx/mpc8315_rdb_defconfig    |    1 -
 arch/powerpc/configs/83xx/mpc832x_mds_defconfig    |    1 -
 arch/powerpc/configs/83xx/mpc832x_rdb_defconfig    |    1 -
 arch/powerpc/configs/83xx/mpc834x_itx_defconfig    |    1 -
 arch/powerpc/configs/83xx/mpc834x_itxgp_defconfig  |    1 -
 arch/powerpc/configs/83xx/mpc834x_mds_defconfig    |    1 -
 arch/powerpc/configs/83xx/mpc836x_mds_defconfig    |    1 -
 arch/powerpc/configs/83xx/mpc836x_rdk_defconfig    |    1 -
 arch/powerpc/configs/83xx/mpc837x_mds_defconfig    |    1 -
 arch/powerpc/configs/83xx/mpc837x_rdb_defconfig    |    1 -
 arch/powerpc/configs/83xx/sbc834x_defconfig        |    1 -
 arch/powerpc/configs/85xx/ge_imp3a_defconfig       |    1 -
 arch/powerpc/configs/85xx/ksi8560_defconfig        |    1 -
 arch/powerpc/configs/85xx/mpc8540_ads_defconfig    |    1 -
 arch/powerpc/configs/85xx/mpc8560_ads_defconfig    |    1 -
 arch/powerpc/configs/85xx/mpc85xx_cds_defconfig    |    1 -
 arch/powerpc/configs/85xx/p1023rds_defconfig       |    1 -
 arch/powerpc/configs/85xx/sbc8548_defconfig        |    1 -
 arch/powerpc/configs/85xx/socrates_defconfig       |    1 -
 arch/powerpc/configs/85xx/stx_gp3_defconfig        |    1 -
 arch/powerpc/configs/85xx/tqm8540_defconfig        |    1 -
 arch/powerpc/configs/85xx/tqm8541_defconfig        |    1 -
 arch/powerpc/configs/85xx/tqm8548_defconfig        |    1 -
 arch/powerpc/configs/85xx/tqm8555_defconfig        |    1 -
 arch/powerpc/configs/85xx/tqm8560_defconfig        |    1 -
 arch/powerpc/configs/85xx/xes_mpc85xx_defconfig    |    1 -
 arch/powerpc/configs/86xx/gef_ppc9a_defconfig      |    1 -
 arch/powerpc/configs/86xx/gef_sbc310_defconfig     |    1 -
 arch/powerpc/configs/86xx/gef_sbc610_defconfig     |    1 -
 arch/powerpc/configs/86xx/mpc8610_hpcd_defconfig   |    1 -
 arch/powerpc/configs/86xx/mpc8641_hpcn_defconfig   |    1 -
 arch/powerpc/configs/86xx/sbc8641d_defconfig       |    1 -
 arch/powerpc/configs/adder875_defconfig            |    1 -
 arch/powerpc/configs/amigaone_defconfig            |    1 -
 arch/powerpc/configs/c2k_defconfig                 |    1 -
 arch/powerpc/configs/cell_defconfig                |    1 -
 arch/powerpc/configs/celleb_defconfig              |    1 -
 arch/powerpc/configs/chroma_defconfig              |    1 -
 arch/powerpc/configs/chrp32_defconfig              |    1 -
 arch/powerpc/configs/corenet32_smp_defconfig       |    1 -
 arch/powerpc/configs/corenet64_smp_defconfig       |    1 -
 arch/powerpc/configs/ep88xc_defconfig              |    1 -
 arch/powerpc/configs/g5_defconfig                  |    1 -
 arch/powerpc/configs/gamecube_defconfig            |    1 -
 arch/powerpc/configs/holly_defconfig               |    1 -
 arch/powerpc/configs/linkstation_defconfig         |    1 -
 arch/powerpc/configs/maple_defconfig               |    1 -
 arch/powerpc/configs/mgcoge_defconfig              |    1 -
 arch/powerpc/configs/mpc512x_defconfig             |    1 -
 arch/powerpc/configs/mpc5200_defconfig             |    1 -
 arch/powerpc/configs/mpc7448_hpc2_defconfig        |    1 -
 arch/powerpc/configs/mpc83xx_defconfig             |    1 -
 arch/powerpc/configs/mpc85xx_defconfig             |    1 -
 arch/powerpc/configs/mpc85xx_smp_defconfig         |    1 -
 arch/powerpc/configs/mpc866_ads_defconfig          |    1 -
 arch/powerpc/configs/mpc86xx_defconfig             |    1 -
 arch/powerpc/configs/mpc885_ads_defconfig          |    1 -
 arch/powerpc/configs/pasemi_defconfig              |    1 -
 arch/powerpc/configs/pmac32_defconfig              |    1 -
 arch/powerpc/configs/ppc40x_defconfig              |    1 -
 arch/powerpc/configs/ppc44x_defconfig              |    1 -
 arch/powerpc/configs/ppc64_defconfig               |    1 -
 arch/powerpc/configs/ppc64e_defconfig              |    1 -
 arch/powerpc/configs/ppc6xx_defconfig              |    1 -
 arch/powerpc/configs/prpmc2800_defconfig           |    1 -
 arch/powerpc/configs/ps3_defconfig                 |    1 -
 arch/powerpc/configs/pseries_defconfig             |    1 -
 arch/powerpc/configs/storcenter_defconfig          |    1 -
 arch/powerpc/configs/tqm8xx_defconfig              |    1 -
 arch/powerpc/configs/wii_defconfig                 |    1 -
 arch/powerpc/kvm/Kconfig                           |   10 +-
 arch/powerpc/platforms/85xx/Kconfig                |    1 -
 arch/powerpc/platforms/cell/Kconfig                |    2 +-
 arch/powerpc/platforms/ps3/Kconfig                 |    2 +-
 arch/s390/Kconfig                                  |    4 +-
 arch/s390/defconfig                                |    1 -
 arch/s390/kvm/Kconfig                              |    2 +-
 arch/score/configs/spct6600_defconfig              |    1 -
 arch/sh/Kconfig                                    |   29 ++++----
 arch/sh/Kconfig.cpu                                |    3 +-
 arch/sh/configs/ap325rxa_defconfig                 |    1 -
 arch/sh/configs/apsh4a3a_defconfig                 |    1 -
 arch/sh/configs/apsh4ad0a_defconfig                |    1 -
 arch/sh/configs/cayman_defconfig                   |    1 -
 arch/sh/configs/dreamcast_defconfig                |    1 -
 arch/sh/configs/ecovec24-romimage_defconfig        |    1 -
 arch/sh/configs/ecovec24_defconfig                 |    1 -
 arch/sh/configs/edosk7760_defconfig                |    1 -
 arch/sh/configs/espt_defconfig                     |    1 -
 arch/sh/configs/hp6xx_defconfig                    |    1 -
 arch/sh/configs/kfr2r09-romimage_defconfig         |    1 -
 arch/sh/configs/kfr2r09_defconfig                  |    1 -
 arch/sh/configs/landisk_defconfig                  |    1 -
 arch/sh/configs/lboxre2_defconfig                  |    1 -
 arch/sh/configs/magicpanelr2_defconfig             |    1 -
 arch/sh/configs/microdev_defconfig                 |    1 -
 arch/sh/configs/migor_defconfig                    |    1 -
 arch/sh/configs/polaris_defconfig                  |    1 -
 arch/sh/configs/r7780mp_defconfig                  |    1 -
 arch/sh/configs/r7785rp_defconfig                  |    1 -
 arch/sh/configs/rsk7201_defconfig                  |    1 -
 arch/sh/configs/rsk7203_defconfig                  |    1 -
 arch/sh/configs/rts7751r2d1_defconfig              |    1 -
 arch/sh/configs/rts7751r2dplus_defconfig           |    1 -
 arch/sh/configs/sdk7780_defconfig                  |    1 -
 arch/sh/configs/sdk7786_defconfig                  |    1 -
 arch/sh/configs/se7206_defconfig                   |    1 -
 arch/sh/configs/se7343_defconfig                   |    1 -
 arch/sh/configs/se7619_defconfig                   |    1 -
 arch/sh/configs/se7705_defconfig                   |    1 -
 arch/sh/configs/se7712_defconfig                   |    1 -
 arch/sh/configs/se7721_defconfig                   |    1 -
 arch/sh/configs/se7722_defconfig                   |    1 -
 arch/sh/configs/se7724_defconfig                   |    1 -
 arch/sh/configs/se7750_defconfig                   |    1 -
 arch/sh/configs/se7751_defconfig                   |    1 -
 arch/sh/configs/secureedge5410_defconfig           |    1 -
 arch/sh/configs/sh03_defconfig                     |    1 -
 arch/sh/configs/sh2007_defconfig                   |    1 -
 arch/sh/configs/sh7710voipgw_defconfig             |    1 -
 arch/sh/configs/sh7724_generic_defconfig           |    1 -
 arch/sh/configs/sh7757lcr_defconfig                |    1 -
 arch/sh/configs/sh7763rdp_defconfig                |    1 -
 arch/sh/configs/sh7770_generic_defconfig           |    1 -
 arch/sh/configs/sh7785lcr_32bit_defconfig          |    1 -
 arch/sh/configs/sh7785lcr_defconfig                |    1 -
 arch/sh/configs/shmin_defconfig                    |    1 -
 arch/sh/configs/shx3_defconfig                     |    1 -
 arch/sh/configs/titan_defconfig                    |    1 -
 arch/sh/configs/ul2_defconfig                      |    1 -
 arch/sh/configs/urquell_defconfig                  |    1 -
 arch/sh/mm/Kconfig                                 |    4 +-
 arch/sparc/configs/sparc32_defconfig               |    1 -
 arch/sparc/configs/sparc64_defconfig               |    1 -
 arch/tile/configs/tilegx_defconfig                 |    1 -
 arch/tile/configs/tilepro_defconfig                |    1 -
 arch/tile/kvm/Kconfig                              |    2 +-
 arch/um/Kconfig.net                                |    2 +-
 arch/um/Kconfig.um                                 |    8 +-
 arch/um/defconfig                                  |    1 -
 arch/unicore32/Kconfig                             |    2 +-
 arch/unicore32/configs/unicore32_defconfig         |    1 -
 arch/x86/Kconfig                                   |   22 +++---
 arch/x86/configs/i386_defconfig                    |    1 -
 arch/x86/configs/x86_64_defconfig                  |    1 -
 arch/x86/um/Kconfig                                |    3 +-
 arch/xtensa/configs/common_defconfig               |    3 +-
 arch/xtensa/configs/iss_defconfig                  |    1 -
 arch/xtensa/configs/s6105_defconfig                |    1 -
 block/Kconfig                                      |    2 +-
 crypto/Kconfig                                     |   15 +---
 drivers/acpi/Kconfig                               |    9 +--
 drivers/ata/Kconfig                                |   24 +++---
 drivers/base/Kconfig                               |    7 +-
 drivers/block/Kconfig                              |   14 ++--
 drivers/block/paride/Kconfig                       |    4 +-
 drivers/char/Kconfig                               |    6 +-
 drivers/cpufreq/Kconfig.arm                        |    4 +-
 drivers/cpufreq/Kconfig.x86                        |    6 +-
 drivers/dma/Kconfig                                |    2 +-
 drivers/edac/Kconfig                               |    4 +-
 drivers/gpio/Kconfig                               |    2 +-
 drivers/gpu/drm/ast/Kconfig                        |    2 +-
 drivers/gpu/drm/cirrus/Kconfig                     |    2 +-
 drivers/gpu/drm/gma500/Kconfig                     |    2 +-
 drivers/gpu/drm/mgag200/Kconfig                    |    2 +-
 drivers/gpu/drm/udl/Kconfig                        |    2 +-
 drivers/hwmon/Kconfig                              |   79 ++++++++++----------
 drivers/hwmon/pmbus/Kconfig                        |    2 +-
 drivers/i2c/busses/Kconfig                         |   18 ++---
 drivers/i2c/muxes/Kconfig                          |    2 -
 drivers/ide/Kconfig                                |    8 +-
 drivers/idle/Kconfig                               |    1 -
 drivers/iio/dac/Kconfig                            |    2 +-
 drivers/input/keyboard/Kconfig                     |    2 +-
 drivers/input/misc/Kconfig                         |    7 +-
 drivers/iommu/Kconfig                              |    8 +-
 drivers/isdn/hisax/Kconfig                         |   15 ++--
 drivers/leds/Kconfig                               |    2 +-
 drivers/lguest/Kconfig                             |    2 +-
 drivers/macintosh/Kconfig                          |    2 +-
 drivers/md/Kconfig                                 |   25 +++---
 drivers/md/persistent-data/Kconfig                 |    2 +-
 drivers/media/Kconfig                              |    7 +-
 drivers/media/common/tuners/Kconfig                |    5 +-
 drivers/media/dvb/dvb-usb/Kconfig                  |    4 +-
 drivers/media/video/Kconfig                        |   14 ++--
 drivers/media/video/cx18/Kconfig                   |    4 +-
 drivers/media/video/cx25821/Kconfig                |    2 +-
 drivers/media/video/pvrusb2/Kconfig                |    8 +-
 drivers/media/video/s5p-fimc/Kconfig               |    1 -
 drivers/media/video/s5p-tv/Kconfig                 |    1 -
 drivers/media/video/zoran/Kconfig                  |    4 +-
 drivers/memstick/Kconfig                           |    2 +-
 drivers/memstick/host/Kconfig                      |   12 ++--
 drivers/misc/Kconfig                               |   14 ++--
 drivers/misc/c2port/Kconfig                        |    5 +-
 drivers/misc/eeprom/Kconfig                        |    2 +-
 drivers/misc/mei/Kconfig                           |    2 +-
 drivers/mmc/core/Kconfig                           |    3 +-
 drivers/mmc/host/Kconfig                           |   20 ++---
 drivers/mtd/Kconfig                                |    2 +-
 drivers/mtd/chips/Kconfig                          |    2 +-
 drivers/mtd/devices/Kconfig                        |    4 +-
 drivers/mtd/nand/Kconfig                           |    6 +-
 drivers/net/Kconfig                                |    9 +-
 drivers/net/ethernet/8390/Kconfig                  |   21 ++---
 drivers/net/ethernet/atheros/Kconfig               |    8 +-
 drivers/net/ethernet/dec/tulip/Kconfig             |    4 +-
 drivers/net/ethernet/fujitsu/Kconfig               |    6 +-
 drivers/net/ethernet/i825xx/Kconfig                |   12 +--
 drivers/net/ethernet/icplus/Kconfig                |    2 +-
 drivers/net/ethernet/intel/Kconfig                 |    9 +--
 drivers/net/ethernet/microchip/Kconfig             |    4 +-
 drivers/net/ethernet/natsemi/Kconfig               |    3 -
 drivers/net/ethernet/packetengines/Kconfig         |    4 +-
 drivers/net/ethernet/racal/Kconfig                 |    4 +-
 drivers/net/ethernet/realtek/Kconfig               |    4 +-
 drivers/net/ethernet/seeq/Kconfig                  |    4 +-
 drivers/net/ethernet/silan/Kconfig                 |    6 +-
 drivers/net/ethernet/stmicro/stmmac/Kconfig        |    4 +-
 drivers/net/ethernet/sun/Kconfig                   |    4 +-
 drivers/net/ethernet/ti/Kconfig                    |    4 +-
 drivers/net/hippi/Kconfig                          |    8 +-
 drivers/net/irda/Kconfig                           |   36 +++++-----
 drivers/net/ppp/Kconfig                            |   20 +++---
 drivers/net/team/Kconfig                           |    3 +-
 drivers/net/usb/Kconfig                            |   16 ++--
 drivers/net/wan/Kconfig                            |    8 +-
 drivers/net/wireless/Kconfig                       |   10 +-
 drivers/net/wireless/ath/ath6kl/Kconfig            |    1 -
 drivers/net/wireless/ath/carl9170/Kconfig          |    2 +-
 drivers/net/wireless/b43/Kconfig                   |   12 ++--
 drivers/net/wireless/ipw2x00/Kconfig               |    2 +-
 drivers/net/wireless/p54/Kconfig                   |    2 +-
 drivers/net/wireless/rt2x00/Kconfig                |   15 +---
 drivers/net/wireless/rtl818x/Kconfig               |    2 +-
 drivers/net/wireless/rtlwifi/Kconfig               |    8 +-
 drivers/net/wireless/ti/wl1251/Kconfig             |    2 +-
 drivers/net/wireless/zd1211rw/Kconfig              |    2 +-
 drivers/parport/Kconfig                            |   16 ++--
 drivers/pci/pcie/Kconfig                           |    2 +-
 drivers/pcmcia/Kconfig                             |    4 +-
 drivers/platform/x86/Kconfig                       |    6 +-
 drivers/pnp/pnpbios/Kconfig                        |    4 +-
 drivers/pps/Kconfig                                |    1 -
 drivers/ptp/Kconfig                                |    1 -
 drivers/remoteproc/Kconfig                         |    4 +-
 drivers/rpmsg/Kconfig                              |    3 +-
 drivers/sbus/char/Kconfig                          |    7 +-
 drivers/scsi/Kconfig                               |   18 ++--
 drivers/scsi/arm/Kconfig                           |   10 +-
 drivers/scsi/device_handler/Kconfig                |    4 +-
 drivers/spi/Kconfig                                |   19 ++---
 drivers/staging/bcm/Kconfig                        |    2 +-
 drivers/staging/usbip/Kconfig                      |    4 +-
 drivers/staging/winbond/Kconfig                    |    2 +-
 drivers/staging/wlags49_h2/man/wlags49.4           |    2 +-
 drivers/target/sbp/Kconfig                         |    2 +-
 drivers/tty/Kconfig                                |   11 +--
 drivers/tty/hvc/Kconfig                            |    2 +-
 drivers/tty/serial/Kconfig                         |    6 +-
 drivers/usb/core/Kconfig                           |    2 +-
 drivers/usb/gadget/Kconfig                         |   18 ++---
 drivers/usb/host/Kconfig                           |   22 +++---
 drivers/usb/wusbcore/Kconfig                       |    3 +-
 drivers/uwb/Kconfig                                |    3 +-
 drivers/vhost/Kconfig                              |    4 +-
 drivers/vhost/Kconfig.tcm                          |    4 +-
 drivers/video/Kconfig                              |   26 +++---
 drivers/video/console/Kconfig                      |    2 +-
 drivers/video/geode/Kconfig                        |   14 ++--
 drivers/video/omap/Kconfig                         |    2 +-
 drivers/virtio/Kconfig                             |   10 +-
 drivers/vlynq/Kconfig                              |    2 +-
 drivers/w1/masters/Kconfig                         |    2 +-
 drivers/watchdog/Kconfig                           |    4 +-
 fs/9p/Kconfig                                      |    3 +-
 fs/adfs/Kconfig                                    |    4 +-
 fs/affs/Kconfig                                    |    4 +-
 fs/afs/Kconfig                                     |    7 +-
 fs/befs/Kconfig                                    |    4 +-
 fs/bfs/Kconfig                                     |    4 +-
 fs/btrfs/Kconfig                                   |    3 +-
 fs/ceph/Kconfig                                    |    4 +-
 fs/cifs/Kconfig                                    |    8 +-
 fs/dlm/Kconfig                                     |    2 +-
 fs/ecryptfs/Kconfig                                |    4 +-
 fs/efs/Kconfig                                     |    4 +-
 fs/hfs/Kconfig                                     |    4 +-
 fs/jffs2/Kconfig                                   |   10 +-
 fs/logfs/Kconfig                                   |    4 +-
 fs/nfs/Kconfig                                     |    4 +-
 fs/nfsd/Kconfig                                    |    4 +-
 fs/nilfs2/Kconfig                                  |    3 +-
 fs/ufs/Kconfig                                     |    2 +-
 fs/xfs/Kconfig                                     |    4 +-
 init/Kconfig                                       |   54 +++-----------
 kernel/gcov/Kconfig                                |    2 +-
 lib/Kconfig                                        |    2 +-
 lib/Kconfig.debug                                  |    2 +-
 lib/Kconfig.kgdb                                   |    2 +-
 mm/Kconfig                                         |    1 -
 net/9p/Kconfig                                     |    2 +-
 net/Kconfig                                        |    5 +-
 net/ceph/Kconfig                                   |    4 +-
 net/dccp/Kconfig                                   |    4 +-
 net/dccp/ccids/Kconfig                             |    5 +-
 net/decnet/Kconfig                                 |    4 +-
 net/decnet/netfilter/Kconfig                       |    2 +-
 net/dsa/Kconfig                                    |    2 +-
 net/ieee802154/Kconfig                             |    3 +-
 net/ipv4/Kconfig                                   |   11 +---
 net/ipv4/netfilter/Kconfig                         |    4 +-
 net/ipv6/Kconfig                                   |   24 +++----
 net/l2tp/Kconfig                                   |    4 +-
 net/lapb/Kconfig                                   |    3 +-
 net/mac80211/Kconfig                               |    2 +-
 net/mac802154/Kconfig                              |    2 +-
 net/netfilter/Kconfig                              |   24 ++----
 net/nfc/Kconfig                                    |    4 +-
 net/nfc/llcp/Kconfig                               |    4 +-
 net/nfc/nci/Kconfig                                |    4 +-
 net/rds/Kconfig                                    |    4 +-
 net/rxrpc/Kconfig                                  |    2 +-
 net/sctp/Kconfig                                   |    4 +-
 net/sunrpc/Kconfig                                 |    2 +-
 net/tipc/Kconfig                                   |    4 +-
 net/wanrouter/Kconfig                              |    1 -
 net/x25/Kconfig                                    |    3 +-
 net/xfrm/Kconfig                                   |   16 ++--
 sound/drivers/Kconfig                              |    1 -
 sound/isa/Kconfig                                  |    4 +-
 sound/pci/hda/Kconfig                              |    5 +-
 sound/soc/fsl/Kconfig                              |    2 +-
 sound/usb/Kconfig                                  |    2 +-
 tools/lguest/lguest.txt                            |    8 +--
 676 files changed, 673 insertions(+), 1319 deletions(-)

diff --git a/Documentation/CodingStyle b/Documentation/CodingStyle
index cb9258b..52d63b0 100644
--- a/Documentation/CodingStyle
+++ b/Documentation/CodingStyle
@@ -536,15 +536,7 @@ config AUDIT
 	  logging of avc messages output).  Does not do system-call
 	  auditing without CONFIG_AUDITSYSCALL.
 
-Features that might still be considered unstable should be defined as
-dependent on "EXPERIMENTAL":
-
-config SLUB
-	depends on EXPERIMENTAL && !ARCH_USES_SLAB_PAGE_STRUCT
-	bool "SLUB (Unqueued Allocator)"
-	...
-
-while seriously dangerous features (such as write support for certain
+Seriously dangerous features (such as write support for certain
 filesystems) should advertise this prominently in their prompt string:
 
 config ADFS_FS_RW
diff --git a/Documentation/DocBook/kernel-hacking.tmpl b/Documentation/DocBook/kernel-hacking.tmpl
index eee7142..22e0bd1 100644
--- a/Documentation/DocBook/kernel-hacking.tmpl
+++ b/Documentation/DocBook/kernel-hacking.tmpl
@@ -1185,13 +1185,6 @@ static struct block_device_operations opt_fops = {
     </para>
 
     <para>
-     You may well want to make your CONFIG option only visible if
-     <symbol>CONFIG_EXPERIMENTAL</symbol> is enabled: this serves as a
-     warning to users.  There many other fancy things you can do: see
-     the various <filename>Kconfig</filename> files for ideas.
-    </para>
-
-    <para>
      In your description of the option, make sure you address both the
      expert user and the user who knows nothing about your feature.  Mention
      incompatibilities and issues here.  <emphasis> Definitely
diff --git a/Documentation/DocBook/kgdb.tmpl b/Documentation/DocBook/kgdb.tmpl
index 4ee4ba3..f77358f 100644
--- a/Documentation/DocBook/kgdb.tmpl
+++ b/Documentation/DocBook/kgdb.tmpl
@@ -94,10 +94,8 @@
   <sect1 id="CompileKGDB">
     <title>Kernel config options for kgdb</title>
     <para>
-    To enable <symbol>CONFIG_KGDB</symbol> you should first turn on
-    "Prompt for development and/or incomplete code/drivers"
-    (CONFIG_EXPERIMENTAL) in  "General setup", then under the
-    "Kernel debugging" select "KGDB: kernel debugger".
+    To enable <symbol>CONFIG_KGDB</symbol> you should look under
+    "Kernel debugging" and select "KGDB: kernel debugger".
     </para>
     <para>
     While it is not a hard requirement that you have symbols in your
diff --git a/Documentation/hwmon/submitting-patches b/Documentation/hwmon/submitting-patches
index 790f774..843751c 100644
--- a/Documentation/hwmon/submitting-patches
+++ b/Documentation/hwmon/submitting-patches
@@ -60,8 +60,7 @@ increase the chances of your change being accepted.
 
 * Add the driver to Kconfig and Makefile in alphabetical order.
 
-* Make sure that all dependencies are listed in Kconfig. For new drivers, it
-  is most likely prudent to add a dependency on EXPERIMENTAL.
+* Make sure that all dependencies are listed in Kconfig.
 
 * Avoid forward declarations if you can. Rearrange the code if necessary.
 
diff --git a/Documentation/intel_txt.txt b/Documentation/intel_txt.txt
index 849de1a..91d89c5 100644
--- a/Documentation/intel_txt.txt
+++ b/Documentation/intel_txt.txt
@@ -192,7 +192,7 @@ grub.conf needs to be modified as follows:
 
 The kernel option for enabling Intel TXT support is found under the
 Security top-level menu and is called "Enable Intel(R) Trusted
-Execution Technology (TXT)".  It is marked as EXPERIMENTAL and
+Execution Technology (TXT)".  It is considered EXPERIMENTAL and
 depends on the generic x86 support (to allow maximum flexibility in
 kernel build options), since the tboot code will detect whether the
 platform actually supports Intel TXT and thus whether any of the
diff --git a/Documentation/laptops/thinkpad-acpi.txt b/Documentation/laptops/thinkpad-acpi.txt
index 9d66682..cf7bc6c 100644
--- a/Documentation/laptops/thinkpad-acpi.txt
+++ b/Documentation/laptops/thinkpad-acpi.txt
@@ -1398,7 +1398,7 @@ Sysfs notes:
 EXPERIMENTAL: UWB
 -----------------
 
-This feature is marked EXPERIMENTAL because it has not been extensively
+This feature is considered EXPERIMENTAL because it has not been extensively
 tested and validated in various ThinkPad models yet.  The feature may not
 work as expected. USE WITH CAUTION! To use this feature, you need to supply
 the experimental=1 parameter when loading the module.
diff --git a/Documentation/networking/cs89x0.txt b/Documentation/networking/cs89x0.txt
index c725d33..cc91a15 100644
--- a/Documentation/networking/cs89x0.txt
+++ b/Documentation/networking/cs89x0.txt
@@ -386,15 +386,13 @@ tristate 'CS89x0 support' CONFIG_CS89x0
 
 Example:
 
-     if [ "$CONFIG_EXPERIMENTAL" = "y" ]; then
-       tristate 'ICL EtherTeam 16i/32 support' CONFIG_ETH16I
-     fi
+     tristate 'ICL EtherTeam 16i/32 support' CONFIG_ETH16I
 
      tristate 'CS89x0 support' CONFIG_CS89x0
 
      tristate 'NE2000/NE1000 support' CONFIG_NE2000
-     if [ "$CONFIG_EXPERIMENTAL" = "y" ]; then
-       tristate 'NI5210 support' CONFIG_NI52
+
+     tristate 'NI5210 support' CONFIG_NI52
 
 
 b.) In /usr/src/linux/drivers/net/Makefile, add the following lines: 
diff --git a/Documentation/zh_CN/CodingStyle b/Documentation/zh_CN/CodingStyle
index ecd9307..654afd7 100644
--- a/Documentation/zh_CN/CodingStyle
+++ b/Documentation/zh_CN/CodingStyle
@@ -462,13 +462,6 @@ config AUDIT
 	  logging of avc messages output).  Does not do system-call
 	  auditing without CONFIG_AUDITSYSCALL.
 
-仍然被认为不够稳定的功能应该被定义为依赖于“EXPERIMENTAL”：
-
-config SLUB
-	depends on EXPERIMENTAL && !ARCH_USES_SLAB_PAGE_STRUCT
-	bool "SLUB (Unqueued Allocator)"
-	...
-
 而那些危险的功能（比如某些文件系统的写支持）应该在它们的提示字符串里显著的声明这
 一点：
 
diff --git a/arch/Kconfig b/arch/Kconfig
index 72f2fa1..86692ef 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -16,7 +16,7 @@ config OPROFILE
 	  If unsure, say N.
 
 config OPROFILE_EVENT_MULTIPLEX
-	bool "OProfile multiplexing support (EXPERIMENTAL)"
+	bool "OProfile multiplexing support"
 	default n
 	depends on OPROFILE && X86
 	help
@@ -77,7 +77,7 @@ config OPTPROBES
 	depends on !PREEMPT
 
 config UPROBES
-	bool "Transparent user-space probes (EXPERIMENTAL)"
+	bool "Transparent user-space probes"
 	depends on UPROBE_EVENT && PERF_EVENTS
 	default n
 	help
diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
index 9944ded..b2503fc 100644
--- a/arch/alpha/Kconfig
+++ b/arch/alpha/Kconfig
@@ -553,8 +553,7 @@ config NR_CPUS
           with working support have a maximum of 4 CPUs.
 
 config ARCH_DISCONTIGMEM_ENABLE
-	bool "Discontiguous Memory Support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	bool "Discontiguous Memory Support"
 	help
 	  Say Y to support efficient handling of discontiguous physical memory,
 	  for architectures which are either NUMA (Non-Uniform Memory Access)
@@ -564,7 +563,7 @@ config ARCH_DISCONTIGMEM_ENABLE
 source "mm/Kconfig"
 
 config NUMA
-	bool "NUMA Support (EXPERIMENTAL)"
+	bool "NUMA Support"
 	depends on DISCONTIGMEM && BROKEN
 	help
 	  Say Y to compile the kernel to support NUMA (Non-Uniform Memory
diff --git a/arch/alpha/defconfig b/arch/alpha/defconfig
index 539e8b5..c72072a 100644
--- a/arch/alpha/defconfig
+++ b/arch/alpha/defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index c5f9ae5..b844777 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1516,8 +1516,7 @@ config SMP
 	  If you don't know what to do here, say N.
 
 config SMP_ON_UP
-	bool "Allow booting SMP kernel on uniprocessor systems (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	bool "Allow booting SMP kernel on uniprocessor systems"
 	depends on SMP && !XIP_KERNEL
 	default y
 	help
@@ -1600,8 +1599,8 @@ config NR_CPUS
 	default "4"
 
 config HOTPLUG_CPU
-	bool "Support for hot-pluggable CPUs (EXPERIMENTAL)"
-	depends on SMP && HOTPLUG && EXPERIMENTAL
+	bool "Support for hot-pluggable CPUs"
+	depends on SMP && HOTPLUG
 	help
 	  Say Y here to experiment with turning CPUs off and on.  CPUs
 	  can be controlled through /sys/devices/system/cpu.
@@ -1641,8 +1640,8 @@ config HZ
 	default 100
 
 config THUMB2_KERNEL
-	bool "Compile the kernel in Thumb-2 mode (EXPERIMENTAL)"
-	depends on CPU_V7 && !CPU_V6 && !CPU_V6K && EXPERIMENTAL
+	bool "Compile the kernel in Thumb-2 mode"
+	depends on CPU_V7 && !CPU_V6 && !CPU_V6K
 	select AEABI
 	select ARM_ASM_UNIFIED
 	select ARM_UNWIND
@@ -1703,8 +1702,8 @@ config AEABI
 	  To use this you need GCC version 4.0.0 or later.
 
 config OABI_COMPAT
-	bool "Allow old ABI binaries to run with this kernel (EXPERIMENTAL)"
-	depends on AEABI && EXPERIMENTAL && !THUMB2_KERNEL
+	bool "Allow old ABI binaries to run with this kernel"
+	depends on AEABI && !THUMB2_KERNEL
 	default y
 	help
 	  This option preserves the old syscall interface along with the
@@ -1849,8 +1848,8 @@ config ALIGNMENT_TRAP
 	  configuration it is safe to say N, otherwise say Y.
 
 config UACCESS_WITH_MEMCPY
-	bool "Use kernel mem{cpy,set}() for {copy_to,clear}_user() (EXPERIMENTAL)"
-	depends on MMU && EXPERIMENTAL
+	bool "Use kernel mem{cpy,set}() for {copy_to,clear}_user()"
+	depends on MMU
 	default y if CPU_FEROCEON
 	help
 	  Implement faster copy_to_user and clear_user methods for CPU
@@ -1879,8 +1878,7 @@ config SECCOMP
 	  defined by each seccomp mode.
 
 config CC_STACKPROTECTOR
-	bool "Enable -fstack-protector buffer overflow detection (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	bool "Enable -fstack-protector buffer overflow detection"
 	help
 	  This option turns on the -fstack-protector GCC feature. This
 	  feature puts, at the beginning of functions, a canary value on
@@ -1943,8 +1941,8 @@ config ZBOOT_ROM
 	  (zImage) directly from ROM or flash.  If unsure, say N.
 
 choice
-	prompt "Include SD/MMC loader in zImage (EXPERIMENTAL)"
-	depends on ZBOOT_ROM && ARCH_SH7372 && EXPERIMENTAL
+	prompt "Include SD/MMC loader in zImage"
+	depends on ZBOOT_ROM && ARCH_SH7372
 	default ZBOOT_ROM_NONE
 	help
 	  Include experimental SD/MMC loading code in the ROM-able zImage.
@@ -1955,25 +1953,25 @@ choice
 	  rest the kernel image to RAM.
 
 config ZBOOT_ROM_NONE
-	bool "No SD/MMC loader in zImage (EXPERIMENTAL)"
+	bool "No SD/MMC loader in zImage"
 	help
 	  Do not load image from SD or MMC
 
 config ZBOOT_ROM_MMCIF
-	bool "Include MMCIF loader in zImage (EXPERIMENTAL)"
+	bool "Include MMCIF loader in zImage"
 	help
 	  Load image from MMCIF hardware block.
 
 config ZBOOT_ROM_SH_MOBILE_SDHI
-	bool "Include SuperH Mobile SDHI loader in zImage (EXPERIMENTAL)"
+	bool "Include SuperH Mobile SDHI loader in zImage"
 	help
 	  Load image from SDHI hardware block
 
 endchoice
 
 config ARM_APPENDED_DTB
-	bool "Use appended device tree blob to zImage (EXPERIMENTAL)"
-	depends on OF && !ZBOOT_ROM && EXPERIMENTAL
+	bool "Use appended device tree blob to zImage"
+	depends on OF && !ZBOOT_ROM
 	help
 	  With this option, the boot code will look for a device tree binary
 	  (DTB) appended to zImage
@@ -2089,8 +2087,8 @@ config XIP_PHYS_ADDR
 	  own flash usage.
 
 config KEXEC
-	bool "Kexec system call (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && (!SMP || HOTPLUG_CPU)
+	bool "Kexec system call"
+	depends on (!SMP || HOTPLUG_CPU)
 	help
 	  kexec is a system call that implements the ability to shutdown your
 	  current kernel, and to start another kernel.  It is like a reboot
@@ -2111,8 +2109,7 @@ config ATAGS_PROC
 	  file in procfs. Useful with kexec.
 
 config CRASH_DUMP
-	bool "Build kdump crash kernel (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	bool "Build kdump crash kernel"
 	help
 	  Generate crash dump after being started by kexec. This should
 	  be normally only set in special crash dump kernels which are
@@ -2178,8 +2175,8 @@ config CPU_FREQ_S3C
 	  Internal configuration node for common cpufreq on Samsung SoC
 
 config CPU_FREQ_S3C24XX
-	bool "CPUfreq driver for Samsung S3C24XX series CPUs (EXPERIMENTAL)"
-	depends on ARCH_S3C24XX && CPU_FREQ && EXPERIMENTAL
+	bool "CPUfreq driver for Samsung S3C24XX series CPUs"
+	depends on ARCH_S3C24XX && CPU_FREQ
 	select CPU_FREQ_S3C
 	help
 	  This enables the CPUfreq driver for the Samsung S3C24XX family
@@ -2190,8 +2187,8 @@ config CPU_FREQ_S3C24XX
 	  If in doubt, say N.
 
 config CPU_FREQ_S3C24XX_PLL
-	bool "Support CPUfreq changing of PLL frequency (EXPERIMENTAL)"
-	depends on CPU_FREQ_S3C24XX && EXPERIMENTAL
+	bool "Support CPUfreq changing of PLL frequency"
+	depends on CPU_FREQ_S3C24XX
 	help
 	  Compile in support for changing the PLL frequency from the
 	  S3C24XX series CPUfreq driver. The PLL takes time to settle
@@ -2253,8 +2250,8 @@ config FPE_NWFPE_XP
 	  You almost surely want to say N here.
 
 config FPE_FASTFPE
-	bool "FastFPE math emulation (EXPERIMENTAL)"
-	depends on (!AEABI || OABI_COMPAT) && !CPU_32v3 && EXPERIMENTAL
+	bool "FastFPE math emulation"
+	depends on (!AEABI || OABI_COMPAT) && !CPU_32v3
 	---help---
 	  Say Y here to include the FAST floating point emulator in the kernel.
 	  This is an experimental much faster emulator which now also has full
diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index f15f82b..abe6e0a 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -31,8 +31,8 @@ config FRAME_POINTER
 	  reported is severely limited.
 
 config ARM_UNWIND
-	bool "Enable stack unwinding support (EXPERIMENTAL)"
-	depends on AEABI && EXPERIMENTAL
+	bool "Enable stack unwinding support"
+	depends on AEABI
 	default y
 	help
 	  This option enables stack unwinding support in the kernel
diff --git a/arch/arm/configs/acs5k_defconfig b/arch/arm/configs/acs5k_defconfig
index 92b0f90..79f5d89 100644
--- a/arch/arm/configs/acs5k_defconfig
+++ b/arch/arm/configs/acs5k_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_SWAP is not set
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
diff --git a/arch/arm/configs/acs5k_tiny_defconfig b/arch/arm/configs/acs5k_tiny_defconfig
index 2a27a14..7cb1fb5 100644
--- a/arch/arm/configs/acs5k_tiny_defconfig
+++ b/arch/arm/configs/acs5k_tiny_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_SWAP is not set
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
diff --git a/arch/arm/configs/afeb9260_defconfig b/arch/arm/configs/afeb9260_defconfig
index 2afdf67..82717f7 100644
--- a/arch/arm/configs/afeb9260_defconfig
+++ b/arch/arm/configs/afeb9260_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
diff --git a/arch/arm/configs/ag5evm_defconfig b/arch/arm/configs/ag5evm_defconfig
index 212ead3..e896030 100644
--- a/arch/arm/configs/ag5evm_defconfig
+++ b/arch/arm/configs/ag5evm_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
diff --git a/arch/arm/configs/am200epdkit_defconfig b/arch/arm/configs/am200epdkit_defconfig
index f0dea52..3de611b 100644
--- a/arch/arm/configs/am200epdkit_defconfig
+++ b/arch/arm/configs/am200epdkit_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_LOCALVERSION="gum"
 # CONFIG_SWAP is not set
 CONFIG_SYSVIPC=y
diff --git a/arch/arm/configs/ap4evb_defconfig b/arch/arm/configs/ap4evb_defconfig
index 2eef85e..a823aa6 100644
--- a/arch/arm/configs/ap4evb_defconfig
+++ b/arch/arm/configs/ap4evb_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
diff --git a/arch/arm/configs/armadillo800eva_defconfig b/arch/arm/configs/armadillo800eva_defconfig
index 7d87184..d43eb03 100644
--- a/arch/arm/configs/armadillo800eva_defconfig
+++ b/arch/arm/configs/armadillo800eva_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
diff --git a/arch/arm/configs/assabet_defconfig b/arch/arm/configs/assabet_defconfig
index 558ecd8..e453e35 100644
--- a/arch/arm/configs/assabet_defconfig
+++ b/arch/arm/configs/assabet_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
diff --git a/arch/arm/configs/at91_dt_defconfig b/arch/arm/configs/at91_dt_defconfig
index 67bc571..c2b5928 100644
--- a/arch/arm/configs/at91_dt_defconfig
+++ b/arch/arm/configs/at91_dt_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 # CONFIG_SWAP is not set
 CONFIG_SYSVIPC=y
diff --git a/arch/arm/configs/at91rm9200_defconfig b/arch/arm/configs/at91rm9200_defconfig
index d54e2ac..363c7c3 100644
--- a/arch/arm/configs/at91rm9200_defconfig
+++ b/arch/arm/configs/at91rm9200_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 # CONFIG_SWAP is not set
 CONFIG_SYSVIPC=y
diff --git a/arch/arm/configs/at91sam9260_defconfig b/arch/arm/configs/at91sam9260_defconfig
index 505b376..5064f4f 100644
--- a/arch/arm/configs/at91sam9260_defconfig
+++ b/arch/arm/configs/at91sam9260_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 # CONFIG_SWAP is not set
 CONFIG_SYSVIPC=y
diff --git a/arch/arm/configs/at91sam9261_defconfig b/arch/arm/configs/at91sam9261_defconfig
index ade6b2f..07066cb 100644
--- a/arch/arm/configs/at91sam9261_defconfig
+++ b/arch/arm/configs/at91sam9261_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_KERNEL_LZMA=y
 # CONFIG_SWAP is not set
diff --git a/arch/arm/configs/at91sam9263_defconfig b/arch/arm/configs/at91sam9263_defconfig
index 1cf9626..448810c 100644
--- a/arch/arm/configs/at91sam9263_defconfig
+++ b/arch/arm/configs/at91sam9263_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_KERNEL_LZMA=y
 # CONFIG_SWAP is not set
diff --git a/arch/arm/configs/at91sam9g20_defconfig b/arch/arm/configs/at91sam9g20_defconfig
index 994d331..e1b2976 100644
--- a/arch/arm/configs/at91sam9g20_defconfig
+++ b/arch/arm/configs/at91sam9g20_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 # CONFIG_SWAP is not set
 CONFIG_SYSVIPC=y
diff --git a/arch/arm/configs/at91sam9g45_defconfig b/arch/arm/configs/at91sam9g45_defconfig
index 606d48f..7ac4a30 100644
--- a/arch/arm/configs/at91sam9g45_defconfig
+++ b/arch/arm/configs/at91sam9g45_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 # CONFIG_SWAP is not set
 CONFIG_SYSVIPC=y
diff --git a/arch/arm/configs/at91sam9rl_defconfig b/arch/arm/configs/at91sam9rl_defconfig
index ad562ee..01ed723 100644
--- a/arch/arm/configs/at91sam9rl_defconfig
+++ b/arch/arm/configs/at91sam9rl_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 # CONFIG_SWAP is not set
 CONFIG_SYSVIPC=y
diff --git a/arch/arm/configs/at91x40_defconfig b/arch/arm/configs/at91x40_defconfig
index c55e921..1e4c952 100644
--- a/arch/arm/configs/at91x40_defconfig
+++ b/arch/arm/configs/at91x40_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_EMBEDDED=y
 # CONFIG_HOTPLUG is not set
diff --git a/arch/arm/configs/badge4_defconfig b/arch/arm/configs/badge4_defconfig
index 5b54abb..8bf4790 100644
--- a/arch/arm/configs/badge4_defconfig
+++ b/arch/arm/configs/badge4_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_EXPERT=y
 CONFIG_MODULES=y
diff --git a/arch/arm/configs/bcmring_defconfig b/arch/arm/configs/bcmring_defconfig
index 9e6a8fe..d61ddb9 100644
--- a/arch/arm/configs/bcmring_defconfig
+++ b/arch/arm/configs/bcmring_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 # CONFIG_SWAP is not set
 CONFIG_SYSVIPC=y
diff --git a/arch/arm/configs/bonito_defconfig b/arch/arm/configs/bonito_defconfig
index 5457108..937dda6 100644
--- a/arch/arm/configs/bonito_defconfig
+++ b/arch/arm/configs/bonito_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
diff --git a/arch/arm/configs/cam60_defconfig b/arch/arm/configs/cam60_defconfig
index cedc92e..418278d 100644
--- a/arch/arm/configs/cam60_defconfig
+++ b/arch/arm/configs/cam60_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
diff --git a/arch/arm/configs/cerfcube_defconfig b/arch/arm/configs/cerfcube_defconfig
index dce912d..b19e6ee 100644
--- a/arch/arm/configs/cerfcube_defconfig
+++ b/arch/arm/configs/cerfcube_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_LOG_BUF_SHIFT=14
diff --git a/arch/arm/configs/cm_x2xx_defconfig b/arch/arm/configs/cm_x2xx_defconfig
index a93ff8d..a0cbee2 100644
--- a/arch/arm/configs/cm_x2xx_defconfig
+++ b/arch/arm/configs/cm_x2xx_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_IKCONFIG=y
diff --git a/arch/arm/configs/cm_x300_defconfig b/arch/arm/configs/cm_x300_defconfig
index f4b7672..4fb45d6 100644
--- a/arch/arm/configs/cm_x300_defconfig
+++ b/arch/arm/configs/cm_x300_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_LOCALVERSION="-cm-x300"
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
diff --git a/arch/arm/configs/cns3420vb_defconfig b/arch/arm/configs/cns3420vb_defconfig
index 313627a..b9b903e 100644
--- a/arch/arm/configs/cns3420vb_defconfig
+++ b/arch/arm/configs/cns3420vb_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 # CONFIG_SWAP is not set
 CONFIG_SYSVIPC=y
diff --git a/arch/arm/configs/colibri_pxa270_defconfig b/arch/arm/configs/colibri_pxa270_defconfig
index 2ef2c5e..cd38fa3 100644
--- a/arch/arm/configs/colibri_pxa270_defconfig
+++ b/arch/arm/configs/colibri_pxa270_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_BSD_PROCESS_ACCT=y
diff --git a/arch/arm/configs/colibri_pxa300_defconfig b/arch/arm/configs/colibri_pxa300_defconfig
index b985334..62d78d7 100644
--- a/arch/arm/configs/colibri_pxa300_defconfig
+++ b/arch/arm/configs/colibri_pxa300_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 # CONFIG_BLK_DEV_BSG is not set
diff --git a/arch/arm/configs/collie_defconfig b/arch/arm/configs/collie_defconfig
index 6c56ad0..9cec06e 100644
--- a/arch/arm/configs/collie_defconfig
+++ b/arch/arm/configs/collie_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_SWAP is not set
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
diff --git a/arch/arm/configs/corgi_defconfig b/arch/arm/configs/corgi_defconfig
index e53c475..f16e134 100644
--- a/arch/arm/configs/corgi_defconfig
+++ b/arch/arm/configs/corgi_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_LOG_BUF_SHIFT=14
diff --git a/arch/arm/configs/cpu9260_defconfig b/arch/arm/configs/cpu9260_defconfig
index bbf729e..30b939e 100644
--- a/arch/arm/configs/cpu9260_defconfig
+++ b/arch/arm/configs/cpu9260_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 # CONFIG_SWAP is not set
 CONFIG_SYSVIPC=y
diff --git a/arch/arm/configs/cpu9g20_defconfig b/arch/arm/configs/cpu9g20_defconfig
index e7d7942..182dd2a 100644
--- a/arch/arm/configs/cpu9g20_defconfig
+++ b/arch/arm/configs/cpu9g20_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 # CONFIG_SWAP is not set
 CONFIG_SYSVIPC=y
diff --git a/arch/arm/configs/da8xx_omapl_defconfig b/arch/arm/configs/da8xx_omapl_defconfig
index 88ccde0..a61a0fb 100644
--- a/arch/arm/configs/da8xx_omapl_defconfig
+++ b/arch/arm/configs/da8xx_omapl_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_SWAP is not set
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
diff --git a/arch/arm/configs/davinci_all_defconfig b/arch/arm/configs/davinci_all_defconfig
index 67b5abb..f3723ed 100644
--- a/arch/arm/configs/davinci_all_defconfig
+++ b/arch/arm/configs/davinci_all_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_SWAP is not set
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
diff --git a/arch/arm/configs/dove_defconfig b/arch/arm/configs/dove_defconfig
index 40db34c..854f05c 100644
--- a/arch/arm/configs/dove_defconfig
+++ b/arch/arm/configs/dove_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_EXPERT=y
diff --git a/arch/arm/configs/ebsa110_defconfig b/arch/arm/configs/ebsa110_defconfig
index 14559db..731a22a 100644
--- a/arch/arm/configs/ebsa110_defconfig
+++ b/arch/arm/configs/ebsa110_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_LOG_BUF_SHIFT=14
diff --git a/arch/arm/configs/edb7211_defconfig b/arch/arm/configs/edb7211_defconfig
index d52ded3..269fa62 100644
--- a/arch/arm/configs/edb7211_defconfig
+++ b/arch/arm/configs/edb7211_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
diff --git a/arch/arm/configs/em_x270_defconfig b/arch/arm/configs/em_x270_defconfig
index 60a21e0..cc2c3e6 100644
--- a/arch/arm/configs/em_x270_defconfig
+++ b/arch/arm/configs/em_x270_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_IKCONFIG=y
diff --git a/arch/arm/configs/ep93xx_defconfig b/arch/arm/configs/ep93xx_defconfig
index 8e97b2f..90f8634 100644
--- a/arch/arm/configs/ep93xx_defconfig
+++ b/arch/arm/configs/ep93xx_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
diff --git a/arch/arm/configs/eseries_pxa_defconfig b/arch/arm/configs/eseries_pxa_defconfig
index d68ac67..f201854 100644
--- a/arch/arm/configs/eseries_pxa_defconfig
+++ b/arch/arm/configs/eseries_pxa_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
diff --git a/arch/arm/configs/exynos4_defconfig b/arch/arm/configs/exynos4_defconfig
index bffe68e..21c54d5 100644
--- a/arch/arm/configs/exynos4_defconfig
+++ b/arch/arm/configs/exynos4_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_MODULES=y
diff --git a/arch/arm/configs/exynos_defconfig b/arch/arm/configs/exynos_defconfig
index e40b435..0faefad 100644
--- a/arch/arm/configs/exynos_defconfig
+++ b/arch/arm/configs/exynos_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_NO_HZ=y
 CONFIG_HIGH_RES_TIMERS=y
 CONFIG_BLK_DEV_INITRD=y
diff --git a/arch/arm/configs/ezx_defconfig b/arch/arm/configs/ezx_defconfig
index d95763d..03e2685 100644
--- a/arch/arm/configs/ezx_defconfig
+++ b/arch/arm/configs/ezx_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_LOCALVERSION="-ezx200910312315"
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
diff --git a/arch/arm/configs/footbridge_defconfig b/arch/arm/configs/footbridge_defconfig
index 038518a..895bbc6 100644
--- a/arch/arm/configs/footbridge_defconfig
+++ b/arch/arm/configs/footbridge_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_LOG_BUF_SHIFT=14
diff --git a/arch/arm/configs/fortunet_defconfig b/arch/arm/configs/fortunet_defconfig
index 840fced..c4b175a 100644
--- a/arch/arm/configs/fortunet_defconfig
+++ b/arch/arm/configs/fortunet_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
diff --git a/arch/arm/configs/g3evm_defconfig b/arch/arm/configs/g3evm_defconfig
index 4a336ab..f6b0cea 100644
--- a/arch/arm/configs/g3evm_defconfig
+++ b/arch/arm/configs/g3evm_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
diff --git a/arch/arm/configs/g4evm_defconfig b/arch/arm/configs/g4evm_defconfig
index 21c6d03..7eb1551 100644
--- a/arch/arm/configs/g4evm_defconfig
+++ b/arch/arm/configs/g4evm_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
diff --git a/arch/arm/configs/h3600_defconfig b/arch/arm/configs/h3600_defconfig
index 317960f..db07785 100644
--- a/arch/arm/configs/h3600_defconfig
+++ b/arch/arm/configs/h3600_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
diff --git a/arch/arm/configs/h5000_defconfig b/arch/arm/configs/h5000_defconfig
index 37903e3..d2c0e74 100644
--- a/arch/arm/configs/h5000_defconfig
+++ b/arch/arm/configs/h5000_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
diff --git a/arch/arm/configs/h7201_defconfig b/arch/arm/configs/h7201_defconfig
index bee94d2..3ba6a31 100644
--- a/arch/arm/configs/h7201_defconfig
+++ b/arch/arm/configs/h7201_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
diff --git a/arch/arm/configs/h7202_defconfig b/arch/arm/configs/h7202_defconfig
index 69405a7..a170cd6 100644
--- a/arch/arm/configs/h7202_defconfig
+++ b/arch/arm/configs/h7202_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_MODULES=y
diff --git a/arch/arm/configs/hackkit_defconfig b/arch/arm/configs/hackkit_defconfig
index bed8047..d509425 100644
--- a/arch/arm/configs/hackkit_defconfig
+++ b/arch/arm/configs/hackkit_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
diff --git a/arch/arm/configs/imote2_defconfig b/arch/arm/configs/imote2_defconfig
index fd996bb..a8c6cdb 100644
--- a/arch/arm/configs/imote2_defconfig
+++ b/arch/arm/configs/imote2_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
diff --git a/arch/arm/configs/imx_v4_v5_defconfig b/arch/arm/configs/imx_v4_v5_defconfig
index 78ed575..282b26d 100644
--- a/arch/arm/configs/imx_v4_v5_defconfig
+++ b/arch/arm/configs/imx_v4_v5_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_SWAP is not set
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
diff --git a/arch/arm/configs/imx_v6_v7_defconfig b/arch/arm/configs/imx_v6_v7_defconfig
index 3c9f32f..e0a22f3 100644
--- a/arch/arm/configs/imx_v6_v7_defconfig
+++ b/arch/arm/configs/imx_v6_v7_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_KERNEL_LZO=y
 CONFIG_SYSVIPC=y
diff --git a/arch/arm/configs/integrator_defconfig b/arch/arm/configs/integrator_defconfig
index a8314c3..b0286aa 100644
--- a/arch/arm/configs/integrator_defconfig
+++ b/arch/arm/configs/integrator_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_TINY_RCU=y
 CONFIG_IKCONFIG=y
diff --git a/arch/arm/configs/iop13xx_defconfig b/arch/arm/configs/iop13xx_defconfig
index 4fa94a1..a47cfc2 100644
--- a/arch/arm/configs/iop13xx_defconfig
+++ b/arch/arm/configs/iop13xx_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
diff --git a/arch/arm/configs/iop32x_defconfig b/arch/arm/configs/iop32x_defconfig
index 4f2ec3a..7c3d7b5 100644
--- a/arch/arm/configs/iop32x_defconfig
+++ b/arch/arm/configs/iop32x_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_LOG_BUF_SHIFT=14
diff --git a/arch/arm/configs/iop33x_defconfig b/arch/arm/configs/iop33x_defconfig
index aa36128..a9aba50 100644
--- a/arch/arm/configs/iop33x_defconfig
+++ b/arch/arm/configs/iop33x_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_LOG_BUF_SHIFT=14
diff --git a/arch/arm/configs/ixp4xx_defconfig b/arch/arm/configs/ixp4xx_defconfig
index 063e2ab..bae01a9 100644
--- a/arch/arm/configs/ixp4xx_defconfig
+++ b/arch/arm/configs/ixp4xx_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_LOG_BUF_SHIFT=14
diff --git a/arch/arm/configs/jornada720_defconfig b/arch/arm/configs/jornada720_defconfig
index ea80e7e..088ad58 100644
--- a/arch/arm/configs/jornada720_defconfig
+++ b/arch/arm/configs/jornada720_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
diff --git a/arch/arm/configs/kirkwood_defconfig b/arch/arm/configs/kirkwood_defconfig
index aeb3af5..7307782 100644
--- a/arch/arm/configs/kirkwood_defconfig
+++ b/arch/arm/configs/kirkwood_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=19
 CONFIG_PROFILING=y
diff --git a/arch/arm/configs/kota2_defconfig b/arch/arm/configs/kota2_defconfig
index b7735d6..00b3e76 100644
--- a/arch/arm/configs/kota2_defconfig
+++ b/arch/arm/configs/kota2_defconfig
@@ -1,5 +1,4 @@
 # CONFIG_ARM_PATCH_PHYS_VIRT is not set
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
diff --git a/arch/arm/configs/ks8695_defconfig b/arch/arm/configs/ks8695_defconfig
index 47c4883..bafb329 100644
--- a/arch/arm/configs/ks8695_defconfig
+++ b/arch/arm/configs/ks8695_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_SWAP is not set
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
diff --git a/arch/arm/configs/kzm9d_defconfig b/arch/arm/configs/kzm9d_defconfig
index 26146ff..7b4e760 100644
--- a/arch/arm/configs/kzm9d_defconfig
+++ b/arch/arm/configs/kzm9d_defconfig
@@ -1,5 +1,4 @@
 # CONFIG_ARM_PATCH_PHYS_VIRT is not set
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_NO_HZ=y
 CONFIG_IKCONFIG=y
diff --git a/arch/arm/configs/kzm9g_defconfig b/arch/arm/configs/kzm9g_defconfig
index 2388c86..095f010 100644
--- a/arch/arm/configs/kzm9g_defconfig
+++ b/arch/arm/configs/kzm9g_defconfig
@@ -1,5 +1,4 @@
 # CONFIG_ARM_PATCH_PHYS_VIRT is not set
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_IKCONFIG=y
diff --git a/arch/arm/configs/lart_defconfig b/arch/arm/configs/lart_defconfig
index faa2865..77bc3c2 100644
--- a/arch/arm/configs/lart_defconfig
+++ b/arch/arm/configs/lart_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
diff --git a/arch/arm/configs/lpc32xx_defconfig b/arch/arm/configs/lpc32xx_defconfig
index e42a0e3..7eb7ca4 100644
--- a/arch/arm/configs/lpc32xx_defconfig
+++ b/arch/arm/configs/lpc32xx_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_NO_HZ=y
 CONFIG_HIGH_RES_TIMERS=y
diff --git a/arch/arm/configs/lpd270_defconfig b/arch/arm/configs/lpd270_defconfig
index 1c8c9ee..b4f9a8b 100644
--- a/arch/arm/configs/lpd270_defconfig
+++ b/arch/arm/configs/lpd270_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SLAB=y
diff --git a/arch/arm/configs/lubbock_defconfig b/arch/arm/configs/lubbock_defconfig
index c4ba274..4763f6d 100644
--- a/arch/arm/configs/lubbock_defconfig
+++ b/arch/arm/configs/lubbock_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_MODULES=y
diff --git a/arch/arm/configs/mackerel_defconfig b/arch/arm/configs/mackerel_defconfig
index 306a2e2..b404bae 100644
--- a/arch/arm/configs/mackerel_defconfig
+++ b/arch/arm/configs/mackerel_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
diff --git a/arch/arm/configs/magician_defconfig b/arch/arm/configs/magician_defconfig
index a691ef4..2bde5b7 100644
--- a/arch/arm/configs/magician_defconfig
+++ b/arch/arm/configs/magician_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
diff --git a/arch/arm/configs/mainstone_defconfig b/arch/arm/configs/mainstone_defconfig
index 04efa1b..8f4f7de 100644
--- a/arch/arm/configs/mainstone_defconfig
+++ b/arch/arm/configs/mainstone_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_MODULES=y
diff --git a/arch/arm/configs/marzen_defconfig b/arch/arm/configs/marzen_defconfig
index 864f9a5..61a3464 100644
--- a/arch/arm/configs/marzen_defconfig
+++ b/arch/arm/configs/marzen_defconfig
@@ -1,5 +1,4 @@
 # CONFIG_ARM_PATCH_PHYS_VIRT is not set
-CONFIG_EXPERIMENTAL=y
 CONFIG_KERNEL_LZMA=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
diff --git a/arch/arm/configs/mini2440_defconfig b/arch/arm/configs/mini2440_defconfig
index 082175c..d338ff7 100644
--- a/arch/arm/configs/mini2440_defconfig
+++ b/arch/arm/configs/mini2440_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
diff --git a/arch/arm/configs/mmp2_defconfig b/arch/arm/configs/mmp2_defconfig
index 5a58452..3dc80cf 100644
--- a/arch/arm/configs/mmp2_defconfig
+++ b/arch/arm/configs/mmp2_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
diff --git a/arch/arm/configs/msm_defconfig b/arch/arm/configs/msm_defconfig
index 2b8f7af..d41a7a3 100644
--- a/arch/arm/configs/msm_defconfig
+++ b/arch/arm/configs/msm_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_BLK_DEV_INITRD=y
diff --git a/arch/arm/configs/mv78xx0_defconfig b/arch/arm/configs/mv78xx0_defconfig
index 7305ebd..b163f09 100644
--- a/arch/arm/configs/mv78xx0_defconfig
+++ b/arch/arm/configs/mv78xx0_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
diff --git a/arch/arm/configs/mvebu_defconfig b/arch/arm/configs/mvebu_defconfig
index 2e86b31..83c78a3 100644
--- a/arch/arm/configs/mvebu_defconfig
+++ b/arch/arm/configs/mvebu_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_NO_HZ=y
 CONFIG_HIGH_RES_TIMERS=y
diff --git a/arch/arm/configs/mxs_defconfig b/arch/arm/configs/mxs_defconfig
index 4edcfb4..3b14da0 100644
--- a/arch/arm/configs/mxs_defconfig
+++ b/arch/arm/configs/mxs_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_TASKSTATS=y
 CONFIG_TASK_DELAY_ACCT=y
diff --git a/arch/arm/configs/neponset_defconfig b/arch/arm/configs/neponset_defconfig
index d7dc992..cfb69e4 100644
--- a/arch/arm/configs/neponset_defconfig
+++ b/arch/arm/configs/neponset_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
diff --git a/arch/arm/configs/netwinder_defconfig b/arch/arm/configs/netwinder_defconfig
index 25ed772..26ec2b8 100644
--- a/arch/arm/configs/netwinder_defconfig
+++ b/arch/arm/configs/netwinder_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_ARCH_FOOTBRIDGE=y
diff --git a/arch/arm/configs/netx_defconfig b/arch/arm/configs/netx_defconfig
index 9c0ad79..96c7300 100644
--- a/arch/arm/configs/netx_defconfig
+++ b/arch/arm/configs/netx_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_BSD_PROCESS_ACCT=y
diff --git a/arch/arm/configs/nhk8815_defconfig b/arch/arm/configs/nhk8815_defconfig
index bf123c5..c4764ba 100644
--- a/arch/arm/configs/nhk8815_defconfig
+++ b/arch/arm/configs/nhk8815_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 # CONFIG_SWAP is not set
 CONFIG_SYSVIPC=y
diff --git a/arch/arm/configs/nuc910_defconfig b/arch/arm/configs/nuc910_defconfig
index 10180cf..29f5231 100644
--- a/arch/arm/configs/nuc910_defconfig
+++ b/arch/arm/configs/nuc910_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
diff --git a/arch/arm/configs/nuc950_defconfig b/arch/arm/configs/nuc950_defconfig
index 27aa873..975b063 100644
--- a/arch/arm/configs/nuc950_defconfig
+++ b/arch/arm/configs/nuc950_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
diff --git a/arch/arm/configs/nuc960_defconfig b/arch/arm/configs/nuc960_defconfig
index 56fd7ad..883ad5b 100644
--- a/arch/arm/configs/nuc960_defconfig
+++ b/arch/arm/configs/nuc960_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
diff --git a/arch/arm/configs/omap1_defconfig b/arch/arm/configs/omap1_defconfig
index dde2a1a..81afee1 100644
--- a/arch/arm/configs/omap1_defconfig
+++ b/arch/arm/configs/omap1_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_SWAP is not set
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
diff --git a/arch/arm/configs/omap2plus_defconfig b/arch/arm/configs/omap2plus_defconfig
index e58edc3..a575013 100644
--- a/arch/arm/configs/omap2plus_defconfig
+++ b/arch/arm/configs/omap2plus_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_BSD_PROCESS_ACCT=y
diff --git a/arch/arm/configs/orion5x_defconfig b/arch/arm/configs/orion5x_defconfig
index a288d70..6e6883b 100644
--- a/arch/arm/configs/orion5x_defconfig
+++ b/arch/arm/configs/orion5x_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
diff --git a/arch/arm/configs/palmz72_defconfig b/arch/arm/configs/palmz72_defconfig
index 4baa83c..b67f9c7 100644
--- a/arch/arm/configs/palmz72_defconfig
+++ b/arch/arm/configs/palmz72_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
diff --git a/arch/arm/configs/pcm027_defconfig b/arch/arm/configs/pcm027_defconfig
index 2f136c3..ebbd3ec 100644
--- a/arch/arm/configs/pcm027_defconfig
+++ b/arch/arm/configs/pcm027_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_SWAP is not set
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
diff --git a/arch/arm/configs/pleb_defconfig b/arch/arm/configs/pleb_defconfig
index cb08cc5..4c34c60 100644
--- a/arch/arm/configs/pleb_defconfig
+++ b/arch/arm/configs/pleb_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_SWAP is not set
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
diff --git a/arch/arm/configs/pnx4008_defconfig b/arch/arm/configs/pnx4008_defconfig
index 35a31cc..f7fcbe5 100644
--- a/arch/arm/configs/pnx4008_defconfig
+++ b/arch/arm/configs/pnx4008_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_BSD_PROCESS_ACCT=y
diff --git a/arch/arm/configs/prima2_defconfig b/arch/arm/configs/prima2_defconfig
index c328ac6..e8621ca 100644
--- a/arch/arm/configs/prima2_defconfig
+++ b/arch/arm/configs/prima2_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_RELAY=y
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_KALLSYMS_ALL=y
diff --git a/arch/arm/configs/pxa168_defconfig b/arch/arm/configs/pxa168_defconfig
index 74d7e01..d3b7a87 100644
--- a/arch/arm/configs/pxa168_defconfig
+++ b/arch/arm/configs/pxa168_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
diff --git a/arch/arm/configs/pxa255-idp_defconfig b/arch/arm/configs/pxa255-idp_defconfig
index 917a070..9f6f6f7 100644
--- a/arch/arm/configs/pxa255-idp_defconfig
+++ b/arch/arm/configs/pxa255-idp_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_MODULES=y
diff --git a/arch/arm/configs/pxa3xx_defconfig b/arch/arm/configs/pxa3xx_defconfig
index 1677a06..70097bc 100644
--- a/arch/arm/configs/pxa3xx_defconfig
+++ b/arch/arm/configs/pxa3xx_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=18
 CONFIG_SYSFS_DEPRECATED_V2=y
diff --git a/arch/arm/configs/pxa910_defconfig b/arch/arm/configs/pxa910_defconfig
index 1cd381e..2e8a19c 100644
--- a/arch/arm/configs/pxa910_defconfig
+++ b/arch/arm/configs/pxa910_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
diff --git a/arch/arm/configs/qil-a9260_defconfig b/arch/arm/configs/qil-a9260_defconfig
index 9160f3b..7973e16 100644
--- a/arch/arm/configs/qil-a9260_defconfig
+++ b/arch/arm/configs/qil-a9260_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 # CONFIG_SWAP is not set
 CONFIG_SYSVIPC=y
diff --git a/arch/arm/configs/raumfeld_defconfig b/arch/arm/configs/raumfeld_defconfig
index f7caa90..ea6746f 100644
--- a/arch/arm/configs/raumfeld_defconfig
+++ b/arch/arm/configs/raumfeld_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 # CONFIG_SWAP is not set
 CONFIG_MODULES=y
diff --git a/arch/arm/configs/realview-smp_defconfig b/arch/arm/configs/realview-smp_defconfig
index abe61bf..aced1f2 100644
--- a/arch/arm/configs/realview-smp_defconfig
+++ b/arch/arm/configs/realview-smp_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_SWAP is not set
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
diff --git a/arch/arm/configs/realview_defconfig b/arch/arm/configs/realview_defconfig
index 7079cbe..0d2fd88 100644
--- a/arch/arm/configs/realview_defconfig
+++ b/arch/arm/configs/realview_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_SWAP is not set
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
diff --git a/arch/arm/configs/rpc_defconfig b/arch/arm/configs/rpc_defconfig
index 00515ef..a244648 100644
--- a/arch/arm/configs/rpc_defconfig
+++ b/arch/arm/configs/rpc_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
diff --git a/arch/arm/configs/s3c2410_defconfig b/arch/arm/configs/s3c2410_defconfig
index 193448f..49ab1cf 100644
--- a/arch/arm/configs/s3c2410_defconfig
+++ b/arch/arm/configs/s3c2410_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_IKCONFIG=m
 CONFIG_IKCONFIG_PROC=y
diff --git a/arch/arm/configs/s3c6400_defconfig b/arch/arm/configs/s3c6400_defconfig
index ba6a515..acb40ff 100644
--- a/arch/arm/configs/s3c6400_defconfig
+++ b/arch/arm/configs/s3c6400_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_KALLSYMS_ALL=y
diff --git a/arch/arm/configs/s5p64x0_defconfig b/arch/arm/configs/s5p64x0_defconfig
index ad6b61b..0246807 100644
--- a/arch/arm/configs/s5p64x0_defconfig
+++ b/arch/arm/configs/s5p64x0_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_KALLSYMS_ALL=y
diff --git a/arch/arm/configs/s5pc100_defconfig b/arch/arm/configs/s5pc100_defconfig
index 41bafc9..7d6a7ab 100644
--- a/arch/arm/configs/s5pc100_defconfig
+++ b/arch/arm/configs/s5pc100_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_KALLSYMS_ALL=y
diff --git a/arch/arm/configs/s5pv210_defconfig b/arch/arm/configs/s5pv210_defconfig
index fa98990..9b27ccd 100644
--- a/arch/arm/configs/s5pv210_defconfig
+++ b/arch/arm/configs/s5pv210_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_KALLSYMS_ALL=y
diff --git a/arch/arm/configs/sam9_l9260_defconfig b/arch/arm/configs/sam9_l9260_defconfig
index ecf2531..6da3da6 100644
--- a/arch/arm/configs/sam9_l9260_defconfig
+++ b/arch/arm/configs/sam9_l9260_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
diff --git a/arch/arm/configs/shannon_defconfig b/arch/arm/configs/shannon_defconfig
index b0b9694..8579a83 100644
--- a/arch/arm/configs/shannon_defconfig
+++ b/arch/arm/configs/shannon_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
diff --git a/arch/arm/configs/shark_defconfig b/arch/arm/configs/shark_defconfig
index caa07db..b2a86ac 100644
--- a/arch/arm/configs/shark_defconfig
+++ b/arch/arm/configs/shark_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
diff --git a/arch/arm/configs/simpad_defconfig b/arch/arm/configs/simpad_defconfig
index d335815..ed0a341 100644
--- a/arch/arm/configs/simpad_defconfig
+++ b/arch/arm/configs/simpad_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_LOCALVERSION="oe1"
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
diff --git a/arch/arm/configs/socfpga_defconfig b/arch/arm/configs/socfpga_defconfig
index 0ac1293..fd69325 100644
--- a/arch/arm/configs/socfpga_defconfig
+++ b/arch/arm/configs/socfpga_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
diff --git a/arch/arm/configs/spear13xx_defconfig b/arch/arm/configs/spear13xx_defconfig
index 1fdb826..97ca9d8 100644
--- a/arch/arm/configs/spear13xx_defconfig
+++ b/arch/arm/configs/spear13xx_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_BLK_DEV_INITRD=y
diff --git a/arch/arm/configs/spear3xx_defconfig b/arch/arm/configs/spear3xx_defconfig
index 865980c..f7bca3c 100644
--- a/arch/arm/configs/spear3xx_defconfig
+++ b/arch/arm/configs/spear3xx_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_BLK_DEV_INITRD=y
diff --git a/arch/arm/configs/spear6xx_defconfig b/arch/arm/configs/spear6xx_defconfig
index a2a1265..d44db64 100644
--- a/arch/arm/configs/spear6xx_defconfig
+++ b/arch/arm/configs/spear6xx_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_BLK_DEV_INITRD=y
diff --git a/arch/arm/configs/spitz_defconfig b/arch/arm/configs/spitz_defconfig
index 7015827..1401007 100644
--- a/arch/arm/configs/spitz_defconfig
+++ b/arch/arm/configs/spitz_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_LOG_BUF_SHIFT=14
diff --git a/arch/arm/configs/stamp9g20_defconfig b/arch/arm/configs/stamp9g20_defconfig
index d5e260b..8d1b6cf 100644
--- a/arch/arm/configs/stamp9g20_defconfig
+++ b/arch/arm/configs/stamp9g20_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 # CONFIG_SWAP is not set
 CONFIG_SYSVIPC=y
diff --git a/arch/arm/configs/tct_hammer_defconfig b/arch/arm/configs/tct_hammer_defconfig
index 71277a1..6279858 100644
--- a/arch/arm/configs/tct_hammer_defconfig
+++ b/arch/arm/configs/tct_hammer_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 # CONFIG_SWAP is not set
 CONFIG_SYSVIPC=y
diff --git a/arch/arm/configs/tegra_defconfig b/arch/arm/configs/tegra_defconfig
index db22453..e286527 100644
--- a/arch/arm/configs/tegra_defconfig
+++ b/arch/arm/configs/tegra_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_NO_HZ=y
 CONFIG_HIGH_RES_TIMERS=y
 CONFIG_IKCONFIG=y
diff --git a/arch/arm/configs/trizeps4_defconfig b/arch/arm/configs/trizeps4_defconfig
index 3162173..68e3cdd 100644
--- a/arch/arm/configs/trizeps4_defconfig
+++ b/arch/arm/configs/trizeps4_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_BSD_PROCESS_ACCT=y
diff --git a/arch/arm/configs/u300_defconfig b/arch/arm/configs/u300_defconfig
index 374000e..39fc22c 100644
--- a/arch/arm/configs/u300_defconfig
+++ b/arch/arm/configs/u300_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 # CONFIG_SWAP is not set
 CONFIG_SYSVIPC=y
diff --git a/arch/arm/configs/u8500_defconfig b/arch/arm/configs/u8500_defconfig
index da68454..4d89317 100644
--- a/arch/arm/configs/u8500_defconfig
+++ b/arch/arm/configs/u8500_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_SWAP is not set
 CONFIG_SYSVIPC=y
 CONFIG_BLK_DEV_INITRD=y
diff --git a/arch/arm/configs/usb-a9260_defconfig b/arch/arm/configs/usb-a9260_defconfig
index 2e39f38..2d2c1c3 100644
--- a/arch/arm/configs/usb-a9260_defconfig
+++ b/arch/arm/configs/usb-a9260_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 # CONFIG_SWAP is not set
 CONFIG_SYSVIPC=y
diff --git a/arch/arm/configs/versatile_defconfig b/arch/arm/configs/versatile_defconfig
index cdd4d2b..2e0b248 100644
--- a/arch/arm/configs/versatile_defconfig
+++ b/arch/arm/configs/versatile_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
diff --git a/arch/arm/configs/vexpress_defconfig b/arch/arm/configs/vexpress_defconfig
index f2de51f..2aa726c 100644
--- a/arch/arm/configs/vexpress_defconfig
+++ b/arch/arm/configs/vexpress_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_IKCONFIG=y
diff --git a/arch/arm/configs/viper_defconfig b/arch/arm/configs/viper_defconfig
index 1d01ddd..2c3bdf9 100644
--- a/arch/arm/configs/viper_defconfig
+++ b/arch/arm/configs/viper_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_SWAP is not set
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=13
diff --git a/arch/arm/configs/xcep_defconfig b/arch/arm/configs/xcep_defconfig
index 721832f..36e1cdf 100644
--- a/arch/arm/configs/xcep_defconfig
+++ b/arch/arm/configs/xcep_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_LOCALVERSION=".xcep-itech"
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
diff --git a/arch/arm/configs/zeus_defconfig b/arch/arm/configs/zeus_defconfig
index 547a3c1..5ffe29a 100644
--- a/arch/arm/configs/zeus_defconfig
+++ b/arch/arm/configs/zeus_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_TINY_RCU=y
 CONFIG_LOG_BUF_SHIFT=13
diff --git a/arch/arm/mach-s3c24xx/Kconfig b/arch/arm/mach-s3c24xx/Kconfig
index d56b0f7..925a99c 100644
--- a/arch/arm/mach-s3c24xx/Kconfig
+++ b/arch/arm/mach-s3c24xx/Kconfig
@@ -291,8 +291,8 @@ config MACH_JIVE
 	  Say Y here if you are using the Logitech Jive.
 
 config MACH_JIVE_SHOW_BOOTLOADER
-	bool "Allow access to bootloader partitions in MTD (EXPERIMENTAL)"
-	depends on MACH_JIVE && EXPERIMENTAL
+	bool "Allow access to bootloader partitions in MTD"
+	depends on MACH_JIVE
 
 config MACH_S3C2413
 	bool
diff --git a/arch/avr32/configs/atngw100_defconfig b/arch/avr32/configs/atngw100_defconfig
index a06bfcc..cfea5fb 100644
--- a/arch/avr32/configs/atngw100_defconfig
+++ b/arch/avr32/configs/atngw100_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
diff --git a/arch/avr32/configs/atngw100_evklcd100_defconfig b/arch/avr32/configs/atngw100_evklcd100_defconfig
index d8f1fe8..fa32edc 100644
--- a/arch/avr32/configs/atngw100_evklcd100_defconfig
+++ b/arch/avr32/configs/atngw100_evklcd100_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
diff --git a/arch/avr32/configs/atngw100_evklcd101_defconfig b/arch/avr32/configs/atngw100_evklcd101_defconfig
index d4c5b19..9c7926a 100644
--- a/arch/avr32/configs/atngw100_evklcd101_defconfig
+++ b/arch/avr32/configs/atngw100_evklcd101_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
diff --git a/arch/avr32/configs/atngw100_mrmt_defconfig b/arch/avr32/configs/atngw100_mrmt_defconfig
index 77ca4f9..3615a35 100644
--- a/arch/avr32/configs/atngw100_mrmt_defconfig
+++ b/arch/avr32/configs/atngw100_mrmt_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
diff --git a/arch/avr32/configs/atngw100mkii_defconfig b/arch/avr32/configs/atngw100mkii_defconfig
index 6e0dca4..9038583 100644
--- a/arch/avr32/configs/atngw100mkii_defconfig
+++ b/arch/avr32/configs/atngw100mkii_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
diff --git a/arch/avr32/configs/atngw100mkii_evklcd100_defconfig b/arch/avr32/configs/atngw100mkii_evklcd100_defconfig
index 7f2a344..cffa846 100644
--- a/arch/avr32/configs/atngw100mkii_evklcd100_defconfig
+++ b/arch/avr32/configs/atngw100mkii_evklcd100_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
diff --git a/arch/avr32/configs/atngw100mkii_evklcd101_defconfig b/arch/avr32/configs/atngw100mkii_evklcd101_defconfig
index 085eeba..e618cc6 100644
--- a/arch/avr32/configs/atngw100mkii_evklcd101_defconfig
+++ b/arch/avr32/configs/atngw100mkii_evklcd101_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
diff --git a/arch/avr32/configs/atstk1002_defconfig b/arch/avr32/configs/atstk1002_defconfig
index d1a887e..217c411 100644
--- a/arch/avr32/configs/atstk1002_defconfig
+++ b/arch/avr32/configs/atstk1002_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
diff --git a/arch/avr32/configs/atstk1003_defconfig b/arch/avr32/configs/atstk1003_defconfig
index 956f281..b633681 100644
--- a/arch/avr32/configs/atstk1003_defconfig
+++ b/arch/avr32/configs/atstk1003_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
diff --git a/arch/avr32/configs/atstk1004_defconfig b/arch/avr32/configs/atstk1004_defconfig
index 40c69f3..232025e 100644
--- a/arch/avr32/configs/atstk1004_defconfig
+++ b/arch/avr32/configs/atstk1004_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
diff --git a/arch/avr32/configs/atstk1006_defconfig b/arch/avr32/configs/atstk1006_defconfig
index 511eb8a..98026b1 100644
--- a/arch/avr32/configs/atstk1006_defconfig
+++ b/arch/avr32/configs/atstk1006_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
diff --git a/arch/avr32/configs/favr-32_defconfig b/arch/avr32/configs/favr-32_defconfig
index 19973b0..7ae4cc4 100644
--- a/arch/avr32/configs/favr-32_defconfig
+++ b/arch/avr32/configs/favr-32_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
diff --git a/arch/avr32/configs/hammerhead_defconfig b/arch/avr32/configs/hammerhead_defconfig
index 6f45681..c672f7b 100644
--- a/arch/avr32/configs/hammerhead_defconfig
+++ b/arch/avr32/configs/hammerhead_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
diff --git a/arch/avr32/configs/merisc_defconfig b/arch/avr32/configs/merisc_defconfig
index 3befab9..b29f04f 100644
--- a/arch/avr32/configs/merisc_defconfig
+++ b/arch/avr32/configs/merisc_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
diff --git a/arch/avr32/configs/mimc200_defconfig b/arch/avr32/configs/mimc200_defconfig
index 1bee51f..43cf8a1 100644
--- a/arch/avr32/configs/mimc200_defconfig
+++ b/arch/avr32/configs/mimc200_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index f348619..91e54b7 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -558,8 +558,7 @@ choice
 	  accurate - This option is therefore marked experimental.
 
 config BFIN_KERNEL_CLOCK_MEMINIT_CALC
-	bool "Calculate Timings (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	bool "Calculate Timings"
 
 config BFIN_KERNEL_CLOCK_MEMINIT_SPEC
 	bool "Provide accurate Timings based on target SCLK"
@@ -1116,7 +1115,7 @@ endchoice
 
 comment "Memory Protection Unit"
 config MPU
-	bool "Enable the memory protection unit (EXPERIMENTAL)"
+	bool "Enable the memory protection unit"
 	default n
 	help
 	  Use the processor's MPU to protect applications from accessing
@@ -1438,7 +1437,6 @@ config BFIN_CPU_FREQ
 
 config CPU_VOLTAGE
 	bool "CPU Voltage scaling"
-	depends on EXPERIMENTAL
 	depends on CPU_FREQ
 	default n
 	help
diff --git a/arch/blackfin/configs/BF518F-EZBRD_defconfig b/arch/blackfin/configs/BF518F-EZBRD_defconfig
index 3830078..ee42047 100644
--- a/arch/blackfin/configs/BF518F-EZBRD_defconfig
+++ b/arch/blackfin/configs/BF518F-EZBRD_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
diff --git a/arch/blackfin/configs/BF526-EZBRD_defconfig b/arch/blackfin/configs/BF526-EZBRD_defconfig
index 2f2c6ac..676661a 100644
--- a/arch/blackfin/configs/BF526-EZBRD_defconfig
+++ b/arch/blackfin/configs/BF526-EZBRD_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
diff --git a/arch/blackfin/configs/BF527-AD7160-EVAL_defconfig b/arch/blackfin/configs/BF527-AD7160-EVAL_defconfig
index d95658f..1f7d661 100644
--- a/arch/blackfin/configs/BF527-AD7160-EVAL_defconfig
+++ b/arch/blackfin/configs/BF527-AD7160-EVAL_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
diff --git a/arch/blackfin/configs/BF527-EZKIT-V2_defconfig b/arch/blackfin/configs/BF527-EZKIT-V2_defconfig
index 91535c3..f897545 100644
--- a/arch/blackfin/configs/BF527-EZKIT-V2_defconfig
+++ b/arch/blackfin/configs/BF527-EZKIT-V2_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
diff --git a/arch/blackfin/configs/BF527-EZKIT_defconfig b/arch/blackfin/configs/BF527-EZKIT_defconfig
index 90b1753..833a0ee 100644
--- a/arch/blackfin/configs/BF527-EZKIT_defconfig
+++ b/arch/blackfin/configs/BF527-EZKIT_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
diff --git a/arch/blackfin/configs/BF527-TLL6527M_defconfig b/arch/blackfin/configs/BF527-TLL6527M_defconfig
index cd0636b..33744ac 100644
--- a/arch/blackfin/configs/BF527-TLL6527M_defconfig
+++ b/arch/blackfin/configs/BF527-TLL6527M_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_LOCALVERSION="DEV_0-1_pre2010"
 CONFIG_SYSVIPC=y
 CONFIG_IKCONFIG=y
diff --git a/arch/blackfin/configs/BF533-EZKIT_defconfig b/arch/blackfin/configs/BF533-EZKIT_defconfig
index 127f20d..b011c57 100644
--- a/arch/blackfin/configs/BF533-EZKIT_defconfig
+++ b/arch/blackfin/configs/BF533-EZKIT_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
diff --git a/arch/blackfin/configs/BF533-STAMP_defconfig b/arch/blackfin/configs/BF533-STAMP_defconfig
index 0df2f92..51bb0a4 100644
--- a/arch/blackfin/configs/BF533-STAMP_defconfig
+++ b/arch/blackfin/configs/BF533-STAMP_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
diff --git a/arch/blackfin/configs/BF537-STAMP_defconfig b/arch/blackfin/configs/BF537-STAMP_defconfig
index 91d3eda..6d47e80 100644
--- a/arch/blackfin/configs/BF537-STAMP_defconfig
+++ b/arch/blackfin/configs/BF537-STAMP_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
diff --git a/arch/blackfin/configs/BF538-EZKIT_defconfig b/arch/blackfin/configs/BF538-EZKIT_defconfig
index 972aa62..ecadaa8 100644
--- a/arch/blackfin/configs/BF538-EZKIT_defconfig
+++ b/arch/blackfin/configs/BF538-EZKIT_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
diff --git a/arch/blackfin/configs/BF548-EZKIT_defconfig b/arch/blackfin/configs/BF548-EZKIT_defconfig
index e716fdf..f4429b1 100644
--- a/arch/blackfin/configs/BF548-EZKIT_defconfig
+++ b/arch/blackfin/configs/BF548-EZKIT_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
diff --git a/arch/blackfin/configs/BF561-ACVILON_defconfig b/arch/blackfin/configs/BF561-ACVILON_defconfig
index 0fdc4ec..b548bbd 100644
--- a/arch/blackfin/configs/BF561-ACVILON_defconfig
+++ b/arch/blackfin/configs/BF561-ACVILON_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
diff --git a/arch/blackfin/configs/BF561-EZKIT-SMP_defconfig b/arch/blackfin/configs/BF561-EZKIT-SMP_defconfig
index e2a2fa5..fba8f66 100644
--- a/arch/blackfin/configs/BF561-EZKIT-SMP_defconfig
+++ b/arch/blackfin/configs/BF561-EZKIT-SMP_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
diff --git a/arch/blackfin/configs/BF561-EZKIT_defconfig b/arch/blackfin/configs/BF561-EZKIT_defconfig
index 680730e..73e0ae4 100644
--- a/arch/blackfin/configs/BF561-EZKIT_defconfig
+++ b/arch/blackfin/configs/BF561-EZKIT_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
diff --git a/arch/blackfin/configs/BF609-EZKIT_defconfig b/arch/blackfin/configs/BF609-EZKIT_defconfig
index f4b0235..4940422 100644
--- a/arch/blackfin/configs/BF609-EZKIT_defconfig
+++ b/arch/blackfin/configs/BF609-EZKIT_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
diff --git a/arch/blackfin/configs/BlackStamp_defconfig b/arch/blackfin/configs/BlackStamp_defconfig
index 7b982d0..779df96 100644
--- a/arch/blackfin/configs/BlackStamp_defconfig
+++ b/arch/blackfin/configs/BlackStamp_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
diff --git a/arch/blackfin/configs/CM-BF527_defconfig b/arch/blackfin/configs/CM-BF527_defconfig
index c280a50..5769877 100644
--- a/arch/blackfin/configs/CM-BF527_defconfig
+++ b/arch/blackfin/configs/CM-BF527_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_KERNEL_LZMA=y
 CONFIG_SYSVIPC=y
 CONFIG_IKCONFIG=y
diff --git a/arch/blackfin/configs/CM-BF533_defconfig b/arch/blackfin/configs/CM-BF533_defconfig
index c940a1e..7eef91b 100644
--- a/arch/blackfin/configs/CM-BF533_defconfig
+++ b/arch/blackfin/configs/CM-BF533_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_KERNEL_LZMA=y
 CONFIG_SYSVIPC=y
 CONFIG_IKCONFIG=y
diff --git a/arch/blackfin/configs/CM-BF537E_defconfig b/arch/blackfin/configs/CM-BF537E_defconfig
index 2e47df7..d163431 100644
--- a/arch/blackfin/configs/CM-BF537E_defconfig
+++ b/arch/blackfin/configs/CM-BF537E_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_KERNEL_LZMA=y
 CONFIG_SYSVIPC=y
 CONFIG_IKCONFIG=y
diff --git a/arch/blackfin/configs/CM-BF537U_defconfig b/arch/blackfin/configs/CM-BF537U_defconfig
index 6da629f..84a7358 100644
--- a/arch/blackfin/configs/CM-BF537U_defconfig
+++ b/arch/blackfin/configs/CM-BF537U_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_KERNEL_LZMA=y
 CONFIG_SYSVIPC=y
 CONFIG_IKCONFIG=y
diff --git a/arch/blackfin/configs/CM-BF548_defconfig b/arch/blackfin/configs/CM-BF548_defconfig
index 349922b..899c4d0 100644
--- a/arch/blackfin/configs/CM-BF548_defconfig
+++ b/arch/blackfin/configs/CM-BF548_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_KERNEL_LZMA=y
 CONFIG_SYSVIPC=y
 CONFIG_IKCONFIG=y
diff --git a/arch/blackfin/configs/CM-BF561_defconfig b/arch/blackfin/configs/CM-BF561_defconfig
index 0456dea..3991512 100644
--- a/arch/blackfin/configs/CM-BF561_defconfig
+++ b/arch/blackfin/configs/CM-BF561_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_KERNEL_LZMA=y
 CONFIG_SYSVIPC=y
 CONFIG_IKCONFIG=y
diff --git a/arch/blackfin/configs/DNP5370_defconfig b/arch/blackfin/configs/DNP5370_defconfig
index 89162d0..adc3699 100644
--- a/arch/blackfin/configs/DNP5370_defconfig
+++ b/arch/blackfin/configs/DNP5370_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_LOCALVERSION="DNP5370"
 CONFIG_SYSVIPC=y
 CONFIG_IKCONFIG=y
diff --git a/arch/blackfin/configs/H8606_defconfig b/arch/blackfin/configs/H8606_defconfig
index a26436b..a5560bd 100644
--- a/arch/blackfin/configs/H8606_defconfig
+++ b/arch/blackfin/configs/H8606_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
diff --git a/arch/blackfin/configs/IP0X_defconfig b/arch/blackfin/configs/IP0X_defconfig
index 6479915..fca9179 100644
--- a/arch/blackfin/configs/IP0X_defconfig
+++ b/arch/blackfin/configs/IP0X_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
diff --git a/arch/blackfin/configs/PNAV-10_defconfig b/arch/blackfin/configs/PNAV-10_defconfig
index 8fd9b44..9fbd5b1 100644
--- a/arch/blackfin/configs/PNAV-10_defconfig
+++ b/arch/blackfin/configs/PNAV-10_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
diff --git a/arch/blackfin/configs/SRV1_defconfig b/arch/blackfin/configs/SRV1_defconfig
index 0520c16..613f96c 100644
--- a/arch/blackfin/configs/SRV1_defconfig
+++ b/arch/blackfin/configs/SRV1_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
diff --git a/arch/blackfin/configs/TCM-BF518_defconfig b/arch/blackfin/configs/TCM-BF518_defconfig
index e4ed865..06cef33 100644
--- a/arch/blackfin/configs/TCM-BF518_defconfig
+++ b/arch/blackfin/configs/TCM-BF518_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_KERNEL_LZMA=y
 CONFIG_SYSVIPC=y
 CONFIG_IKCONFIG=y
diff --git a/arch/blackfin/configs/TCM-BF537_defconfig b/arch/blackfin/configs/TCM-BF537_defconfig
index c1f45f1..fac72c2 100644
--- a/arch/blackfin/configs/TCM-BF537_defconfig
+++ b/arch/blackfin/configs/TCM-BF537_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_KERNEL_LZMA=y
 CONFIG_SYSVIPC=y
 CONFIG_IKCONFIG=y
diff --git a/arch/c6x/configs/dsk6455_defconfig b/arch/c6x/configs/dsk6455_defconfig
index 4663487..55ca607 100644
--- a/arch/c6x/configs/dsk6455_defconfig
+++ b/arch/c6x/configs/dsk6455_defconfig
@@ -1,5 +1,4 @@
 CONFIG_SOC_TMS320C6455=y
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_SPARSE_IRQ=y
diff --git a/arch/c6x/configs/evmc6457_defconfig b/arch/c6x/configs/evmc6457_defconfig
index bba40e1..048396c 100644
--- a/arch/c6x/configs/evmc6457_defconfig
+++ b/arch/c6x/configs/evmc6457_defconfig
@@ -1,5 +1,4 @@
 CONFIG_SOC_TMS320C6457=y
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_SPARSE_IRQ=y
diff --git a/arch/c6x/configs/evmc6472_defconfig b/arch/c6x/configs/evmc6472_defconfig
index 8c46155..07b2aee 100644
--- a/arch/c6x/configs/evmc6472_defconfig
+++ b/arch/c6x/configs/evmc6472_defconfig
@@ -1,5 +1,4 @@
 CONFIG_SOC_TMS320C6472=y
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_SPARSE_IRQ=y
diff --git a/arch/c6x/configs/evmc6474_defconfig b/arch/c6x/configs/evmc6474_defconfig
index 15533f6..dc65bb9 100644
--- a/arch/c6x/configs/evmc6474_defconfig
+++ b/arch/c6x/configs/evmc6474_defconfig
@@ -1,5 +1,4 @@
 CONFIG_SOC_TMS320C6474=y
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_SPARSE_IRQ=y
diff --git a/arch/c6x/configs/evmc6678_defconfig b/arch/c6x/configs/evmc6678_defconfig
index 5f126d4..d69b13e 100644
--- a/arch/c6x/configs/evmc6678_defconfig
+++ b/arch/c6x/configs/evmc6678_defconfig
@@ -1,5 +1,4 @@
 CONFIG_SOC_TMS320C6678=y
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_SPARSE_IRQ=y
diff --git a/arch/cris/arch-v32/drivers/Kconfig b/arch/cris/arch-v32/drivers/Kconfig
index de43aad..af4a486 100644
--- a/arch/cris/arch-v32/drivers/Kconfig
+++ b/arch/cris/arch-v32/drivers/Kconfig
@@ -680,7 +680,7 @@ config ETRAX_SPI_MMC_BOARD
 
 config SPI_ETRAX_SSER
 	tristate
-	depends on SPI_MASTER && ETRAX_ARCH_V32 && EXPERIMENTAL
+	depends on SPI_MASTER && ETRAX_ARCH_V32
 	select SPI_BITBANG
 	help
 	  This enables using an synchronous serial (sser) port as a
@@ -689,7 +689,7 @@ config SPI_ETRAX_SSER
 
 config SPI_ETRAX_GPIO
 	tristate
-	depends on SPI_MASTER && ETRAX_ARCH_V32 && EXPERIMENTAL
+	depends on SPI_MASTER && ETRAX_ARCH_V32
 	select SPI_BITBANG
 	help
 	  This enables using GPIO pins port as a SPI master controller
diff --git a/arch/cris/configs/artpec_3_defconfig b/arch/cris/configs/artpec_3_defconfig
index 71854d4..659892b 100644
--- a/arch/cris/configs/artpec_3_defconfig
+++ b/arch/cris/configs/artpec_3_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_SWAP is not set
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
diff --git a/arch/cris/configs/etrax-100lx_defconfig b/arch/cris/configs/etrax-100lx_defconfig
index cbbcefe..32592c6 100644
--- a/arch/cris/configs/etrax-100lx_defconfig
+++ b/arch/cris/configs/etrax-100lx_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_ETRAX_LED1R=2
 CONFIG_ETRAX_LED2G=2
diff --git a/arch/cris/configs/etrax-100lx_v2_defconfig b/arch/cris/configs/etrax-100lx_v2_defconfig
index a85aabf..5a6a086 100644
--- a/arch/cris/configs/etrax-100lx_v2_defconfig
+++ b/arch/cris/configs/etrax-100lx_v2_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_SWAP is not set
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
diff --git a/arch/cris/configs/etraxfs_defconfig b/arch/cris/configs/etraxfs_defconfig
index 87c7227..2202000 100644
--- a/arch/cris/configs/etraxfs_defconfig
+++ b/arch/cris/configs/etraxfs_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_SWAP is not set
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
diff --git a/arch/frv/defconfig b/arch/frv/defconfig
index b1b7926..cb53c2d 100644
--- a/arch/frv/defconfig
+++ b/arch/frv/defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
diff --git a/arch/h8300/defconfig b/arch/h8300/defconfig
index 042425a..542252f 100644
--- a/arch/h8300/defconfig
+++ b/arch/h8300/defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_EXPERT=y
diff --git a/arch/hexagon/configs/comet_defconfig b/arch/hexagon/configs/comet_defconfig
index e324f65..f19ae2a 100644
--- a/arch/hexagon/configs/comet_defconfig
+++ b/arch/hexagon/configs/comet_defconfig
@@ -1,7 +1,6 @@
 CONFIG_SMP=y
 CONFIG_DEFAULT_MMAP_MIN_ADDR=0
 CONFIG_HZ_100=y
-CONFIG_EXPERIMENTAL=y
 CONFIG_CROSS_COMPILE="hexagon-"
 CONFIG_LOCALVERSION="-smp"
 # CONFIG_LOCALVERSION_AUTO is not set
diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index 310cf57..b9bf28c 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -383,8 +383,8 @@ config NR_CPUS
 	  performance hit.
 
 config HOTPLUG_CPU
-	bool "Support for hot-pluggable CPUs (EXPERIMENTAL)"
-	depends on SMP && EXPERIMENTAL
+	bool "Support for hot-pluggable CPUs"
+	depends on SMP
 	select HOTPLUG
 	default n
 	---help---
@@ -563,8 +563,8 @@ config IA64_HP_AML_NFW
 source "drivers/sn/Kconfig"
 
 config KEXEC
-	bool "kexec system call (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && !IA64_HP_SIM && (!SMP || HOTPLUG_CPU)
+	bool "kexec system call"
+	depends on !IA64_HP_SIM && (!SMP || HOTPLUG_CPU)
 	help
 	  kexec is a system call that implements the ability to shutdown your
 	  current kernel, and to start another kernel.  It is like a reboot
diff --git a/arch/ia64/configs/bigsur_defconfig b/arch/ia64/configs/bigsur_defconfig
index cf5993f..df11ed4 100644
--- a/arch/ia64/configs/bigsur_defconfig
+++ b/arch/ia64/configs/bigsur_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=16
diff --git a/arch/ia64/configs/generic_defconfig b/arch/ia64/configs/generic_defconfig
index 7913695..3b31409 100644
--- a/arch/ia64/configs/generic_defconfig
+++ b/arch/ia64/configs/generic_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_IKCONFIG=y
diff --git a/arch/ia64/configs/gensparse_defconfig b/arch/ia64/configs/gensparse_defconfig
index f8e9133..1f16e34 100644
--- a/arch/ia64/configs/gensparse_defconfig
+++ b/arch/ia64/configs/gensparse_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_IKCONFIG=y
diff --git a/arch/ia64/configs/sim_defconfig b/arch/ia64/configs/sim_defconfig
index b4548a3..62225e3 100644
--- a/arch/ia64/configs/sim_defconfig
+++ b/arch/ia64/configs/sim_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
diff --git a/arch/ia64/configs/tiger_defconfig b/arch/ia64/configs/tiger_defconfig
index a5a9e02..eb096d2 100644
--- a/arch/ia64/configs/tiger_defconfig
+++ b/arch/ia64/configs/tiger_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_IKCONFIG=y
diff --git a/arch/ia64/configs/xen_domu_defconfig b/arch/ia64/configs/xen_domu_defconfig
index 37b9b42..57e5f67 100644
--- a/arch/ia64/configs/xen_domu_defconfig
+++ b/arch/ia64/configs/xen_domu_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_IKCONFIG=y
diff --git a/arch/ia64/configs/zx1_defconfig b/arch/ia64/configs/zx1_defconfig
index fc7aba0..5cd8090 100644
--- a/arch/ia64/configs/zx1_defconfig
+++ b/arch/ia64/configs/zx1_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_BLK_DEV_INITRD=y
diff --git a/arch/ia64/kvm/Kconfig b/arch/ia64/kvm/Kconfig
index e794752..2cd225f 100644
--- a/arch/ia64/kvm/Kconfig
+++ b/arch/ia64/kvm/Kconfig
@@ -20,7 +20,7 @@ if VIRTUALIZATION
 config KVM
 	tristate "Kernel-based Virtual Machine (KVM) support"
 	depends on BROKEN
-	depends on HAVE_KVM && MODULES && EXPERIMENTAL
+	depends on HAVE_KVM && MODULES
 	# for device assignment:
 	depends on PCI
 	depends on BROKEN
diff --git a/arch/ia64/xen/Kconfig b/arch/ia64/xen/Kconfig
index 515e082..5d8a06b 100644
--- a/arch/ia64/xen/Kconfig
+++ b/arch/ia64/xen/Kconfig
@@ -5,7 +5,7 @@
 config XEN
 	bool "Xen hypervisor support"
 	default y
-	depends on PARAVIRT && MCKINLEY && IA64_PAGE_SIZE_16KB && EXPERIMENTAL
+	depends on PARAVIRT && MCKINLEY && IA64_PAGE_SIZE_16KB
 	select XEN_XENCOMM
 	select NO_IDLE_HZ
 	# followings are required to save/restore.
diff --git a/arch/m32r/configs/m32104ut_defconfig b/arch/m32r/configs/m32104ut_defconfig
index be30e09..5b102a8 100644
--- a/arch/m32r/configs/m32104ut_defconfig
+++ b/arch/m32r/configs/m32104ut_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
diff --git a/arch/m32r/configs/m32700ut.smp_defconfig b/arch/m32r/configs/m32700ut.smp_defconfig
index a3d727e..88cf1cc 100644
--- a/arch/m32r/configs/m32700ut.smp_defconfig
+++ b/arch/m32r/configs/m32700ut.smp_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_IKCONFIG=y
diff --git a/arch/m32r/configs/m32700ut.up_defconfig b/arch/m32r/configs/m32700ut.up_defconfig
index b833416..ddcc0d8 100644
--- a/arch/m32r/configs/m32700ut.up_defconfig
+++ b/arch/m32r/configs/m32700ut.up_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_IKCONFIG=y
diff --git a/arch/m32r/configs/mappi.nommu_defconfig b/arch/m32r/configs/mappi.nommu_defconfig
index 7c90ce2..2483fa9 100644
--- a/arch/m32r/configs/mappi.nommu_defconfig
+++ b/arch/m32r/configs/mappi.nommu_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_IKCONFIG=y
 CONFIG_LOG_BUF_SHIFT=14
diff --git a/arch/m32r/configs/mappi.smp_defconfig b/arch/m32r/configs/mappi.smp_defconfig
index 367d07c..8de5e8d 100644
--- a/arch/m32r/configs/mappi.smp_defconfig
+++ b/arch/m32r/configs/mappi.smp_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
diff --git a/arch/m32r/configs/mappi.up_defconfig b/arch/m32r/configs/mappi.up_defconfig
index cb11384..5003ae3 100644
--- a/arch/m32r/configs/mappi.up_defconfig
+++ b/arch/m32r/configs/mappi.up_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
diff --git a/arch/m32r/configs/mappi2.opsp_defconfig b/arch/m32r/configs/mappi2.opsp_defconfig
index 3bff779..7ccc0b8 100644
--- a/arch/m32r/configs/mappi2.opsp_defconfig
+++ b/arch/m32r/configs/mappi2.opsp_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_IKCONFIG=y
diff --git a/arch/m32r/configs/mappi2.vdec2_defconfig b/arch/m32r/configs/mappi2.vdec2_defconfig
index 75246c9..e770e45 100644
--- a/arch/m32r/configs/mappi2.vdec2_defconfig
+++ b/arch/m32r/configs/mappi2.vdec2_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_IKCONFIG=y
diff --git a/arch/m32r/configs/mappi3.smp_defconfig b/arch/m32r/configs/mappi3.smp_defconfig
index 27cefd4..2b0f8e3 100644
--- a/arch/m32r/configs/mappi3.smp_defconfig
+++ b/arch/m32r/configs/mappi3.smp_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
diff --git a/arch/m32r/configs/oaks32r_defconfig b/arch/m32r/configs/oaks32r_defconfig
index 5087a51..a4a9510 100644
--- a/arch/m32r/configs/oaks32r_defconfig
+++ b/arch/m32r/configs/oaks32r_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
diff --git a/arch/m32r/configs/opsput_defconfig b/arch/m32r/configs/opsput_defconfig
index 50c6f52..0f8cc8d 100644
--- a/arch/m32r/configs/opsput_defconfig
+++ b/arch/m32r/configs/opsput_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_IKCONFIG=y
diff --git a/arch/m32r/configs/usrv_defconfig b/arch/m32r/configs/usrv_defconfig
index a3cfaae..59bfec1 100644
--- a/arch/m32r/configs/usrv_defconfig
+++ b/arch/m32r/configs/usrv_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_BSD_PROCESS_ACCT=y
diff --git a/arch/m68k/Kconfig.bus b/arch/m68k/Kconfig.bus
index ffc0601..93ef034 100644
--- a/arch/m68k/Kconfig.bus
+++ b/arch/m68k/Kconfig.bus
@@ -28,8 +28,8 @@ config ZORRO
 	  Linux use these.
 
 config AMIGA_PCMCIA
-	bool "Amiga 1200/600 PCMCIA support (EXPERIMENTAL)"
-	depends on AMIGA && EXPERIMENTAL
+	bool "Amiga 1200/600 PCMCIA support"
+	depends on AMIGA
 	help
 	  Include support in the kernel for pcmcia on Amiga 1200 and Amiga
 	  600. If you intend to use pcmcia cards say Y; otherwise say N.
diff --git a/arch/m68k/Kconfig.cpu b/arch/m68k/Kconfig.cpu
index c4eb79e..2f2d87b 100644
--- a/arch/m68k/Kconfig.cpu
+++ b/arch/m68k/Kconfig.cpu
@@ -274,9 +274,8 @@ endif # COLDFIRE
 comment "Processor Specific Options"
 
 config M68KFPU_EMU
-	bool "Math emulation support (EXPERIMENTAL)"
+	bool "Math emulation support"
 	depends on MMU
-	depends on EXPERIMENTAL
 	help
 	  At some point in the future, this will cause floating-point math
 	  instructions to be emulated by the kernel on machines that lack a
diff --git a/arch/m68k/Kconfig.debug b/arch/m68k/Kconfig.debug
index 87233ac..fa12283 100644
--- a/arch/m68k/Kconfig.debug
+++ b/arch/m68k/Kconfig.debug
@@ -41,7 +41,7 @@ config NO_KERNEL_MSG
 
 config BDM_DISABLE
 	bool "Disable BDM signals"
-	depends on (EXPERIMENTAL && COLDFIRE)
+	depends on COLDFIRE
 	help
 	  Disable the ColdFire CPU's BDM signals.
 
diff --git a/arch/m68k/Kconfig.devices b/arch/m68k/Kconfig.devices
index 04a3d9b..c4cdfe4 100644
--- a/arch/m68k/Kconfig.devices
+++ b/arch/m68k/Kconfig.devices
@@ -60,8 +60,8 @@ endmenu
 menu "Character devices"
 
 config ATARI_DSP56K
-	tristate "Atari DSP56k support (EXPERIMENTAL)"
-	depends on ATARI && EXPERIMENTAL
+	tristate "Atari DSP56k support"
+	depends on ATARI
 	help
 	  If you want to be able to use the DSP56001 in Falcons, say Y. This
 	  driver is still experimental, and if you don't know what it is, or
@@ -87,7 +87,7 @@ config HPDCA
 
 config HPAPCI
 	tristate "HP APCI serial support"
-	depends on HP300 && SERIAL_8250 && EXPERIMENTAL
+	depends on HP300 && SERIAL_8250
 	help
 	  If you want to use the internal "APCI" serial ports on an HP400
 	  machine, say Y here.
diff --git a/arch/m68k/configs/amiga_defconfig b/arch/m68k/configs/amiga_defconfig
index e93fdae..96e2233 100644
--- a/arch/m68k/configs/amiga_defconfig
+++ b/arch/m68k/configs/amiga_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_LOCALVERSION="-amiga"
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
diff --git a/arch/m68k/configs/apollo_defconfig b/arch/m68k/configs/apollo_defconfig
index 66b26c1..1924872 100644
--- a/arch/m68k/configs/apollo_defconfig
+++ b/arch/m68k/configs/apollo_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_LOCALVERSION="-apollo"
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
diff --git a/arch/m68k/configs/atari_defconfig b/arch/m68k/configs/atari_defconfig
index 1513325..ac5c178 100644
--- a/arch/m68k/configs/atari_defconfig
+++ b/arch/m68k/configs/atari_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_LOCALVERSION="-atari"
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
diff --git a/arch/m68k/configs/bvme6000_defconfig b/arch/m68k/configs/bvme6000_defconfig
index 67bb6fc..71a63f7 100644
--- a/arch/m68k/configs/bvme6000_defconfig
+++ b/arch/m68k/configs/bvme6000_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_LOCALVERSION="-bvme6000"
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
diff --git a/arch/m68k/configs/hp300_defconfig b/arch/m68k/configs/hp300_defconfig
index 3e35ce5..4079879 100644
--- a/arch/m68k/configs/hp300_defconfig
+++ b/arch/m68k/configs/hp300_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_LOCALVERSION="-hp300"
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
diff --git a/arch/m68k/configs/m5208evb_defconfig b/arch/m68k/configs/m5208evb_defconfig
index c161682..ebd6568 100644
--- a/arch/m68k/configs/m5208evb_defconfig
+++ b/arch/m68k/configs/m5208evb_defconfig
@@ -1,5 +1,4 @@
 # CONFIG_MMU is not set
-CONFIG_EXPERIMENTAL=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
diff --git a/arch/m68k/configs/m5249evb_defconfig b/arch/m68k/configs/m5249evb_defconfig
index a6599e4..f7d06cc 100644
--- a/arch/m68k/configs/m5249evb_defconfig
+++ b/arch/m68k/configs/m5249evb_defconfig
@@ -1,5 +1,4 @@
 # CONFIG_MMU is not set
-CONFIG_EXPERIMENTAL=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
diff --git a/arch/m68k/configs/m5272c3_defconfig b/arch/m68k/configs/m5272c3_defconfig
index 3fa60a5..e69f798 100644
--- a/arch/m68k/configs/m5272c3_defconfig
+++ b/arch/m68k/configs/m5272c3_defconfig
@@ -1,5 +1,4 @@
 # CONFIG_MMU is not set
-CONFIG_EXPERIMENTAL=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
diff --git a/arch/m68k/configs/m5275evb_defconfig b/arch/m68k/configs/m5275evb_defconfig
index a1230e8..75686e0 100644
--- a/arch/m68k/configs/m5275evb_defconfig
+++ b/arch/m68k/configs/m5275evb_defconfig
@@ -1,5 +1,4 @@
 # CONFIG_MMU is not set
-CONFIG_EXPERIMENTAL=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
diff --git a/arch/m68k/configs/m5307c3_defconfig b/arch/m68k/configs/m5307c3_defconfig
index 43795f4..5c892d4 100644
--- a/arch/m68k/configs/m5307c3_defconfig
+++ b/arch/m68k/configs/m5307c3_defconfig
@@ -1,5 +1,4 @@
 # CONFIG_MMU is not set
-CONFIG_EXPERIMENTAL=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
diff --git a/arch/m68k/configs/m5407c3_defconfig b/arch/m68k/configs/m5407c3_defconfig
index 72746c5..1494aaf 100644
--- a/arch/m68k/configs/m5407c3_defconfig
+++ b/arch/m68k/configs/m5407c3_defconfig
@@ -1,5 +1,4 @@
 # CONFIG_MMU is not set
-CONFIG_EXPERIMENTAL=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
diff --git a/arch/m68k/configs/m5475evb_defconfig b/arch/m68k/configs/m5475evb_defconfig
index c5018a6..0c62b49 100644
--- a/arch/m68k/configs/m5475evb_defconfig
+++ b/arch/m68k/configs/m5475evb_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_SWAP is not set
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED=y
diff --git a/arch/m68k/configs/mac_defconfig b/arch/m68k/configs/mac_defconfig
index ae81e2d..6983478 100644
--- a/arch/m68k/configs/mac_defconfig
+++ b/arch/m68k/configs/mac_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_LOCALVERSION="-mac"
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
diff --git a/arch/m68k/configs/multi_defconfig b/arch/m68k/configs/multi_defconfig
index 55d394e..f6941fc 100644
--- a/arch/m68k/configs/multi_defconfig
+++ b/arch/m68k/configs/multi_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_LOCALVERSION="-multi"
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
diff --git a/arch/m68k/configs/mvme147_defconfig b/arch/m68k/configs/mvme147_defconfig
index af77374..6973157 100644
--- a/arch/m68k/configs/mvme147_defconfig
+++ b/arch/m68k/configs/mvme147_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_LOCALVERSION="-mvme147"
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
diff --git a/arch/m68k/configs/mvme16x_defconfig b/arch/m68k/configs/mvme16x_defconfig
index cdb70d6..654e764 100644
--- a/arch/m68k/configs/mvme16x_defconfig
+++ b/arch/m68k/configs/mvme16x_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_LOCALVERSION="-mvme16x"
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
diff --git a/arch/m68k/configs/q40_defconfig b/arch/m68k/configs/q40_defconfig
index 46bed78..4d03f5e 100644
--- a/arch/m68k/configs/q40_defconfig
+++ b/arch/m68k/configs/q40_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_LOCALVERSION="-q40"
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
diff --git a/arch/m68k/configs/sun3_defconfig b/arch/m68k/configs/sun3_defconfig
index 86f7772..4463792 100644
--- a/arch/m68k/configs/sun3_defconfig
+++ b/arch/m68k/configs/sun3_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_LOCALVERSION="-sun3"
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
diff --git a/arch/m68k/configs/sun3x_defconfig b/arch/m68k/configs/sun3x_defconfig
index 2882614..a9ee07a 100644
--- a/arch/m68k/configs/sun3x_defconfig
+++ b/arch/m68k/configs/sun3x_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_LOCALVERSION="-sun3x"
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
diff --git a/arch/microblaze/configs/mmu_defconfig b/arch/microblaze/configs/mmu_defconfig
index b3f5eec..bea4b7f 100644
--- a/arch/microblaze/configs/mmu_defconfig
+++ b/arch/microblaze/configs/mmu_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
diff --git a/arch/microblaze/configs/nommu_defconfig b/arch/microblaze/configs/nommu_defconfig
index 0249e4b..642efce 100644
--- a/arch/microblaze/configs/nommu_defconfig
+++ b/arch/microblaze/configs/nommu_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_BSD_PROCESS_ACCT=y
diff --git a/arch/microblaze/platform/Kconfig.platform b/arch/microblaze/platform/Kconfig.platform
index 669c7ee..b174721 100644
--- a/arch/microblaze/platform/Kconfig.platform
+++ b/arch/microblaze/platform/Kconfig.platform
@@ -20,7 +20,7 @@ endchoice
 
 config SELFMOD
 	bool "Use self modified code for intc/timer"
-	depends on EXPERIMENTAL && NO_MMU
+	depends on NO_MMU
 	default n
 	help
 	  This choice enables self-modified code for interrupt controller
diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index faf6528..12c2b8e 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -165,7 +165,7 @@ config MACH_DECSTATION
 	select SYS_HAS_CPU_R3000
 	select SYS_HAS_CPU_R4X00
 	select SYS_SUPPORTS_32BIT_KERNEL
-	select SYS_SUPPORTS_64BIT_KERNEL if EXPERIMENTAL
+	select SYS_SUPPORTS_64BIT_KERNEL
 	select SYS_SUPPORTS_LITTLE_ENDIAN
 	select SYS_SUPPORTS_128HZ
 	select SYS_SUPPORTS_256HZ
@@ -378,7 +378,6 @@ config PNX8550_STB810
 
 config PMC_MSP
 	bool "PMC-Sierra MSP chipsets"
-	depends on EXPERIMENTAL
 	select CEVT_R4K
 	select CSRC_R4K
 	select DMA_NONCOHERENT
@@ -498,8 +497,7 @@ config SGI_IP27
 	  here.
 
 config SGI_IP28
-	bool "SGI IP28 (Indigo2 R10k) (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	bool "SGI IP28 (Indigo2 R10k)"
 	select ARC
 	select ARC64
 	select BOOT_ELF64
@@ -557,7 +555,6 @@ config SGI_IP32
 
 config SIBYTE_CRHINE
 	bool "Sibyte BCM91120C-CRhine"
-	depends on EXPERIMENTAL
 	select BOOT_ELF32
 	select DMA_COHERENT
 	select SIBYTE_BCM1120
@@ -568,7 +565,6 @@ config SIBYTE_CRHINE
 
 config SIBYTE_CARMEL
 	bool "Sibyte BCM91120x-Carmel"
-	depends on EXPERIMENTAL
 	select BOOT_ELF32
 	select DMA_COHERENT
 	select SIBYTE_BCM1120
@@ -579,7 +575,6 @@ config SIBYTE_CARMEL
 
 config SIBYTE_CRHONE
 	bool "Sibyte BCM91125C-CRhone"
-	depends on EXPERIMENTAL
 	select BOOT_ELF32
 	select DMA_COHERENT
 	select SIBYTE_BCM1125
@@ -591,7 +586,6 @@ config SIBYTE_CRHONE
 
 config SIBYTE_RHONE
 	bool "Sibyte BCM91125E-Rhone"
-	depends on EXPERIMENTAL
 	select BOOT_ELF32
 	select DMA_COHERENT
 	select SIBYTE_BCM1125H
@@ -616,7 +610,6 @@ config SIBYTE_SWARM
 
 config SIBYTE_LITTLESUR
 	bool "Sibyte BCM91250C2-LittleSur"
-	depends on EXPERIMENTAL
 	select BOOT_ELF32
 	select DMA_COHERENT
 	select HAVE_PATA_PLATFORM
@@ -630,7 +623,6 @@ config SIBYTE_LITTLESUR
 
 config SIBYTE_SENTOSA
 	bool "Sibyte BCM91250E-Sentosa"
-	depends on EXPERIMENTAL
 	select BOOT_ELF32
 	select DMA_COHERENT
 	select NR_CPUS_DEFAULT_2
@@ -782,7 +774,6 @@ config CAVIUM_OCTEON_REFERENCE_BOARD
 
 config NLM_XLR_BOARD
 	bool "Netlogic XLR/XLS based systems"
-	depends on EXPERIMENTAL
 	select BOOT_ELF32
 	select NLM_COMMON
 	select SYS_HAS_CPU_XLR
@@ -811,7 +802,6 @@ config NLM_XLR_BOARD
 
 config NLM_XLP_BOARD
 	bool "Netlogic XLP based systems"
-	depends on EXPERIMENTAL
 	select BOOT_ELF32
 	select NLM_COMMON
 	select SYS_HAS_CPU_XLP
@@ -1387,7 +1377,6 @@ config CPU_R5500
 
 config CPU_R6000
 	bool "R6000"
-	depends on EXPERIMENTAL
 	depends on SYS_HAS_CPU_R6000
 	select CPU_SUPPORTS_32BIT_KERNEL
 	help
@@ -1404,7 +1393,6 @@ config CPU_NEVADA
 
 config CPU_R8000
 	bool "R8000"
-	depends on EXPERIMENTAL
 	depends on SYS_HAS_CPU_R8000
 	select CPU_HAS_PREFETCH
 	select CPU_SUPPORTS_64BIT_KERNEL
@@ -1814,7 +1802,7 @@ config PAGE_SIZE_32KB
 
 config PAGE_SIZE_64KB
 	bool "64kB"
-	depends on EXPERIMENTAL && !CPU_R3000 && !CPU_TX39XX
+	depends on !CPU_R3000 && !CPU_TX39XX
 	help
 	  Using 64kB page size will result in higher performance kernel at
 	  the price of higher memory consumption.  This option is available on
@@ -2326,8 +2314,7 @@ config HZ
 source "kernel/Kconfig.preempt"
 
 config KEXEC
-	bool "Kexec system call (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	bool "Kexec system call"
 	help
 	  kexec is a system call that implements the ability to shutdown your
 	  current kernel, and to start another kernel.  It is like a reboot
diff --git a/arch/mips/configs/ar7_defconfig b/arch/mips/configs/ar7_defconfig
index 6cd5a51..28a746d 100644
--- a/arch/mips/configs/ar7_defconfig
+++ b/arch/mips/configs/ar7_defconfig
@@ -3,7 +3,6 @@ CONFIG_HIGH_RES_TIMERS=y
 CONFIG_HZ_100=y
 CONFIG_KEXEC=y
 # CONFIG_SECCOMP is not set
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_KERNEL_LZMA=y
 CONFIG_SYSVIPC=y
diff --git a/arch/mips/configs/bcm47xx_defconfig b/arch/mips/configs/bcm47xx_defconfig
index ad15fb1..ff1218d 100644
--- a/arch/mips/configs/bcm47xx_defconfig
+++ b/arch/mips/configs/bcm47xx_defconfig
@@ -3,7 +3,6 @@ CONFIG_NO_HZ=y
 CONFIG_HIGH_RES_TIMERS=y
 CONFIG_KEXEC=y
 # CONFIG_SECCOMP is not set
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
diff --git a/arch/mips/configs/bcm63xx_defconfig b/arch/mips/configs/bcm63xx_defconfig
index 9190051..3110255 100644
--- a/arch/mips/configs/bcm63xx_defconfig
+++ b/arch/mips/configs/bcm63xx_defconfig
@@ -5,7 +5,6 @@ CONFIG_BCM63XX_CPU_6348=y
 CONFIG_BCM63XX_CPU_6358=y
 CONFIG_NO_HZ=y
 # CONFIG_SECCOMP is not set
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 # CONFIG_SWAP is not set
 CONFIG_TINY_RCU=y
diff --git a/arch/mips/configs/bigsur_defconfig b/arch/mips/configs/bigsur_defconfig
index 1cdff6b..ee978a1 100644
--- a/arch/mips/configs/bigsur_defconfig
+++ b/arch/mips/configs/bigsur_defconfig
@@ -4,7 +4,6 @@ CONFIG_SMP=y
 CONFIG_NO_HZ=y
 CONFIG_HIGH_RES_TIMERS=y
 CONFIG_HZ_1000=y
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_BSD_PROCESS_ACCT=y
diff --git a/arch/mips/configs/capcella_defconfig b/arch/mips/configs/capcella_defconfig
index 5135dc0..d2d7c86 100644
--- a/arch/mips/configs/capcella_defconfig
+++ b/arch/mips/configs/capcella_defconfig
@@ -1,6 +1,5 @@
 CONFIG_MACH_VR41XX=y
 CONFIG_ZAO_CAPCELLA=y
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
diff --git a/arch/mips/configs/cavium-octeon_defconfig b/arch/mips/configs/cavium-octeon_defconfig
index 75165df..9caff17 100644
--- a/arch/mips/configs/cavium-octeon_defconfig
+++ b/arch/mips/configs/cavium-octeon_defconfig
@@ -3,7 +3,6 @@ CONFIG_CAVIUM_OCTEON_CVMSEG_SIZE=2
 CONFIG_SPARSEMEM_MANUAL=y
 CONFIG_SMP=y
 CONFIG_PREEMPT=y
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_BSD_PROCESS_ACCT=y
diff --git a/arch/mips/configs/cobalt_defconfig b/arch/mips/configs/cobalt_defconfig
index 5419adb..a2c21da 100644
--- a/arch/mips/configs/cobalt_defconfig
+++ b/arch/mips/configs/cobalt_defconfig
@@ -1,5 +1,4 @@
 CONFIG_MIPS_COBALT=y
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_RELAY=y
diff --git a/arch/mips/configs/db1000_defconfig b/arch/mips/configs/db1000_defconfig
index 17a36c1..25c791b 100644
--- a/arch/mips/configs/db1000_defconfig
+++ b/arch/mips/configs/db1000_defconfig
@@ -8,7 +8,6 @@ CONFIG_HIGH_RES_TIMERS=y
 CONFIG_HZ_100=y
 CONFIG_HZ=100
 CONFIG_PREEMPT_NONE=y
-CONFIG_EXPERIMENTAL=y
 CONFIG_BROKEN_ON_SMP=y
 CONFIG_INIT_ENV_ARG_LIMIT=32
 CONFIG_CROSS_COMPILE=""
diff --git a/arch/mips/configs/db1200_defconfig b/arch/mips/configs/db1200_defconfig
index 1f69249..b7bf13f 100644
--- a/arch/mips/configs/db1200_defconfig
+++ b/arch/mips/configs/db1200_defconfig
@@ -5,7 +5,6 @@ CONFIG_NO_HZ=y
 CONFIG_HIGH_RES_TIMERS=y
 CONFIG_HZ_100=y
 # CONFIG_SECCOMP is not set
-CONFIG_EXPERIMENTAL=y
 CONFIG_LOCALVERSION="-db1200"
 CONFIG_KERNEL_LZMA=y
 CONFIG_SYSVIPC=y
diff --git a/arch/mips/configs/db1300_defconfig b/arch/mips/configs/db1300_defconfig
index 3590ab5..d0574ae 100644
--- a/arch/mips/configs/db1300_defconfig
+++ b/arch/mips/configs/db1300_defconfig
@@ -66,7 +66,6 @@ CONFIG_STACKTRACE_SUPPORT=y
 CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
 CONFIG_CONSTRUCTORS=y
 CONFIG_HAVE_IRQ_WORK=y
-CONFIG_EXPERIMENTAL=y
 CONFIG_BROKEN_ON_SMP=y
 CONFIG_INIT_ENV_ARG_LIMIT=32
 CONFIG_CROSS_COMPILE=""
diff --git a/arch/mips/configs/db1550_defconfig b/arch/mips/configs/db1550_defconfig
index 36cda27..a696288 100644
--- a/arch/mips/configs/db1550_defconfig
+++ b/arch/mips/configs/db1550_defconfig
@@ -8,7 +8,6 @@ CONFIG_NO_HZ=y
 CONFIG_HIGH_RES_TIMERS=y
 CONFIG_HZ_100=y
 CONFIG_HZ=100
-CONFIG_EXPERIMENTAL=y
 CONFIG_BROKEN_ON_SMP=y
 CONFIG_INIT_ENV_ARG_LIMIT=32
 CONFIG_LOCALVERSION="-db1550"
diff --git a/arch/mips/configs/decstation_defconfig b/arch/mips/configs/decstation_defconfig
index 87d0340..cffc784 100644
--- a/arch/mips/configs/decstation_defconfig
+++ b/arch/mips/configs/decstation_defconfig
@@ -1,6 +1,5 @@
 CONFIG_MACH_DECSTATION=y
 CONFIG_CPU_R3000=y
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
diff --git a/arch/mips/configs/e55_defconfig b/arch/mips/configs/e55_defconfig
index 0126e66..6326a81 100644
--- a/arch/mips/configs/e55_defconfig
+++ b/arch/mips/configs/e55_defconfig
@@ -1,6 +1,5 @@
 CONFIG_MACH_VR41XX=y
 CONFIG_CASIO_E55=y
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
diff --git a/arch/mips/configs/fuloong2e_defconfig b/arch/mips/configs/fuloong2e_defconfig
index e5b73de..0ffd387 100644
--- a/arch/mips/configs/fuloong2e_defconfig
+++ b/arch/mips/configs/fuloong2e_defconfig
@@ -3,7 +3,6 @@ CONFIG_64BIT=y
 CONFIG_NO_HZ=y
 CONFIG_HIGH_RES_TIMERS=y
 CONFIG_PREEMPT_VOLUNTARY=y
-CONFIG_EXPERIMENTAL=y
 CONFIG_LOCALVERSION="-fuloong2e"
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
diff --git a/arch/mips/configs/gpr_defconfig b/arch/mips/configs/gpr_defconfig
index 48a40ae..88a8afe 100644
--- a/arch/mips/configs/gpr_defconfig
+++ b/arch/mips/configs/gpr_defconfig
@@ -2,7 +2,6 @@ CONFIG_MIPS_ALCHEMY=y
 CONFIG_MIPS_GPR=y
 CONFIG_HIGH_RES_TIMERS=y
 CONFIG_PREEMPT_VOLUNTARY=y
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
diff --git a/arch/mips/configs/ip22_defconfig b/arch/mips/configs/ip22_defconfig
index d160656..d923862 100644
--- a/arch/mips/configs/ip22_defconfig
+++ b/arch/mips/configs/ip22_defconfig
@@ -4,7 +4,6 @@ CONFIG_NO_HZ=y
 CONFIG_HIGH_RES_TIMERS=y
 CONFIG_HZ_1000=y
 CONFIG_PREEMPT_VOLUNTARY=y
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
diff --git a/arch/mips/configs/ip27_defconfig b/arch/mips/configs/ip27_defconfig
index 0e36abc..ba3fb10 100644
--- a/arch/mips/configs/ip27_defconfig
+++ b/arch/mips/configs/ip27_defconfig
@@ -5,7 +5,6 @@ CONFIG_SMP=y
 CONFIG_NO_HZ=y
 CONFIG_HIGH_RES_TIMERS=y
 CONFIG_HZ_1000=y
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_IKCONFIG=y
diff --git a/arch/mips/configs/ip28_defconfig b/arch/mips/configs/ip28_defconfig
index 4dbf626..e8a32bf 100644
--- a/arch/mips/configs/ip28_defconfig
+++ b/arch/mips/configs/ip28_defconfig
@@ -1,7 +1,6 @@
 CONFIG_SGI_IP28=y
 CONFIG_ARC_CONSOLE=y
 CONFIG_PREEMPT_VOLUNTARY=y
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
diff --git a/arch/mips/configs/ip32_defconfig b/arch/mips/configs/ip32_defconfig
index 7bbd521..8711ade 100644
--- a/arch/mips/configs/ip32_defconfig
+++ b/arch/mips/configs/ip32_defconfig
@@ -1,6 +1,5 @@
 CONFIG_SGI_IP32=y
 # CONFIG_SECCOMP is not set
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_BSD_PROCESS_ACCT=y
diff --git a/arch/mips/configs/jazz_defconfig b/arch/mips/configs/jazz_defconfig
index 92a60ae..511bea2 100644
--- a/arch/mips/configs/jazz_defconfig
+++ b/arch/mips/configs/jazz_defconfig
@@ -1,7 +1,6 @@
 CONFIG_MACH_JAZZ=y
 CONFIG_OLIVETTI_M700=y
 CONFIG_PREEMPT_VOLUNTARY=y
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_BSD_PROCESS_ACCT=y
diff --git a/arch/mips/configs/lasat_defconfig b/arch/mips/configs/lasat_defconfig
index d9f3db2..315317f 100644
--- a/arch/mips/configs/lasat_defconfig
+++ b/arch/mips/configs/lasat_defconfig
@@ -5,7 +5,6 @@ CONFIG_DS1603=y
 CONFIG_LASAT_SYSCTL=y
 CONFIG_HZ_1000=y
 # CONFIG_SECCOMP is not set
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_EXPERT=y
diff --git a/arch/mips/configs/lemote2f_defconfig b/arch/mips/configs/lemote2f_defconfig
index b6acd2f..56fd63b 100644
--- a/arch/mips/configs/lemote2f_defconfig
+++ b/arch/mips/configs/lemote2f_defconfig
@@ -7,7 +7,6 @@ CONFIG_HIGH_RES_TIMERS=y
 CONFIG_PREEMPT=y
 CONFIG_KEXEC=y
 # CONFIG_SECCOMP is not set
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
diff --git a/arch/mips/configs/ls1b_defconfig b/arch/mips/configs/ls1b_defconfig
index 80cff8b..ab4cf53 100644
--- a/arch/mips/configs/ls1b_defconfig
+++ b/arch/mips/configs/ls1b_defconfig
@@ -1,7 +1,6 @@
 CONFIG_MACH_LOONGSON1=y
 CONFIG_PREEMPT=y
 # CONFIG_SECCOMP is not set
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
diff --git a/arch/mips/configs/malta_defconfig b/arch/mips/configs/malta_defconfig
index 5527abb..186adb1 100644
--- a/arch/mips/configs/malta_defconfig
+++ b/arch/mips/configs/malta_defconfig
@@ -5,7 +5,6 @@ CONFIG_MIPS_MT_SMP=y
 CONFIG_NO_HZ=y
 CONFIG_HIGH_RES_TIMERS=y
 CONFIG_HZ_100=y
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=15
 CONFIG_SYSFS_DEPRECATED_V2=y
diff --git a/arch/mips/configs/markeins_defconfig b/arch/mips/configs/markeins_defconfig
index 9c9a123..3f450a2 100644
--- a/arch/mips/configs/markeins_defconfig
+++ b/arch/mips/configs/markeins_defconfig
@@ -1,7 +1,6 @@
 CONFIG_NEC_MARKEINS=y
 CONFIG_HZ_1000=y
 CONFIG_PREEMPT=y
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_BSD_PROCESS_ACCT=y
diff --git a/arch/mips/configs/mipssim_defconfig b/arch/mips/configs/mipssim_defconfig
index b5ad738..3295b67 100644
--- a/arch/mips/configs/mipssim_defconfig
+++ b/arch/mips/configs/mipssim_defconfig
@@ -2,7 +2,6 @@ CONFIG_MIPS_SIM=y
 CONFIG_CPU_LITTLE_ENDIAN=y
 CONFIG_HZ_100=y
 # CONFIG_SECCOMP is not set
-CONFIG_EXPERIMENTAL=y
 # CONFIG_SWAP is not set
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
diff --git a/arch/mips/configs/mpc30x_defconfig b/arch/mips/configs/mpc30x_defconfig
index c16de98..5156683 100644
--- a/arch/mips/configs/mpc30x_defconfig
+++ b/arch/mips/configs/mpc30x_defconfig
@@ -1,6 +1,5 @@
 CONFIG_MACH_VR41XX=y
 CONFIG_VICTOR_MPC30X=y
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_RELAY=y
diff --git a/arch/mips/configs/msp71xx_defconfig b/arch/mips/configs/msp71xx_defconfig
index d1142e9..1189e6f 100644
--- a/arch/mips/configs/msp71xx_defconfig
+++ b/arch/mips/configs/msp71xx_defconfig
@@ -2,7 +2,6 @@ CONFIG_PMC_MSP=y
 CONFIG_PMC_MSP7120_GW=y
 CONFIG_CPU_MIPS32_R2=y
 CONFIG_PREEMPT=y
-CONFIG_EXPERIMENTAL=y
 CONFIG_LOCALVERSION="-pmc"
 # CONFIG_SWAP is not set
 CONFIG_SYSVIPC=y
diff --git a/arch/mips/configs/mtx1_defconfig b/arch/mips/configs/mtx1_defconfig
index 46c61ed..313e25d 100644
--- a/arch/mips/configs/mtx1_defconfig
+++ b/arch/mips/configs/mtx1_defconfig
@@ -1,7 +1,6 @@
 CONFIG_MIPS_ALCHEMY=y
 CONFIG_MIPS_MTX1=y
 CONFIG_PREEMPT_VOLUNTARY=y
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
diff --git a/arch/mips/configs/nlm_xlp_defconfig b/arch/mips/configs/nlm_xlp_defconfig
index 28c6b27..4fc2caf 100644
--- a/arch/mips/configs/nlm_xlp_defconfig
+++ b/arch/mips/configs/nlm_xlp_defconfig
@@ -7,7 +7,6 @@ CONFIG_NO_HZ=y
 CONFIG_HIGH_RES_TIMERS=y
 # CONFIG_SECCOMP is not set
 CONFIG_USE_OF=y
-CONFIG_EXPERIMENTAL=y
 CONFIG_CROSS_COMPILE=""
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
diff --git a/arch/mips/configs/nlm_xlr_defconfig b/arch/mips/configs/nlm_xlr_defconfig
index 138f698..8b3b1e8 100644
--- a/arch/mips/configs/nlm_xlr_defconfig
+++ b/arch/mips/configs/nlm_xlr_defconfig
@@ -7,7 +7,6 @@ CONFIG_NO_HZ=y
 CONFIG_HIGH_RES_TIMERS=y
 CONFIG_PREEMPT_VOLUNTARY=y
 CONFIG_KEXEC=y
-CONFIG_EXPERIMENTAL=y
 CONFIG_CROSS_COMPILE=""
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
diff --git a/arch/mips/configs/pb1100_defconfig b/arch/mips/configs/pb1100_defconfig
index 75eb1b1..f285505 100644
--- a/arch/mips/configs/pb1100_defconfig
+++ b/arch/mips/configs/pb1100_defconfig
@@ -4,7 +4,6 @@ CONFIG_NO_HZ=y
 CONFIG_HIGH_RES_TIMERS=y
 CONFIG_HZ_100=y
 # CONFIG_SECCOMP is not set
-CONFIG_EXPERIMENTAL=y
 CONFIG_LOCALVERSION="-pb1100"
 CONFIG_KERNEL_LZMA=y
 CONFIG_SYSVIPC=y
diff --git a/arch/mips/configs/pb1500_defconfig b/arch/mips/configs/pb1500_defconfig
index fa00487..9745e34 100644
--- a/arch/mips/configs/pb1500_defconfig
+++ b/arch/mips/configs/pb1500_defconfig
@@ -4,7 +4,6 @@ CONFIG_NO_HZ=y
 CONFIG_HIGH_RES_TIMERS=y
 CONFIG_HZ_100=y
 # CONFIG_SECCOMP is not set
-CONFIG_EXPERIMENTAL=y
 CONFIG_LOCALVERSION="-pb1500"
 CONFIG_KERNEL_LZMA=y
 CONFIG_SYSVIPC=y
diff --git a/arch/mips/configs/pb1550_defconfig b/arch/mips/configs/pb1550_defconfig
index e83d649..a153f58 100644
--- a/arch/mips/configs/pb1550_defconfig
+++ b/arch/mips/configs/pb1550_defconfig
@@ -4,7 +4,6 @@ CONFIG_NO_HZ=y
 CONFIG_HIGH_RES_TIMERS=y
 CONFIG_HZ_100=y
 # CONFIG_SECCOMP is not set
-CONFIG_EXPERIMENTAL=y
 CONFIG_LOCALVERSION="-pb1550"
 CONFIG_KERNEL_LZMA=y
 CONFIG_SYSVIPC=y
diff --git a/arch/mips/configs/pnx8335-stb225_defconfig b/arch/mips/configs/pnx8335-stb225_defconfig
index f292576..6c53fb6 100644
--- a/arch/mips/configs/pnx8335-stb225_defconfig
+++ b/arch/mips/configs/pnx8335-stb225_defconfig
@@ -5,7 +5,6 @@ CONFIG_HIGH_RES_TIMERS=y
 CONFIG_HZ_128=y
 CONFIG_PREEMPT_VOLUNTARY=y
 # CONFIG_SECCOMP is not set
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 # CONFIG_SWAP is not set
 CONFIG_SYSVIPC=y
diff --git a/arch/mips/configs/pnx8550-jbs_defconfig b/arch/mips/configs/pnx8550-jbs_defconfig
index 1d1f206..a9cc6ae 100644
--- a/arch/mips/configs/pnx8550-jbs_defconfig
+++ b/arch/mips/configs/pnx8550-jbs_defconfig
@@ -1,5 +1,4 @@
 CONFIG_PNX8550_JBS=y
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
diff --git a/arch/mips/configs/pnx8550-stb810_defconfig b/arch/mips/configs/pnx8550-stb810_defconfig
index 15c66a5..aed1879 100644
--- a/arch/mips/configs/pnx8550-stb810_defconfig
+++ b/arch/mips/configs/pnx8550-stb810_defconfig
@@ -1,5 +1,4 @@
 CONFIG_PNX8550_STB810=y
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
diff --git a/arch/mips/configs/powertv_defconfig b/arch/mips/configs/powertv_defconfig
index 7fda0ce..1eec477 100644
--- a/arch/mips/configs/powertv_defconfig
+++ b/arch/mips/configs/powertv_defconfig
@@ -5,7 +5,6 @@ CONFIG_HIGH_RES_TIMERS=y
 CONFIG_HZ_1000=y
 CONFIG_PREEMPT=y
 # CONFIG_SECCOMP is not set
-CONFIG_EXPERIMENTAL=y
 CONFIG_CROSS_COMPILE=""
 # CONFIG_SWAP is not set
 CONFIG_SYSVIPC=y
diff --git a/arch/mips/configs/rb532_defconfig b/arch/mips/configs/rb532_defconfig
index 55902d9..a0f5ba8 100644
--- a/arch/mips/configs/rb532_defconfig
+++ b/arch/mips/configs/rb532_defconfig
@@ -3,7 +3,6 @@ CONFIG_NO_HZ=y
 CONFIG_HIGH_RES_TIMERS=y
 CONFIG_HZ_100=y
 # CONFIG_SECCOMP is not set
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
diff --git a/arch/mips/configs/rm200_defconfig b/arch/mips/configs/rm200_defconfig
index 2c0230e..7caa43e 100644
--- a/arch/mips/configs/rm200_defconfig
+++ b/arch/mips/configs/rm200_defconfig
@@ -3,7 +3,6 @@ CONFIG_CPU_LITTLE_ENDIAN=y
 CONFIG_ARC_CONSOLE=y
 CONFIG_HZ_1000=y
 CONFIG_PREEMPT_VOLUNTARY=y
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_BSD_PROCESS_ACCT=y
diff --git a/arch/mips/configs/sb1250-swarm_defconfig b/arch/mips/configs/sb1250-swarm_defconfig
index 5b0463e..49ee408 100644
--- a/arch/mips/configs/sb1250-swarm_defconfig
+++ b/arch/mips/configs/sb1250-swarm_defconfig
@@ -4,7 +4,6 @@ CONFIG_64BIT=y
 CONFIG_SMP=y
 CONFIG_HIGH_RES_TIMERS=y
 CONFIG_HZ_1000=y
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=15
 CONFIG_CGROUPS=y
diff --git a/arch/mips/configs/tb0219_defconfig b/arch/mips/configs/tb0219_defconfig
index 30036b4..4e397e2 100644
--- a/arch/mips/configs/tb0219_defconfig
+++ b/arch/mips/configs/tb0219_defconfig
@@ -1,6 +1,5 @@
 CONFIG_MACH_VR41XX=y
 CONFIG_TANBAC_TB0219=y
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
diff --git a/arch/mips/configs/tb0226_defconfig b/arch/mips/configs/tb0226_defconfig
index 81bfa1d..c64b7b1 100644
--- a/arch/mips/configs/tb0226_defconfig
+++ b/arch/mips/configs/tb0226_defconfig
@@ -1,6 +1,5 @@
 CONFIG_MACH_VR41XX=y
 CONFIG_TANBAC_TB0226=y
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
diff --git a/arch/mips/configs/tb0287_defconfig b/arch/mips/configs/tb0287_defconfig
index c415c4f..9a83374 100644
--- a/arch/mips/configs/tb0287_defconfig
+++ b/arch/mips/configs/tb0287_defconfig
@@ -1,5 +1,4 @@
 CONFIG_MACH_VR41XX=y
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
diff --git a/arch/mips/configs/workpad_defconfig b/arch/mips/configs/workpad_defconfig
index ee4b2be..ef3ea03 100644
--- a/arch/mips/configs/workpad_defconfig
+++ b/arch/mips/configs/workpad_defconfig
@@ -1,6 +1,5 @@
 CONFIG_MACH_VR41XX=y
 CONFIG_IBM_WORKPAD=y
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
diff --git a/arch/mips/configs/wrppmc_defconfig b/arch/mips/configs/wrppmc_defconfig
index 44a451b..bd82e8c 100644
--- a/arch/mips/configs/wrppmc_defconfig
+++ b/arch/mips/configs/wrppmc_defconfig
@@ -1,6 +1,5 @@
 CONFIG_WR_PPMC=y
 CONFIG_HZ_1000=y
-CONFIG_EXPERIMENTAL=y
 # CONFIG_SWAP is not set
 CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
diff --git a/arch/mips/jazz/Kconfig b/arch/mips/jazz/Kconfig
index 1f372b0..fb1e072 100644
--- a/arch/mips/jazz/Kconfig
+++ b/arch/mips/jazz/Kconfig
@@ -1,6 +1,6 @@
 config ACER_PICA_61
-	bool "Support for Acer PICA 1 chipset (EXPERIMENTAL)"
-	depends on MACH_JAZZ && EXPERIMENTAL
+	bool "Support for Acer PICA 1 chipset"
+	depends on MACH_JAZZ
 	select DMA_NONCOHERENT
 	select SYS_SUPPORTS_LITTLE_ENDIAN
 	help
@@ -13,7 +13,7 @@ config MIPS_MAGNUM_4000
 	bool "Support for MIPS Magnum 4000"
 	depends on MACH_JAZZ
 	select DMA_NONCOHERENT
-	select SYS_SUPPORTS_BIG_ENDIAN if EXPERIMENTAL
+	select SYS_SUPPORTS_BIG_ENDIAN
 	select SYS_SUPPORTS_LITTLE_ENDIAN
 	help
 	  This is a machine with a R4000 100 MHz CPU. To compile a Linux
diff --git a/arch/mips/sgi-ip27/Kconfig b/arch/mips/sgi-ip27/Kconfig
index 4b2ea28..4d8705a 100644
--- a/arch/mips/sgi-ip27/Kconfig
+++ b/arch/mips/sgi-ip27/Kconfig
@@ -13,7 +13,6 @@ config SGI_SN_M_MODE
 
 config SGI_SN_N_MODE
 	bool "IP27 N-Mode"
-	depends on EXPERIMENTAL
 	help
 	  The nodes of Origin, Onyx, Fuel and Tezro systems can be configured
 	  in either N-Modes which allows for more nodes or M-Mode which allows
diff --git a/arch/mn10300/configs/asb2303_defconfig b/arch/mn10300/configs/asb2303_defconfig
index 1fd41ec..209a467 100644
--- a/arch/mn10300/configs/asb2303_defconfig
+++ b/arch/mn10300/configs/asb2303_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_TINY_RCU=y
diff --git a/arch/mn10300/configs/asb2364_defconfig b/arch/mn10300/configs/asb2364_defconfig
index fbb96ae..79a233b 100644
--- a/arch/mn10300/configs/asb2364_defconfig
+++ b/arch/mn10300/configs/asb2364_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_BSD_PROCESS_ACCT=y
diff --git a/arch/parisc/Kconfig b/arch/parisc/Kconfig
index 3ff21b5..2956ac9 100644
--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -190,12 +190,12 @@ config PARISC_PAGE_SIZE_4KB
 	  If you don't know what to do, choose 4KB.
 
 config PARISC_PAGE_SIZE_16KB
-	bool "16KB (EXPERIMENTAL)"
-	depends on PA8X00 && EXPERIMENTAL
+	bool "16KB"
+	depends on PA8X00
 
 config PARISC_PAGE_SIZE_64KB
-	bool "64KB (EXPERIMENTAL)"
-	depends on PA8X00 && EXPERIMENTAL
+	bool "64KB"
+	depends on PA8X00
 
 endchoice
 
diff --git a/arch/parisc/configs/712_defconfig b/arch/parisc/configs/712_defconfig
index 0f90569..7d9668a 100644
--- a/arch/parisc/configs/712_defconfig
+++ b/arch/parisc/configs/712_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
diff --git a/arch/parisc/configs/a500_defconfig b/arch/parisc/configs/a500_defconfig
index b647b18..d186a48 100644
--- a/arch/parisc/configs/a500_defconfig
+++ b/arch/parisc/configs/a500_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
diff --git a/arch/parisc/configs/c3000_defconfig b/arch/parisc/configs/c3000_defconfig
index 311ca36..5ff1d49 100644
--- a/arch/parisc/configs/c3000_defconfig
+++ b/arch/parisc/configs/c3000_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_IKCONFIG=y
diff --git a/arch/parisc/configs/default_defconfig b/arch/parisc/configs/default_defconfig
index dfe88f6..e136858 100644
--- a/arch/parisc/configs/default_defconfig
+++ b/arch/parisc/configs/default_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 352f416..2831a25 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -325,7 +325,7 @@ config SWIOTLB
 
 config HOTPLUG_CPU
 	bool "Support for enabling/disabling CPUs"
-	depends on SMP && HOTPLUG && EXPERIMENTAL && (PPC_PSERIES || PPC_PMAC || PPC_POWERNV)
+	depends on SMP && HOTPLUG && (PPC_PSERIES || PPC_PMAC || PPC_POWERNV)
 	---help---
 	  Say Y here to be able to disable and re-enable individual
 	  CPUs at runtime on SMP machines.
@@ -346,8 +346,8 @@ config ARCH_ENABLE_MEMORY_HOTREMOVE
 	def_bool y
 
 config KEXEC
-	bool "kexec system call (EXPERIMENTAL)"
-	depends on (PPC_BOOK3S || FSL_BOOKE || (44x && !SMP)) && EXPERIMENTAL
+	bool "kexec system call"
+	depends on (PPC_BOOK3S || FSL_BOOKE || (44x && !SMP))
 	help
 	  kexec is a system call that implements the ability to shutdown your
 	  current kernel, and to start another kernel.  It is like a reboot
@@ -834,8 +834,8 @@ config LOWMEM_CAM_NUM
 	default 3
 
 config DYNAMIC_MEMSTART
-	bool "Enable page aligned dynamic load address for kernel (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && ADVANCED_OPTIONS && FLATMEM && (FSL_BOOKE || 44x)
+	bool "Enable page aligned dynamic load address for kernel"
+	depends on ADVANCED_OPTIONS && FLATMEM && (FSL_BOOKE || 44x)
 	select NONSTATIC_KERNEL
 	help
 	  This option enables the kernel to be loaded at any page aligned
@@ -852,8 +852,8 @@ config DYNAMIC_MEMSTART
 	  This option is overridden by CONFIG_RELOCATABLE
 
 config RELOCATABLE
-	bool "Build a relocatable kernel (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && ADVANCED_OPTIONS && FLATMEM && 44x
+	bool "Build a relocatable kernel"
+	depends on ADVANCED_OPTIONS && FLATMEM && 44x
 	select NONSTATIC_KERNEL
 	help
 	  This builds a kernel image that is capable of running at the
diff --git a/arch/powerpc/configs/40x/acadia_defconfig b/arch/powerpc/configs/40x/acadia_defconfig
index ed3bab7..893aa96 100644
--- a/arch/powerpc/configs/40x/acadia_defconfig
+++ b/arch/powerpc/configs/40x/acadia_defconfig
@@ -1,5 +1,4 @@
 CONFIG_40x=y
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
diff --git a/arch/powerpc/configs/40x/ep405_defconfig b/arch/powerpc/configs/40x/ep405_defconfig
index 17582a3..54b6c61 100644
--- a/arch/powerpc/configs/40x/ep405_defconfig
+++ b/arch/powerpc/configs/40x/ep405_defconfig
@@ -1,5 +1,4 @@
 CONFIG_40x=y
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
diff --git a/arch/powerpc/configs/40x/kilauea_defconfig b/arch/powerpc/configs/40x/kilauea_defconfig
index f2d4be9..19da9b1 100644
--- a/arch/powerpc/configs/40x/kilauea_defconfig
+++ b/arch/powerpc/configs/40x/kilauea_defconfig
@@ -1,5 +1,4 @@
 CONFIG_40x=y
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
diff --git a/arch/powerpc/configs/40x/klondike_defconfig b/arch/powerpc/configs/40x/klondike_defconfig
index c0d228d..cc8a9d7 100644
--- a/arch/powerpc/configs/40x/klondike_defconfig
+++ b/arch/powerpc/configs/40x/klondike_defconfig
@@ -1,5 +1,4 @@
 CONFIG_40x=y
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED=y
diff --git a/arch/powerpc/configs/40x/makalu_defconfig b/arch/powerpc/configs/40x/makalu_defconfig
index 42b9793..82b326d 100644
--- a/arch/powerpc/configs/40x/makalu_defconfig
+++ b/arch/powerpc/configs/40x/makalu_defconfig
@@ -1,5 +1,4 @@
 CONFIG_40x=y
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
diff --git a/arch/powerpc/configs/40x/obs600_defconfig b/arch/powerpc/configs/40x/obs600_defconfig
index 91c110d..755fbcf 100644
--- a/arch/powerpc/configs/40x/obs600_defconfig
+++ b/arch/powerpc/configs/40x/obs600_defconfig
@@ -1,5 +1,4 @@
 CONFIG_40x=y
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
diff --git a/arch/powerpc/configs/40x/virtex_defconfig b/arch/powerpc/configs/40x/virtex_defconfig
index 0a81e1f..473636a 100644
--- a/arch/powerpc/configs/40x/virtex_defconfig
+++ b/arch/powerpc/configs/40x/virtex_defconfig
@@ -1,5 +1,4 @@
 CONFIG_40x=y
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
diff --git a/arch/powerpc/configs/40x/walnut_defconfig b/arch/powerpc/configs/40x/walnut_defconfig
index aa1a4ca..65d75e3 100644
--- a/arch/powerpc/configs/40x/walnut_defconfig
+++ b/arch/powerpc/configs/40x/walnut_defconfig
@@ -1,5 +1,4 @@
 CONFIG_40x=y
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
diff --git a/arch/powerpc/configs/44x/arches_defconfig b/arch/powerpc/configs/44x/arches_defconfig
index 329f9a3..35d1015 100644
--- a/arch/powerpc/configs/44x/arches_defconfig
+++ b/arch/powerpc/configs/44x/arches_defconfig
@@ -1,5 +1,4 @@
 CONFIG_44x=y
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
diff --git a/arch/powerpc/configs/44x/bamboo_defconfig b/arch/powerpc/configs/44x/bamboo_defconfig
index cef7d62..a3eff35 100644
--- a/arch/powerpc/configs/44x/bamboo_defconfig
+++ b/arch/powerpc/configs/44x/bamboo_defconfig
@@ -1,5 +1,4 @@
 CONFIG_44x=y
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
diff --git a/arch/powerpc/configs/44x/bluestone_defconfig b/arch/powerpc/configs/44x/bluestone_defconfig
index 20c8d26..fedfae4 100644
--- a/arch/powerpc/configs/44x/bluestone_defconfig
+++ b/arch/powerpc/configs/44x/bluestone_defconfig
@@ -1,5 +1,4 @@
 CONFIG_44x=y
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
diff --git a/arch/powerpc/configs/44x/canyonlands_defconfig b/arch/powerpc/configs/44x/canyonlands_defconfig
index d5be93e..a3e77ce 100644
--- a/arch/powerpc/configs/44x/canyonlands_defconfig
+++ b/arch/powerpc/configs/44x/canyonlands_defconfig
@@ -1,5 +1,4 @@
 CONFIG_44x=y
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
diff --git a/arch/powerpc/configs/44x/currituck_defconfig b/arch/powerpc/configs/44x/currituck_defconfig
index 4192322..a178d83 100644
--- a/arch/powerpc/configs/44x/currituck_defconfig
+++ b/arch/powerpc/configs/44x/currituck_defconfig
@@ -1,6 +1,5 @@
 CONFIG_44x=y
 CONFIG_SMP=y
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_SPARSE_IRQ=y
diff --git a/arch/powerpc/configs/44x/ebony_defconfig b/arch/powerpc/configs/44x/ebony_defconfig
index f9269fc..b95a9bf 100644
--- a/arch/powerpc/configs/44x/ebony_defconfig
+++ b/arch/powerpc/configs/44x/ebony_defconfig
@@ -1,5 +1,4 @@
 CONFIG_44x=y
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
diff --git a/arch/powerpc/configs/44x/eiger_defconfig b/arch/powerpc/configs/44x/eiger_defconfig
index 9be0890..e53375e 100644
--- a/arch/powerpc/configs/44x/eiger_defconfig
+++ b/arch/powerpc/configs/44x/eiger_defconfig
@@ -1,5 +1,4 @@
 CONFIG_44x=y
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
diff --git a/arch/powerpc/configs/44x/icon_defconfig b/arch/powerpc/configs/44x/icon_defconfig
index 82f7303..d4bad1a 100644
--- a/arch/powerpc/configs/44x/icon_defconfig
+++ b/arch/powerpc/configs/44x/icon_defconfig
@@ -1,5 +1,4 @@
 CONFIG_44x=y
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
diff --git a/arch/powerpc/configs/44x/iss476-smp_defconfig b/arch/powerpc/configs/44x/iss476-smp_defconfig
index ca00cf7..2e78295 100644
--- a/arch/powerpc/configs/44x/iss476-smp_defconfig
+++ b/arch/powerpc/configs/44x/iss476-smp_defconfig
@@ -1,6 +1,5 @@
 CONFIG_44x=y
 CONFIG_SMP=y
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_SPARSE_IRQ=y
diff --git a/arch/powerpc/configs/44x/katmai_defconfig b/arch/powerpc/configs/44x/katmai_defconfig
index 109562c..15466c9 100644
--- a/arch/powerpc/configs/44x/katmai_defconfig
+++ b/arch/powerpc/configs/44x/katmai_defconfig
@@ -1,5 +1,4 @@
 CONFIG_44x=y
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
diff --git a/arch/powerpc/configs/44x/rainier_defconfig b/arch/powerpc/configs/44x/rainier_defconfig
index 21c33fa..1318bb4 100644
--- a/arch/powerpc/configs/44x/rainier_defconfig
+++ b/arch/powerpc/configs/44x/rainier_defconfig
@@ -1,5 +1,4 @@
 CONFIG_44x=y
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
diff --git a/arch/powerpc/configs/44x/redwood_defconfig b/arch/powerpc/configs/44x/redwood_defconfig
index 4880281..8498325 100644
--- a/arch/powerpc/configs/44x/redwood_defconfig
+++ b/arch/powerpc/configs/44x/redwood_defconfig
@@ -1,5 +1,4 @@
 CONFIG_44x=y
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
diff --git a/arch/powerpc/configs/44x/sam440ep_defconfig b/arch/powerpc/configs/44x/sam440ep_defconfig
index ca088cd..abdfc98 100644
--- a/arch/powerpc/configs/44x/sam440ep_defconfig
+++ b/arch/powerpc/configs/44x/sam440ep_defconfig
@@ -1,5 +1,4 @@
 CONFIG_44x=y
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_IKCONFIG=y
diff --git a/arch/powerpc/configs/44x/sequoia_defconfig b/arch/powerpc/configs/44x/sequoia_defconfig
index b7a653b..ef6d3b4 100644
--- a/arch/powerpc/configs/44x/sequoia_defconfig
+++ b/arch/powerpc/configs/44x/sequoia_defconfig
@@ -1,5 +1,4 @@
 CONFIG_44x=y
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
diff --git a/arch/powerpc/configs/44x/taishan_defconfig b/arch/powerpc/configs/44x/taishan_defconfig
index 30de97f..aff9aba 100644
--- a/arch/powerpc/configs/44x/taishan_defconfig
+++ b/arch/powerpc/configs/44x/taishan_defconfig
@@ -1,5 +1,4 @@
 CONFIG_44x=y
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
diff --git a/arch/powerpc/configs/44x/virtex5_defconfig b/arch/powerpc/configs/44x/virtex5_defconfig
index 1eb3caf..fc53696 100644
--- a/arch/powerpc/configs/44x/virtex5_defconfig
+++ b/arch/powerpc/configs/44x/virtex5_defconfig
@@ -1,5 +1,4 @@
 CONFIG_44x=y
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
diff --git a/arch/powerpc/configs/44x/warp_defconfig b/arch/powerpc/configs/44x/warp_defconfig
index 105bc56..7b23c02 100644
--- a/arch/powerpc/configs/44x/warp_defconfig
+++ b/arch/powerpc/configs/44x/warp_defconfig
@@ -1,5 +1,4 @@
 CONFIG_44x=y
-CONFIG_EXPERIMENTAL=y
 CONFIG_LOCALVERSION="-pika"
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
diff --git a/arch/powerpc/configs/52xx/cm5200_defconfig b/arch/powerpc/configs/52xx/cm5200_defconfig
index 69b57da..f091279 100644
--- a/arch/powerpc/configs/52xx/cm5200_defconfig
+++ b/arch/powerpc/configs/52xx/cm5200_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
diff --git a/arch/powerpc/configs/52xx/lite5200b_defconfig b/arch/powerpc/configs/52xx/lite5200b_defconfig
index f3638ae..f8ec619 100644
--- a/arch/powerpc/configs/52xx/lite5200b_defconfig
+++ b/arch/powerpc/configs/52xx/lite5200b_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
diff --git a/arch/powerpc/configs/52xx/motionpro_defconfig b/arch/powerpc/configs/52xx/motionpro_defconfig
index 0c7de96..97acb2a 100644
--- a/arch/powerpc/configs/52xx/motionpro_defconfig
+++ b/arch/powerpc/configs/52xx/motionpro_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
diff --git a/arch/powerpc/configs/52xx/pcm030_defconfig b/arch/powerpc/configs/52xx/pcm030_defconfig
index 22e7195..ba5f58c 100644
--- a/arch/powerpc/configs/52xx/pcm030_defconfig
+++ b/arch/powerpc/configs/52xx/pcm030_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_LOCALVERSION="trunk"
 # CONFIG_LOCALVERSION_AUTO is not set
 # CONFIG_SWAP is not set
diff --git a/arch/powerpc/configs/52xx/tqm5200_defconfig b/arch/powerpc/configs/52xx/tqm5200_defconfig
index 716a37b..e802ae3 100644
--- a/arch/powerpc/configs/52xx/tqm5200_defconfig
+++ b/arch/powerpc/configs/52xx/tqm5200_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_SPARSE_IRQ=y
 CONFIG_LOG_BUF_SHIFT=14
diff --git a/arch/powerpc/configs/83xx/asp8347_defconfig b/arch/powerpc/configs/83xx/asp8347_defconfig
index d2762d9..eac6bb0 100644
--- a/arch/powerpc/configs/83xx/asp8347_defconfig
+++ b/arch/powerpc/configs/83xx/asp8347_defconfig
@@ -1,5 +1,4 @@
 CONFIG_FSL_EMB_PERFMON=y
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
diff --git a/arch/powerpc/configs/83xx/kmeter1_defconfig b/arch/powerpc/configs/83xx/kmeter1_defconfig
index a0dfef1..52c8cbb 100644
--- a/arch/powerpc/configs/83xx/kmeter1_defconfig
+++ b/arch/powerpc/configs/83xx/kmeter1_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_SWAP is not set
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
diff --git a/arch/powerpc/configs/83xx/mpc8313_rdb_defconfig b/arch/powerpc/configs/83xx/mpc8313_rdb_defconfig
index 126ef1b..3d4ad02 100644
--- a/arch/powerpc/configs/83xx/mpc8313_rdb_defconfig
+++ b/arch/powerpc/configs/83xx/mpc8313_rdb_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
diff --git a/arch/powerpc/configs/83xx/mpc8315_rdb_defconfig b/arch/powerpc/configs/83xx/mpc8315_rdb_defconfig
index abcf00a..27cc904 100644
--- a/arch/powerpc/configs/83xx/mpc8315_rdb_defconfig
+++ b/arch/powerpc/configs/83xx/mpc8315_rdb_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
diff --git a/arch/powerpc/configs/83xx/mpc832x_mds_defconfig b/arch/powerpc/configs/83xx/mpc832x_mds_defconfig
index a5699a1..01a9ddb 100644
--- a/arch/powerpc/configs/83xx/mpc832x_mds_defconfig
+++ b/arch/powerpc/configs/83xx/mpc832x_mds_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
diff --git a/arch/powerpc/configs/83xx/mpc832x_rdb_defconfig b/arch/powerpc/configs/83xx/mpc832x_rdb_defconfig
index b4da1a7..7c5fba8 100644
--- a/arch/powerpc/configs/83xx/mpc832x_rdb_defconfig
+++ b/arch/powerpc/configs/83xx/mpc832x_rdb_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
diff --git a/arch/powerpc/configs/83xx/mpc834x_itx_defconfig b/arch/powerpc/configs/83xx/mpc834x_itx_defconfig
index 291f822..0a1ea0c 100644
--- a/arch/powerpc/configs/83xx/mpc834x_itx_defconfig
+++ b/arch/powerpc/configs/83xx/mpc834x_itx_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
diff --git a/arch/powerpc/configs/83xx/mpc834x_itxgp_defconfig b/arch/powerpc/configs/83xx/mpc834x_itxgp_defconfig
index f8b228a..e18e2cd 100644
--- a/arch/powerpc/configs/83xx/mpc834x_itxgp_defconfig
+++ b/arch/powerpc/configs/83xx/mpc834x_itxgp_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
diff --git a/arch/powerpc/configs/83xx/mpc834x_mds_defconfig b/arch/powerpc/configs/83xx/mpc834x_mds_defconfig
index 99660c0..56ed5ac 100644
--- a/arch/powerpc/configs/83xx/mpc834x_mds_defconfig
+++ b/arch/powerpc/configs/83xx/mpc834x_mds_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
diff --git a/arch/powerpc/configs/83xx/mpc836x_mds_defconfig b/arch/powerpc/configs/83xx/mpc836x_mds_defconfig
index 10b5c4c..d01dcfb 100644
--- a/arch/powerpc/configs/83xx/mpc836x_mds_defconfig
+++ b/arch/powerpc/configs/83xx/mpc836x_mds_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
diff --git a/arch/powerpc/configs/83xx/mpc836x_rdk_defconfig b/arch/powerpc/configs/83xx/mpc836x_rdk_defconfig
index 45925d7..454c25b 100644
--- a/arch/powerpc/configs/83xx/mpc836x_rdk_defconfig
+++ b/arch/powerpc/configs/83xx/mpc836x_rdk_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
diff --git a/arch/powerpc/configs/83xx/mpc837x_mds_defconfig b/arch/powerpc/configs/83xx/mpc837x_mds_defconfig
index f367985..c41ff2f 100644
--- a/arch/powerpc/configs/83xx/mpc837x_mds_defconfig
+++ b/arch/powerpc/configs/83xx/mpc837x_mds_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
diff --git a/arch/powerpc/configs/83xx/mpc837x_rdb_defconfig b/arch/powerpc/configs/83xx/mpc837x_rdb_defconfig
index 414eda3..78c63fc 100644
--- a/arch/powerpc/configs/83xx/mpc837x_rdb_defconfig
+++ b/arch/powerpc/configs/83xx/mpc837x_rdb_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
diff --git a/arch/powerpc/configs/83xx/sbc834x_defconfig b/arch/powerpc/configs/83xx/sbc834x_defconfig
index 6d6463f..862ad4b 100644
--- a/arch/powerpc/configs/83xx/sbc834x_defconfig
+++ b/arch/powerpc/configs/83xx/sbc834x_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
diff --git a/arch/powerpc/configs/85xx/ge_imp3a_defconfig b/arch/powerpc/configs/85xx/ge_imp3a_defconfig
index f8c51a4..09c8853 100644
--- a/arch/powerpc/configs/85xx/ge_imp3a_defconfig
+++ b/arch/powerpc/configs/85xx/ge_imp3a_defconfig
@@ -1,7 +1,6 @@
 CONFIG_PPC_85xx=y
 CONFIG_SMP=y
 CONFIG_NR_CPUS=2
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_BSD_PROCESS_ACCT=y
diff --git a/arch/powerpc/configs/85xx/ksi8560_defconfig b/arch/powerpc/configs/85xx/ksi8560_defconfig
index 8f7c106..c6f311a 100644
--- a/arch/powerpc/configs/85xx/ksi8560_defconfig
+++ b/arch/powerpc/configs/85xx/ksi8560_defconfig
@@ -1,5 +1,4 @@
 CONFIG_PPC_85xx=y
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
diff --git a/arch/powerpc/configs/85xx/mpc8540_ads_defconfig b/arch/powerpc/configs/85xx/mpc8540_ads_defconfig
index 11662c2..cdb13eb 100644
--- a/arch/powerpc/configs/85xx/mpc8540_ads_defconfig
+++ b/arch/powerpc/configs/85xx/mpc8540_ads_defconfig
@@ -1,5 +1,4 @@
 CONFIG_PPC_85xx=y
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
diff --git a/arch/powerpc/configs/85xx/mpc8560_ads_defconfig b/arch/powerpc/configs/85xx/mpc8560_ads_defconfig
index ebe9b30..c89c7fe 100644
--- a/arch/powerpc/configs/85xx/mpc8560_ads_defconfig
+++ b/arch/powerpc/configs/85xx/mpc8560_ads_defconfig
@@ -1,5 +1,4 @@
 CONFIG_PPC_85xx=y
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
diff --git a/arch/powerpc/configs/85xx/mpc85xx_cds_defconfig b/arch/powerpc/configs/85xx/mpc85xx_cds_defconfig
index eb25229..54842a8 100644
--- a/arch/powerpc/configs/85xx/mpc85xx_cds_defconfig
+++ b/arch/powerpc/configs/85xx/mpc85xx_cds_defconfig
@@ -1,5 +1,4 @@
 CONFIG_PPC_85xx=y
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
diff --git a/arch/powerpc/configs/85xx/p1023rds_defconfig b/arch/powerpc/configs/85xx/p1023rds_defconfig
index 26e541c..db2a3a2 100644
--- a/arch/powerpc/configs/85xx/p1023rds_defconfig
+++ b/arch/powerpc/configs/85xx/p1023rds_defconfig
@@ -1,7 +1,6 @@
 CONFIG_PPC_85xx=y
 CONFIG_SMP=y
 CONFIG_NR_CPUS=2
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_BSD_PROCESS_ACCT=y
diff --git a/arch/powerpc/configs/85xx/sbc8548_defconfig b/arch/powerpc/configs/85xx/sbc8548_defconfig
index 5b2b651..98098c5 100644
--- a/arch/powerpc/configs/85xx/sbc8548_defconfig
+++ b/arch/powerpc/configs/85xx/sbc8548_defconfig
@@ -1,5 +1,4 @@
 CONFIG_PPC_85xx=y
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
diff --git a/arch/powerpc/configs/85xx/socrates_defconfig b/arch/powerpc/configs/85xx/socrates_defconfig
index 77506b5..59094a2 100644
--- a/arch/powerpc/configs/85xx/socrates_defconfig
+++ b/arch/powerpc/configs/85xx/socrates_defconfig
@@ -1,5 +1,4 @@
 CONFIG_PPC_85xx=y
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=16
 CONFIG_BLK_DEV_INITRD=y
diff --git a/arch/powerpc/configs/85xx/stx_gp3_defconfig b/arch/powerpc/configs/85xx/stx_gp3_defconfig
index 5d4db15..b7fc342 100644
--- a/arch/powerpc/configs/85xx/stx_gp3_defconfig
+++ b/arch/powerpc/configs/85xx/stx_gp3_defconfig
@@ -1,5 +1,4 @@
 CONFIG_PPC_85xx=y
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
diff --git a/arch/powerpc/configs/85xx/tqm8540_defconfig b/arch/powerpc/configs/85xx/tqm8540_defconfig
index ddcb9f3..415d760 100644
--- a/arch/powerpc/configs/85xx/tqm8540_defconfig
+++ b/arch/powerpc/configs/85xx/tqm8540_defconfig
@@ -1,5 +1,4 @@
 CONFIG_PPC_85xx=y
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
diff --git a/arch/powerpc/configs/85xx/tqm8541_defconfig b/arch/powerpc/configs/85xx/tqm8541_defconfig
index 981abd6..20e5427 100644
--- a/arch/powerpc/configs/85xx/tqm8541_defconfig
+++ b/arch/powerpc/configs/85xx/tqm8541_defconfig
@@ -1,5 +1,4 @@
 CONFIG_PPC_85xx=y
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
diff --git a/arch/powerpc/configs/85xx/tqm8548_defconfig b/arch/powerpc/configs/85xx/tqm8548_defconfig
index 37b3d72..054449d 100644
--- a/arch/powerpc/configs/85xx/tqm8548_defconfig
+++ b/arch/powerpc/configs/85xx/tqm8548_defconfig
@@ -1,5 +1,4 @@
 CONFIG_PPC_85xx=y
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
diff --git a/arch/powerpc/configs/85xx/tqm8555_defconfig b/arch/powerpc/configs/85xx/tqm8555_defconfig
index 3593b32..82dc791 100644
--- a/arch/powerpc/configs/85xx/tqm8555_defconfig
+++ b/arch/powerpc/configs/85xx/tqm8555_defconfig
@@ -1,5 +1,4 @@
 CONFIG_PPC_85xx=y
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
diff --git a/arch/powerpc/configs/85xx/tqm8560_defconfig b/arch/powerpc/configs/85xx/tqm8560_defconfig
index de413ac..9fd75b2 100644
--- a/arch/powerpc/configs/85xx/tqm8560_defconfig
+++ b/arch/powerpc/configs/85xx/tqm8560_defconfig
@@ -1,5 +1,4 @@
 CONFIG_PPC_85xx=y
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
diff --git a/arch/powerpc/configs/85xx/xes_mpc85xx_defconfig b/arch/powerpc/configs/85xx/xes_mpc85xx_defconfig
index 1cd6fcb..c2d1a8d 100644
--- a/arch/powerpc/configs/85xx/xes_mpc85xx_defconfig
+++ b/arch/powerpc/configs/85xx/xes_mpc85xx_defconfig
@@ -1,7 +1,6 @@
 CONFIG_PPC_85xx=y
 CONFIG_SMP=y
 CONFIG_NR_CPUS=2
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_BSD_PROCESS_ACCT=y
diff --git a/arch/powerpc/configs/86xx/gef_ppc9a_defconfig b/arch/powerpc/configs/86xx/gef_ppc9a_defconfig
index da731c2..14fc305 100644
--- a/arch/powerpc/configs/86xx/gef_ppc9a_defconfig
+++ b/arch/powerpc/configs/86xx/gef_ppc9a_defconfig
@@ -1,6 +1,5 @@
 CONFIG_SMP=y
 CONFIG_NR_CPUS=2
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_BSD_PROCESS_ACCT=y
diff --git a/arch/powerpc/configs/86xx/gef_sbc310_defconfig b/arch/powerpc/configs/86xx/gef_sbc310_defconfig
index 2149360..2b161d6 100644
--- a/arch/powerpc/configs/86xx/gef_sbc310_defconfig
+++ b/arch/powerpc/configs/86xx/gef_sbc310_defconfig
@@ -1,6 +1,5 @@
 CONFIG_SMP=y
 CONFIG_NR_CPUS=2
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_BSD_PROCESS_ACCT=y
diff --git a/arch/powerpc/configs/86xx/gef_sbc610_defconfig b/arch/powerpc/configs/86xx/gef_sbc610_defconfig
index af2e8e1..536bbc4 100644
--- a/arch/powerpc/configs/86xx/gef_sbc610_defconfig
+++ b/arch/powerpc/configs/86xx/gef_sbc610_defconfig
@@ -1,6 +1,5 @@
 CONFIG_SMP=y
 CONFIG_NR_CPUS=2
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_BSD_PROCESS_ACCT=y
diff --git a/arch/powerpc/configs/86xx/mpc8610_hpcd_defconfig b/arch/powerpc/configs/86xx/mpc8610_hpcd_defconfig
index c09598b..2c7f409 100644
--- a/arch/powerpc/configs/86xx/mpc8610_hpcd_defconfig
+++ b/arch/powerpc/configs/86xx/mpc8610_hpcd_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_SWAP is not set
 CONFIG_SYSVIPC=y
 CONFIG_IKCONFIG=y
diff --git a/arch/powerpc/configs/86xx/mpc8641_hpcn_defconfig b/arch/powerpc/configs/86xx/mpc8641_hpcn_defconfig
index f51c7eb..a6793cf 100644
--- a/arch/powerpc/configs/86xx/mpc8641_hpcn_defconfig
+++ b/arch/powerpc/configs/86xx/mpc8641_hpcn_defconfig
@@ -1,6 +1,5 @@
 CONFIG_SMP=y
 CONFIG_NR_CPUS=2
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_BSD_PROCESS_ACCT=y
diff --git a/arch/powerpc/configs/86xx/sbc8641d_defconfig b/arch/powerpc/configs/86xx/sbc8641d_defconfig
index 0a92ca0..8892035 100644
--- a/arch/powerpc/configs/86xx/sbc8641d_defconfig
+++ b/arch/powerpc/configs/86xx/sbc8641d_defconfig
@@ -1,6 +1,5 @@
 CONFIG_SMP=y
 CONFIG_NR_CPUS=2
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_BSD_PROCESS_ACCT=y
diff --git a/arch/powerpc/configs/adder875_defconfig b/arch/powerpc/configs/adder875_defconfig
index 6912874..d7e28db 100644
--- a/arch/powerpc/configs/adder875_defconfig
+++ b/arch/powerpc/configs/adder875_defconfig
@@ -1,5 +1,4 @@
 CONFIG_PPC_8xx=y
-CONFIG_EXPERIMENTAL=y
 # CONFIG_SWAP is not set
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
diff --git a/arch/powerpc/configs/amigaone_defconfig b/arch/powerpc/configs/amigaone_defconfig
index b6d49da..fa101f7 100644
--- a/arch/powerpc/configs/amigaone_defconfig
+++ b/arch/powerpc/configs/amigaone_defconfig
@@ -1,5 +1,4 @@
 CONFIG_ALTIVEC=y
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
diff --git a/arch/powerpc/configs/c2k_defconfig b/arch/powerpc/configs/c2k_defconfig
index 2a84fd7..252ab35 100644
--- a/arch/powerpc/configs/c2k_defconfig
+++ b/arch/powerpc/configs/c2k_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_BSD_PROCESS_ACCT=y
diff --git a/arch/powerpc/configs/cell_defconfig b/arch/powerpc/configs/cell_defconfig
index 22a403d..06e9f49 100644
--- a/arch/powerpc/configs/cell_defconfig
+++ b/arch/powerpc/configs/cell_defconfig
@@ -3,7 +3,6 @@ CONFIG_TUNE_CELL=y
 CONFIG_ALTIVEC=y
 CONFIG_SMP=y
 CONFIG_NR_CPUS=4
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
diff --git a/arch/powerpc/configs/celleb_defconfig b/arch/powerpc/configs/celleb_defconfig
index 895449e..a159679 100644
--- a/arch/powerpc/configs/celleb_defconfig
+++ b/arch/powerpc/configs/celleb_defconfig
@@ -3,7 +3,6 @@ CONFIG_TUNE_CELL=y
 CONFIG_ALTIVEC=y
 CONFIG_SMP=y
 CONFIG_NR_CPUS=4
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
diff --git a/arch/powerpc/configs/chroma_defconfig b/arch/powerpc/configs/chroma_defconfig
index 29bb11e..22ef386 100644
--- a/arch/powerpc/configs/chroma_defconfig
+++ b/arch/powerpc/configs/chroma_defconfig
@@ -3,7 +3,6 @@ CONFIG_PPC_BOOK3E_64=y
 # CONFIG_VIRT_CPU_ACCOUNTING is not set
 CONFIG_SMP=y
 CONFIG_NR_CPUS=256
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_BSD_PROCESS_ACCT=y
diff --git a/arch/powerpc/configs/chrp32_defconfig b/arch/powerpc/configs/chrp32_defconfig
index b20554e..a928ea8 100644
--- a/arch/powerpc/configs/chrp32_defconfig
+++ b/arch/powerpc/configs/chrp32_defconfig
@@ -1,5 +1,4 @@
 CONFIG_SMP=y
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
diff --git a/arch/powerpc/configs/corenet32_smp_defconfig b/arch/powerpc/configs/corenet32_smp_defconfig
index 8b3d57c..574f842 100644
--- a/arch/powerpc/configs/corenet32_smp_defconfig
+++ b/arch/powerpc/configs/corenet32_smp_defconfig
@@ -1,7 +1,6 @@
 CONFIG_PPC_85xx=y
 CONFIG_SMP=y
 CONFIG_NR_CPUS=8
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_BSD_PROCESS_ACCT=y
diff --git a/arch/powerpc/configs/corenet64_smp_defconfig b/arch/powerpc/configs/corenet64_smp_defconfig
index 0516e22..5e26529 100644
--- a/arch/powerpc/configs/corenet64_smp_defconfig
+++ b/arch/powerpc/configs/corenet64_smp_defconfig
@@ -3,7 +3,6 @@ CONFIG_PPC_BOOK3E_64=y
 # CONFIG_VIRT_CPU_ACCOUNTING is not set
 CONFIG_SMP=y
 CONFIG_NR_CPUS=2
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_IRQ_DOMAIN_DEBUG=y
diff --git a/arch/powerpc/configs/ep88xc_defconfig b/arch/powerpc/configs/ep88xc_defconfig
index 219fd47..5c41c41 100644
--- a/arch/powerpc/configs/ep88xc_defconfig
+++ b/arch/powerpc/configs/ep88xc_defconfig
@@ -1,5 +1,4 @@
 CONFIG_PPC_8xx=y
-CONFIG_EXPERIMENTAL=y
 # CONFIG_SWAP is not set
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
diff --git a/arch/powerpc/configs/g5_defconfig b/arch/powerpc/configs/g5_defconfig
index 07b7f2a..ca42077 100644
--- a/arch/powerpc/configs/g5_defconfig
+++ b/arch/powerpc/configs/g5_defconfig
@@ -2,7 +2,6 @@ CONFIG_PPC64=y
 CONFIG_ALTIVEC=y
 CONFIG_SMP=y
 CONFIG_NR_CPUS=4
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_IKCONFIG=y
diff --git a/arch/powerpc/configs/gamecube_defconfig b/arch/powerpc/configs/gamecube_defconfig
index 9ef2cc1..3ffdcfb 100644
--- a/arch/powerpc/configs/gamecube_defconfig
+++ b/arch/powerpc/configs/gamecube_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_LOCALVERSION="-gcn"
 CONFIG_SYSVIPC=y
 CONFIG_IKCONFIG=y
diff --git a/arch/powerpc/configs/holly_defconfig b/arch/powerpc/configs/holly_defconfig
index 94ebfee..b2ea578 100644
--- a/arch/powerpc/configs/holly_defconfig
+++ b/arch/powerpc/configs/holly_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
diff --git a/arch/powerpc/configs/linkstation_defconfig b/arch/powerpc/configs/linkstation_defconfig
index 8a874b9..062d0be 100644
--- a/arch/powerpc/configs/linkstation_defconfig
+++ b/arch/powerpc/configs/linkstation_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_IKCONFIG=y
diff --git a/arch/powerpc/configs/maple_defconfig b/arch/powerpc/configs/maple_defconfig
index 02ac96b..ac80ea8 100644
--- a/arch/powerpc/configs/maple_defconfig
+++ b/arch/powerpc/configs/maple_defconfig
@@ -1,7 +1,6 @@
 CONFIG_PPC64=y
 CONFIG_SMP=y
 CONFIG_NR_CPUS=4
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_IKCONFIG=y
diff --git a/arch/powerpc/configs/mgcoge_defconfig b/arch/powerpc/configs/mgcoge_defconfig
index 8fa84f1..df97725 100644
--- a/arch/powerpc/configs/mgcoge_defconfig
+++ b/arch/powerpc/configs/mgcoge_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_SWAP is not set
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
diff --git a/arch/powerpc/configs/mpc512x_defconfig b/arch/powerpc/configs/mpc512x_defconfig
index 211fcc9..55f3577 100644
--- a/arch/powerpc/configs/mpc512x_defconfig
+++ b/arch/powerpc/configs/mpc512x_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_SWAP is not set
 CONFIG_SYSVIPC=y
 CONFIG_SPARSE_IRQ=y
diff --git a/arch/powerpc/configs/mpc5200_defconfig b/arch/powerpc/configs/mpc5200_defconfig
index 6640a35..20edd86 100644
--- a/arch/powerpc/configs/mpc5200_defconfig
+++ b/arch/powerpc/configs/mpc5200_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_SPARSE_IRQ=y
 CONFIG_LOG_BUF_SHIFT=14
diff --git a/arch/powerpc/configs/mpc7448_hpc2_defconfig b/arch/powerpc/configs/mpc7448_hpc2_defconfig
index 75f0bbf..5f2b1db 100644
--- a/arch/powerpc/configs/mpc7448_hpc2_defconfig
+++ b/arch/powerpc/configs/mpc7448_hpc2_defconfig
@@ -1,5 +1,4 @@
 CONFIG_ALTIVEC=y
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
diff --git a/arch/powerpc/configs/mpc83xx_defconfig b/arch/powerpc/configs/mpc83xx_defconfig
index 9352e44..7ea8d90 100644
--- a/arch/powerpc/configs/mpc83xx_defconfig
+++ b/arch/powerpc/configs/mpc83xx_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
diff --git a/arch/powerpc/configs/mpc85xx_defconfig b/arch/powerpc/configs/mpc85xx_defconfig
index 8b5bda2..0f61a7c 100644
--- a/arch/powerpc/configs/mpc85xx_defconfig
+++ b/arch/powerpc/configs/mpc85xx_defconfig
@@ -1,6 +1,5 @@
 CONFIG_PPC_85xx=y
 CONFIG_PHYS_64BIT=y
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_BSD_PROCESS_ACCT=y
diff --git a/arch/powerpc/configs/mpc85xx_smp_defconfig b/arch/powerpc/configs/mpc85xx_smp_defconfig
index b0974e7..dd07a20 100644
--- a/arch/powerpc/configs/mpc85xx_smp_defconfig
+++ b/arch/powerpc/configs/mpc85xx_smp_defconfig
@@ -2,7 +2,6 @@ CONFIG_PPC_85xx=y
 CONFIG_PHYS_64BIT=y
 CONFIG_SMP=y
 CONFIG_NR_CPUS=8
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_BSD_PROCESS_ACCT=y
diff --git a/arch/powerpc/configs/mpc866_ads_defconfig b/arch/powerpc/configs/mpc866_ads_defconfig
index 5c25882..cc530e2 100644
--- a/arch/powerpc/configs/mpc866_ads_defconfig
+++ b/arch/powerpc/configs/mpc866_ads_defconfig
@@ -1,5 +1,4 @@
 CONFIG_PPC_8xx=y
-CONFIG_EXPERIMENTAL=y
 # CONFIG_SWAP is not set
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
diff --git a/arch/powerpc/configs/mpc86xx_defconfig b/arch/powerpc/configs/mpc86xx_defconfig
index a1cc817..aef2c5b 100644
--- a/arch/powerpc/configs/mpc86xx_defconfig
+++ b/arch/powerpc/configs/mpc86xx_defconfig
@@ -1,6 +1,5 @@
 CONFIG_SMP=y
 CONFIG_NR_CPUS=2
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_BSD_PROCESS_ACCT=y
diff --git a/arch/powerpc/configs/mpc885_ads_defconfig b/arch/powerpc/configs/mpc885_ads_defconfig
index 9e146cd..64d7c23 100644
--- a/arch/powerpc/configs/mpc885_ads_defconfig
+++ b/arch/powerpc/configs/mpc885_ads_defconfig
@@ -1,5 +1,4 @@
 CONFIG_PPC_8xx=y
-CONFIG_EXPERIMENTAL=y
 # CONFIG_SWAP is not set
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
diff --git a/arch/powerpc/configs/pasemi_defconfig b/arch/powerpc/configs/pasemi_defconfig
index 840a2c2..dadaeb5 100644
--- a/arch/powerpc/configs/pasemi_defconfig
+++ b/arch/powerpc/configs/pasemi_defconfig
@@ -3,7 +3,6 @@ CONFIG_ALTIVEC=y
 # CONFIG_VIRT_CPU_ACCOUNTING is not set
 CONFIG_SMP=y
 CONFIG_NR_CPUS=2
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
diff --git a/arch/powerpc/configs/pmac32_defconfig b/arch/powerpc/configs/pmac32_defconfig
index f8b394a..43ca170 100644
--- a/arch/powerpc/configs/pmac32_defconfig
+++ b/arch/powerpc/configs/pmac32_defconfig
@@ -1,5 +1,4 @@
 CONFIG_ALTIVEC=y
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
diff --git a/arch/powerpc/configs/ppc40x_defconfig b/arch/powerpc/configs/ppc40x_defconfig
index 1eb19ac..1e4e685 100644
--- a/arch/powerpc/configs/ppc40x_defconfig
+++ b/arch/powerpc/configs/ppc40x_defconfig
@@ -1,5 +1,4 @@
 CONFIG_40x=y
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
diff --git a/arch/powerpc/configs/ppc44x_defconfig b/arch/powerpc/configs/ppc44x_defconfig
index 3b98d73..741580f 100644
--- a/arch/powerpc/configs/ppc44x_defconfig
+++ b/arch/powerpc/configs/ppc44x_defconfig
@@ -1,5 +1,4 @@
 CONFIG_44x=y
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
diff --git a/arch/powerpc/configs/ppc64_defconfig b/arch/powerpc/configs/ppc64_defconfig
index db27c82..31ac077 100644
--- a/arch/powerpc/configs/ppc64_defconfig
+++ b/arch/powerpc/configs/ppc64_defconfig
@@ -2,7 +2,6 @@ CONFIG_PPC64=y
 CONFIG_ALTIVEC=y
 CONFIG_VSX=y
 CONFIG_SMP=y
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_TASKSTATS=y
diff --git a/arch/powerpc/configs/ppc64e_defconfig b/arch/powerpc/configs/ppc64e_defconfig
index 7bd1763..8f7ab88 100644
--- a/arch/powerpc/configs/ppc64e_defconfig
+++ b/arch/powerpc/configs/ppc64e_defconfig
@@ -1,7 +1,6 @@
 CONFIG_PPC64=y
 CONFIG_PPC_BOOK3E_64=y
 CONFIG_SMP=y
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_TASKSTATS=y
diff --git a/arch/powerpc/configs/ppc6xx_defconfig b/arch/powerpc/configs/ppc6xx_defconfig
index c47f2be..55db616 100644
--- a/arch/powerpc/configs/ppc6xx_defconfig
+++ b/arch/powerpc/configs/ppc6xx_defconfig
@@ -1,5 +1,4 @@
 CONFIG_FSL_EMB_PERFMON=y
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
diff --git a/arch/powerpc/configs/prpmc2800_defconfig b/arch/powerpc/configs/prpmc2800_defconfig
index cd80fb6..dd0a8c7 100644
--- a/arch/powerpc/configs/prpmc2800_defconfig
+++ b/arch/powerpc/configs/prpmc2800_defconfig
@@ -1,5 +1,4 @@
 CONFIG_ALTIVEC=y
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
diff --git a/arch/powerpc/configs/ps3_defconfig b/arch/powerpc/configs/ps3_defconfig
index c2f4b4a..aba7011 100644
--- a/arch/powerpc/configs/ps3_defconfig
+++ b/arch/powerpc/configs/ps3_defconfig
@@ -3,7 +3,6 @@ CONFIG_TUNE_CELL=y
 CONFIG_ALTIVEC=y
 CONFIG_SMP=y
 CONFIG_NR_CPUS=2
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_BLK_DEV_INITRD=y
diff --git a/arch/powerpc/configs/pseries_defconfig b/arch/powerpc/configs/pseries_defconfig
index 1f65b3c..7b8c5c7 100644
--- a/arch/powerpc/configs/pseries_defconfig
+++ b/arch/powerpc/configs/pseries_defconfig
@@ -3,7 +3,6 @@ CONFIG_ALTIVEC=y
 CONFIG_VSX=y
 CONFIG_SMP=y
 CONFIG_NR_CPUS=1024
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_TASKSTATS=y
diff --git a/arch/powerpc/configs/storcenter_defconfig b/arch/powerpc/configs/storcenter_defconfig
index ebb2a66..62ea2fc 100644
--- a/arch/powerpc/configs/storcenter_defconfig
+++ b/arch/powerpc/configs/storcenter_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_EXPERT=y
diff --git a/arch/powerpc/configs/tqm8xx_defconfig b/arch/powerpc/configs/tqm8xx_defconfig
index 8616fde..827d7f6 100644
--- a/arch/powerpc/configs/tqm8xx_defconfig
+++ b/arch/powerpc/configs/tqm8xx_defconfig
@@ -1,5 +1,4 @@
 CONFIG_PPC_8xx=y
-CONFIG_EXPERIMENTAL=y
 # CONFIG_SWAP is not set
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
diff --git a/arch/powerpc/configs/wii_defconfig b/arch/powerpc/configs/wii_defconfig
index 1e2b7d0..2bf512b 100644
--- a/arch/powerpc/configs/wii_defconfig
+++ b/arch/powerpc/configs/wii_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_LOCALVERSION="-wii"
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
diff --git a/arch/powerpc/kvm/Kconfig b/arch/powerpc/kvm/Kconfig
index f4dacb9..2bac5b1 100644
--- a/arch/powerpc/kvm/Kconfig
+++ b/arch/powerpc/kvm/Kconfig
@@ -39,7 +39,7 @@ config KVM_BOOK3S_PR
 
 config KVM_BOOK3S_32
 	tristate "KVM support for PowerPC book3s_32 processors"
-	depends on EXPERIMENTAL && PPC_BOOK3S_32 && !SMP && !PTE_64BIT
+	depends on PPC_BOOK3S_32 && !SMP && !PTE_64BIT
 	select KVM
 	select KVM_BOOK3S_32_HANDLER
 	select KVM_BOOK3S_PR
@@ -54,7 +54,7 @@ config KVM_BOOK3S_32
 
 config KVM_BOOK3S_64
 	tristate "KVM support for PowerPC book3s_64 processors"
-	depends on EXPERIMENTAL && PPC_BOOK3S_64
+	depends on PPC_BOOK3S_64
 	select KVM_BOOK3S_64_HANDLER
 	select KVM
 	---help---
@@ -95,7 +95,7 @@ config KVM_BOOKE_HV
 
 config KVM_440
 	bool "KVM support for PowerPC 440 processors"
-	depends on EXPERIMENTAL && 44x
+	depends on 44x
 	select KVM
 	select KVM_MMIO
 	---help---
@@ -120,7 +120,7 @@ config KVM_EXIT_TIMING
 
 config KVM_E500V2
 	bool "KVM support for PowerPC E500v2 processors"
-	depends on EXPERIMENTAL && E500 && !PPC_E500MC
+	depends on E500 && !PPC_E500MC
 	select KVM
 	select KVM_MMIO
 	---help---
@@ -134,7 +134,7 @@ config KVM_E500V2
 
 config KVM_E500MC
 	bool "KVM support for PowerPC E500MC/E5500 processors"
-	depends on EXPERIMENTAL && PPC_E500MC
+	depends on PPC_E500MC
 	select KVM
 	select KVM_MMIO
 	select KVM_BOOKE_HV
diff --git a/arch/powerpc/platforms/85xx/Kconfig b/arch/powerpc/platforms/85xx/Kconfig
index 159c01e..b6b3ee7 100644
--- a/arch/powerpc/platforms/85xx/Kconfig
+++ b/arch/powerpc/platforms/85xx/Kconfig
@@ -256,7 +256,6 @@ config P5020_DS
 
 config PPC_QEMU_E500
 	bool "QEMU generic e500 platform"
-	depends on EXPERIMENTAL
 	select DEFAULT_UIMAGE
 	help
 	  This option enables support for running as a QEMU guest using
diff --git a/arch/powerpc/platforms/cell/Kconfig b/arch/powerpc/platforms/cell/Kconfig
index 2e7ff0c..53aaefe 100644
--- a/arch/powerpc/platforms/cell/Kconfig
+++ b/arch/powerpc/platforms/cell/Kconfig
@@ -124,7 +124,7 @@ config CBE_CPUFREQ
 
 config CBE_CPUFREQ_PMI_ENABLE
 	bool "CBE frequency scaling using PMI interface"
-	depends on CBE_CPUFREQ && EXPERIMENTAL
+	depends on CBE_CPUFREQ
 	default n
 	help
 	  Select this, if you want to use the PMI interface
diff --git a/arch/powerpc/platforms/ps3/Kconfig b/arch/powerpc/platforms/ps3/Kconfig
index 46b7f02..e87c194 100644
--- a/arch/powerpc/platforms/ps3/Kconfig
+++ b/arch/powerpc/platforms/ps3/Kconfig
@@ -48,7 +48,7 @@ config PS3_HTAB_SIZE
 	  system will have optimal runtime performance.
 
 config PS3_DYNAMIC_DMA
-	depends on PPC_PS3 && EXPERIMENTAL
+	depends on PPC_PS3
 	bool "PS3 Platform dynamic DMA page table management"
 	default n
 	help
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 107610e..ffa10a7 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -583,8 +583,8 @@ config ZFCPDUMP
 
 config S390_GUEST
 	def_bool y
-	prompt "s390 guest support for KVM (EXPERIMENTAL)"
-	depends on 64BIT && EXPERIMENTAL
+	prompt "s390 guest support for KVM"
+	depends on 64BIT
 	select VIRTUALIZATION
 	select VIRTIO
 	select VIRTIO_RING
diff --git a/arch/s390/defconfig b/arch/s390/defconfig
index f39cd71..afbe4b6 100644
--- a/arch/s390/defconfig
+++ b/arch/s390/defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_FHANDLE=y
diff --git a/arch/s390/kvm/Kconfig b/arch/s390/kvm/Kconfig
index 78eb984..7695d72 100644
--- a/arch/s390/kvm/Kconfig
+++ b/arch/s390/kvm/Kconfig
@@ -18,7 +18,7 @@ if VIRTUALIZATION
 config KVM
 	def_tristate y
 	prompt "Kernel-based Virtual Machine (KVM) support"
-	depends on HAVE_KVM && EXPERIMENTAL
+	depends on HAVE_KVM
 	select PREEMPT_NOTIFIERS
 	select ANON_INODES
 	---help---
diff --git a/arch/score/configs/spct6600_defconfig b/arch/score/configs/spct6600_defconfig
index df1edbf..ae2e722 100644
--- a/arch/score/configs/spct6600_defconfig
+++ b/arch/score/configs/spct6600_defconfig
@@ -1,6 +1,5 @@
 CONFIG_HZ_100=y
 CONFIG_PREEMPT_VOLUNTARY=y
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index 36f5141..8ad4235 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -642,8 +642,8 @@ menu "Kernel features"
 source kernel/Kconfig.hz
 
 config KEXEC
-	bool "kexec system call (EXPERIMENTAL)"
-	depends on SUPERH32 && EXPERIMENTAL && MMU
+	bool "kexec system call"
+	depends on SUPERH32 && MMU
 	help
 	  kexec is a system call that implements the ability to shutdown your
 	  current kernel, and to start another kernel.  It is like a reboot
@@ -659,8 +659,8 @@ config KEXEC
 	  strongly in flux, so no good recommendation can be made.
 
 config CRASH_DUMP
-	bool "kernel crash dumps (EXPERIMENTAL)"
-	depends on SUPERH32 && EXPERIMENTAL && BROKEN_ON_SMP
+	bool "kernel crash dumps"
+	depends on SUPERH32 && BROKEN_ON_SMP
 	help
 	  Generate crash dump after being started by kexec.
 	  This should be normally only set in special crash dump kernels
@@ -673,8 +673,8 @@ config CRASH_DUMP
 	  For more details see Documentation/kdump/kdump.txt
 
 config KEXEC_JUMP
-	bool "kexec jump (EXPERIMENTAL)"
-	depends on SUPERH32 && KEXEC && HIBERNATION && EXPERIMENTAL
+	bool "kexec jump"
+	depends on SUPERH32 && KEXEC && HIBERNATION
 	help
 	  Jump between original kernel and kexeced kernel and invoke
 	  code via KEXEC
@@ -707,8 +707,8 @@ config SECCOMP
 	  If unsure, say N.
 
 config CC_STACKPROTECTOR
-	bool "Enable -fstack-protector buffer overflow detection (EXPERIMENTAL)"
-	depends on SUPERH32 && EXPERIMENTAL
+	bool "Enable -fstack-protector buffer overflow detection"
+	depends on SUPERH32
 	help
 	  This option turns on the -fstack-protector GCC feature. This
 	  feature puts, at the beginning of functions, a canary value on
@@ -758,8 +758,8 @@ config NR_CPUS
 	  approximately eight kilobytes to the kernel image.
 
 config HOTPLUG_CPU
-	bool "Support for hot-pluggable CPUs (EXPERIMENTAL)"
-	depends on SMP && HOTPLUG && EXPERIMENTAL
+	bool "Support for hot-pluggable CPUs"
+	depends on SMP && HOTPLUG
 	help
 	  Say Y here to experiment with turning CPUs off and on.  CPUs
 	  can be controlled through /sys/devices/system/cpu.
@@ -781,7 +781,7 @@ config GUSA
 	  atomicity implementations exist.
 
 config GUSA_RB
-	bool "Implement atomic operations by roll-back (gRB) (EXPERIMENTAL)"
+	bool "Implement atomic operations by roll-back (gRB)"
 	depends on GUSA && CPU_SH3 || (CPU_SH4 && !CPU_SH4A)
 	help
 	  Enabling this option will allow the kernel to implement some
@@ -837,8 +837,8 @@ config ENTRY_OFFSET
 	default "0x00000000"
 
 config ROMIMAGE_MMCIF
-	bool "Include MMCIF loader in romImage (EXPERIMENTAL)"
-	depends on CPU_SUBTYPE_SH7724 && EXPERIMENTAL
+	bool "Include MMCIF loader in romImage"
+	depends on CPU_SUBTYPE_SH7724
 	help
 	  Say Y here to include experimental MMCIF loading code in
 	  romImage. With this enabled it is possible to write the romImage
@@ -923,8 +923,7 @@ source "fs/Kconfig.binfmt"
 
 endmenu
 
-menu "Power management options (EXPERIMENTAL)"
-depends on EXPERIMENTAL
+menu "Power management options"
 
 source "kernel/power/Kconfig"
 
diff --git a/arch/sh/Kconfig.cpu b/arch/sh/Kconfig.cpu
index 770ff2d..05b518e 100644
--- a/arch/sh/Kconfig.cpu
+++ b/arch/sh/Kconfig.cpu
@@ -33,7 +33,7 @@ config SH64_FPU_DENORM_FLUSH
 config SH_FPU_EMU
 	def_bool n
 	prompt "FPU emulation support"
-	depends on !SH_FPU && EXPERIMENTAL
+	depends on !SH_FPU
 	help
 	  Selecting this option will enable support for software FPU emulation.
 	  Most SH-3 users will want to say Y here, whereas most SH-4 users will
@@ -68,7 +68,6 @@ config SH_STORE_QUEUES
 
 config SPECULATIVE_EXECUTION
 	bool "Speculative subroutine return"
-	depends on EXPERIMENTAL
 	depends on CPU_SUBTYPE_SH7780 || CPU_SUBTYPE_SH7785 || CPU_SUBTYPE_SH7786
 	help
 	  This enables support for a speculative instruction fetch for
diff --git a/arch/sh/configs/ap325rxa_defconfig b/arch/sh/configs/ap325rxa_defconfig
index e533512..bb6c85d 100644
--- a/arch/sh/configs/ap325rxa_defconfig
+++ b/arch/sh/configs/ap325rxa_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
diff --git a/arch/sh/configs/apsh4a3a_defconfig b/arch/sh/configs/apsh4a3a_defconfig
index 6cb3279..5c91636 100644
--- a/arch/sh/configs/apsh4a3a_defconfig
+++ b/arch/sh/configs/apsh4a3a_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_IKCONFIG=y
diff --git a/arch/sh/configs/apsh4ad0a_defconfig b/arch/sh/configs/apsh4ad0a_defconfig
index 95ae23f..115bdee 100644
--- a/arch/sh/configs/apsh4ad0a_defconfig
+++ b/arch/sh/configs/apsh4ad0a_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_BSD_PROCESS_ACCT=y
diff --git a/arch/sh/configs/cayman_defconfig b/arch/sh/configs/cayman_defconfig
index 67e1506..2215cd0 100644
--- a/arch/sh/configs/cayman_defconfig
+++ b/arch/sh/configs/cayman_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
diff --git a/arch/sh/configs/dreamcast_defconfig b/arch/sh/configs/dreamcast_defconfig
index ec243ca..4e3dd5a 100644
--- a/arch/sh/configs/dreamcast_defconfig
+++ b/arch/sh/configs/dreamcast_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_LOG_BUF_SHIFT=14
diff --git a/arch/sh/configs/ecovec24-romimage_defconfig b/arch/sh/configs/ecovec24-romimage_defconfig
index 5fcb17b..f112b69 100644
--- a/arch/sh/configs/ecovec24-romimage_defconfig
+++ b/arch/sh/configs/ecovec24-romimage_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
diff --git a/arch/sh/configs/ecovec24_defconfig b/arch/sh/configs/ecovec24_defconfig
index 911e30c..3383c26 100644
--- a/arch/sh/configs/ecovec24_defconfig
+++ b/arch/sh/configs/ecovec24_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
diff --git a/arch/sh/configs/edosk7760_defconfig b/arch/sh/configs/edosk7760_defconfig
index e1077a0..5732b71 100644
--- a/arch/sh/configs/edosk7760_defconfig
+++ b/arch/sh/configs/edosk7760_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_LOCALVERSION="_edosk7760"
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
diff --git a/arch/sh/configs/espt_defconfig b/arch/sh/configs/espt_defconfig
index 67cb109..7b3ad19 100644
--- a/arch/sh/configs/espt_defconfig
+++ b/arch/sh/configs/espt_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
diff --git a/arch/sh/configs/hp6xx_defconfig b/arch/sh/configs/hp6xx_defconfig
index 496edcd..7d56847 100644
--- a/arch/sh/configs/hp6xx_defconfig
+++ b/arch/sh/configs/hp6xx_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
diff --git a/arch/sh/configs/kfr2r09-romimage_defconfig b/arch/sh/configs/kfr2r09-romimage_defconfig
index 029a506..3467532 100644
--- a/arch/sh/configs/kfr2r09-romimage_defconfig
+++ b/arch/sh/configs/kfr2r09-romimage_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
diff --git a/arch/sh/configs/kfr2r09_defconfig b/arch/sh/configs/kfr2r09_defconfig
index fac13de..bfdf405 100644
--- a/arch/sh/configs/kfr2r09_defconfig
+++ b/arch/sh/configs/kfr2r09_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
diff --git a/arch/sh/configs/landisk_defconfig b/arch/sh/configs/landisk_defconfig
index 3670e93..a8c917f 100644
--- a/arch/sh/configs/landisk_defconfig
+++ b/arch/sh/configs/landisk_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_SYSCTL_SYSCALL is not set
diff --git a/arch/sh/configs/lboxre2_defconfig b/arch/sh/configs/lboxre2_defconfig
index e3c0894..264bf2d 100644
--- a/arch/sh/configs/lboxre2_defconfig
+++ b/arch/sh/configs/lboxre2_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_SYSCTL_SYSCALL is not set
diff --git a/arch/sh/configs/magicpanelr2_defconfig b/arch/sh/configs/magicpanelr2_defconfig
index 9479872..9e9781b 100644
--- a/arch/sh/configs/magicpanelr2_defconfig
+++ b/arch/sh/configs/magicpanelr2_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
diff --git a/arch/sh/configs/microdev_defconfig b/arch/sh/configs/microdev_defconfig
index f1d2e1b..7a47ffd 100644
--- a/arch/sh/configs/microdev_defconfig
+++ b/arch/sh/configs/microdev_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
diff --git a/arch/sh/configs/migor_defconfig b/arch/sh/configs/migor_defconfig
index cc61eda..0a430da 100644
--- a/arch/sh/configs/migor_defconfig
+++ b/arch/sh/configs/migor_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
diff --git a/arch/sh/configs/polaris_defconfig b/arch/sh/configs/polaris_defconfig
index f3d5d9f..5033c3d 100644
--- a/arch/sh/configs/polaris_defconfig
+++ b/arch/sh/configs/polaris_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 # CONFIG_SWAP is not set
 CONFIG_SYSVIPC=y
diff --git a/arch/sh/configs/r7780mp_defconfig b/arch/sh/configs/r7780mp_defconfig
index 920b847..2737267 100644
--- a/arch/sh/configs/r7780mp_defconfig
+++ b/arch/sh/configs/r7780mp_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_IKCONFIG=y
diff --git a/arch/sh/configs/r7785rp_defconfig b/arch/sh/configs/r7785rp_defconfig
index c77da6b..3cac63d 100644
--- a/arch/sh/configs/r7785rp_defconfig
+++ b/arch/sh/configs/r7785rp_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_BSD_PROCESS_ACCT=y
diff --git a/arch/sh/configs/rsk7201_defconfig b/arch/sh/configs/rsk7201_defconfig
index 5df916d..ec58e57 100644
--- a/arch/sh/configs/rsk7201_defconfig
+++ b/arch/sh/configs/rsk7201_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
diff --git a/arch/sh/configs/rsk7203_defconfig b/arch/sh/configs/rsk7203_defconfig
index 4e5229b..3052993 100644
--- a/arch/sh/configs/rsk7203_defconfig
+++ b/arch/sh/configs/rsk7203_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
diff --git a/arch/sh/configs/rts7751r2d1_defconfig b/arch/sh/configs/rts7751r2d1_defconfig
index a3d0810..7651dbb 100644
--- a/arch/sh/configs/rts7751r2d1_defconfig
+++ b/arch/sh/configs/rts7751r2d1_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
diff --git a/arch/sh/configs/rts7751r2dplus_defconfig b/arch/sh/configs/rts7751r2dplus_defconfig
index b1a04f3..f3dfdd3 100644
--- a/arch/sh/configs/rts7751r2dplus_defconfig
+++ b/arch/sh/configs/rts7751r2dplus_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
diff --git a/arch/sh/configs/sdk7780_defconfig b/arch/sh/configs/sdk7780_defconfig
index ae11158..2f6ad01 100644
--- a/arch/sh/configs/sdk7780_defconfig
+++ b/arch/sh/configs/sdk7780_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_LOCALVERSION="_SDK7780"
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
diff --git a/arch/sh/configs/sdk7786_defconfig b/arch/sh/configs/sdk7786_defconfig
index 76a76a2..adc8a9a 100644
--- a/arch/sh/configs/sdk7786_defconfig
+++ b/arch/sh/configs/sdk7786_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_KERNEL_LZO=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
diff --git a/arch/sh/configs/se7206_defconfig b/arch/sh/configs/se7206_defconfig
index 6bc30ab..973eb33 100644
--- a/arch/sh/configs/se7206_defconfig
+++ b/arch/sh/configs/se7206_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_BSD_PROCESS_ACCT=y
diff --git a/arch/sh/configs/se7343_defconfig b/arch/sh/configs/se7343_defconfig
index be9c474..a546ca9 100644
--- a/arch/sh/configs/se7343_defconfig
+++ b/arch/sh/configs/se7343_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_SWAP is not set
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
diff --git a/arch/sh/configs/se7619_defconfig b/arch/sh/configs/se7619_defconfig
index 9a9ad9a..dda769c 100644
--- a/arch/sh/configs/se7619_defconfig
+++ b/arch/sh/configs/se7619_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_UID16 is not set
diff --git a/arch/sh/configs/se7705_defconfig b/arch/sh/configs/se7705_defconfig
index 044e084..e0f0ddf 100644
--- a/arch/sh/configs/se7705_defconfig
+++ b/arch/sh/configs/se7705_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_SWAP is not set
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
diff --git a/arch/sh/configs/se7712_defconfig b/arch/sh/configs/se7712_defconfig
index 1248635..5e8d26e 100644
--- a/arch/sh/configs/se7712_defconfig
+++ b/arch/sh/configs/se7712_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 # CONFIG_SWAP is not set
 CONFIG_SYSVIPC=y
diff --git a/arch/sh/configs/se7721_defconfig b/arch/sh/configs/se7721_defconfig
index c3ba6e8..2cff128 100644
--- a/arch/sh/configs/se7721_defconfig
+++ b/arch/sh/configs/se7721_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 # CONFIG_SWAP is not set
 CONFIG_SYSVIPC=y
diff --git a/arch/sh/configs/se7722_defconfig b/arch/sh/configs/se7722_defconfig
index ae998c7..8d29baf 100644
--- a/arch/sh/configs/se7722_defconfig
+++ b/arch/sh/configs/se7722_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_IKCONFIG=y
diff --git a/arch/sh/configs/se7724_defconfig b/arch/sh/configs/se7724_defconfig
index ed35093..d10fd36 100644
--- a/arch/sh/configs/se7724_defconfig
+++ b/arch/sh/configs/se7724_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
diff --git a/arch/sh/configs/se7750_defconfig b/arch/sh/configs/se7750_defconfig
index 912c985..0754c53 100644
--- a/arch/sh/configs/se7750_defconfig
+++ b/arch/sh/configs/se7750_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_SWAP is not set
 CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
diff --git a/arch/sh/configs/se7751_defconfig b/arch/sh/configs/se7751_defconfig
index 75c92fc..5744061 100644
--- a/arch/sh/configs/se7751_defconfig
+++ b/arch/sh/configs/se7751_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_LOG_BUF_SHIFT=14
diff --git a/arch/sh/configs/secureedge5410_defconfig b/arch/sh/configs/secureedge5410_defconfig
index 7eae4e5..b4a59bd 100644
--- a/arch/sh/configs/secureedge5410_defconfig
+++ b/arch/sh/configs/secureedge5410_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_SWAP is not set
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
diff --git a/arch/sh/configs/sh03_defconfig b/arch/sh/configs/sh03_defconfig
index 2051821..6ba1845 100644
--- a/arch/sh/configs/sh03_defconfig
+++ b/arch/sh/configs/sh03_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_BSD_PROCESS_ACCT=y
diff --git a/arch/sh/configs/sh2007_defconfig b/arch/sh/configs/sh2007_defconfig
index 0d2f414..42c6b3e 100644
--- a/arch/sh/configs/sh2007_defconfig
+++ b/arch/sh/configs/sh2007_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
diff --git a/arch/sh/configs/sh7710voipgw_defconfig b/arch/sh/configs/sh7710voipgw_defconfig
index f92ad17..b041e8e 100644
--- a/arch/sh/configs/sh7710voipgw_defconfig
+++ b/arch/sh/configs/sh7710voipgw_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_SWAP is not set
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
diff --git a/arch/sh/configs/sh7724_generic_defconfig b/arch/sh/configs/sh7724_generic_defconfig
index f83ac7b..2fcc71c 100644
--- a/arch/sh/configs/sh7724_generic_defconfig
+++ b/arch/sh/configs/sh7724_generic_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_CGROUPS=y
diff --git a/arch/sh/configs/sh7757lcr_defconfig b/arch/sh/configs/sh7757lcr_defconfig
index cfde98d..e6c310d 100644
--- a/arch/sh/configs/sh7757lcr_defconfig
+++ b/arch/sh/configs/sh7757lcr_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_SWAP is not set
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
diff --git a/arch/sh/configs/sh7763rdp_defconfig b/arch/sh/configs/sh7763rdp_defconfig
index 4795364..6957dfc 100644
--- a/arch/sh/configs/sh7763rdp_defconfig
+++ b/arch/sh/configs/sh7763rdp_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
diff --git a/arch/sh/configs/sh7770_generic_defconfig b/arch/sh/configs/sh7770_generic_defconfig
index 025bd3a..f48d1de 100644
--- a/arch/sh/configs/sh7770_generic_defconfig
+++ b/arch/sh/configs/sh7770_generic_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_CGROUPS=y
diff --git a/arch/sh/configs/sh7785lcr_32bit_defconfig b/arch/sh/configs/sh7785lcr_32bit_defconfig
index 9bdcf72..37f10e4 100644
--- a/arch/sh/configs/sh7785lcr_32bit_defconfig
+++ b/arch/sh/configs/sh7785lcr_32bit_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_BSD_PROCESS_ACCT=y
diff --git a/arch/sh/configs/sh7785lcr_defconfig b/arch/sh/configs/sh7785lcr_defconfig
index 51561f5..a5ebe2b 100644
--- a/arch/sh/configs/sh7785lcr_defconfig
+++ b/arch/sh/configs/sh7785lcr_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_IKCONFIG=y
diff --git a/arch/sh/configs/shmin_defconfig b/arch/sh/configs/shmin_defconfig
index 4802e14..9074dee 100644
--- a/arch/sh/configs/shmin_defconfig
+++ b/arch/sh/configs/shmin_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_SWAP is not set
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_UID16 is not set
diff --git a/arch/sh/configs/shx3_defconfig b/arch/sh/configs/shx3_defconfig
index cd6c519..bdc0a03 100644
--- a/arch/sh/configs/shx3_defconfig
+++ b/arch/sh/configs/shx3_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_BSD_PROCESS_ACCT=y
diff --git a/arch/sh/configs/titan_defconfig b/arch/sh/configs/titan_defconfig
index e2cbd92..64f5e20 100644
--- a/arch/sh/configs/titan_defconfig
+++ b/arch/sh/configs/titan_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
diff --git a/arch/sh/configs/ul2_defconfig b/arch/sh/configs/ul2_defconfig
index 2d288b8..fd20dad 100644
--- a/arch/sh/configs/ul2_defconfig
+++ b/arch/sh/configs/ul2_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_IKCONFIG=y
diff --git a/arch/sh/configs/urquell_defconfig b/arch/sh/configs/urquell_defconfig
index d7f89be..ef090f3 100644
--- a/arch/sh/configs/urquell_defconfig
+++ b/arch/sh/configs/urquell_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_BSD_PROCESS_ACCT=y
diff --git a/arch/sh/mm/Kconfig b/arch/sh/mm/Kconfig
index cb8f992..533ccbb 100644
--- a/arch/sh/mm/Kconfig
+++ b/arch/sh/mm/Kconfig
@@ -83,7 +83,7 @@ config 32BIT
 
 config PMB
 	bool "Support 32-bit physical addressing through PMB"
-	depends on MMU && EXPERIMENTAL && CPU_SH4A && !CPU_SH4AL_DSP
+	depends on MMU && CPU_SH4A && !CPU_SH4AL_DSP
 	select 32BIT
 	select UNCACHED_MAPPING
 	help
@@ -110,7 +110,7 @@ config VSYSCALL
 
 config NUMA
 	bool "Non Uniform Memory Access (NUMA) Support"
-	depends on MMU && SYS_SUPPORTS_NUMA && EXPERIMENTAL
+	depends on MMU && SYS_SUPPORTS_NUMA
 	default n
 	help
 	  Some SH systems have many various memories scattered around
diff --git a/arch/sparc/configs/sparc32_defconfig b/arch/sparc/configs/sparc32_defconfig
index fb23fd6..2821ffb 100644
--- a/arch/sparc/configs/sparc32_defconfig
+++ b/arch/sparc/configs/sparc32_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
diff --git a/arch/sparc/configs/sparc64_defconfig b/arch/sparc/configs/sparc64_defconfig
index 9d8521b..7abce47 100644
--- a/arch/sparc/configs/sparc64_defconfig
+++ b/arch/sparc/configs/sparc64_defconfig
@@ -1,5 +1,4 @@
 CONFIG_64BIT=y
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
diff --git a/arch/tile/configs/tilegx_defconfig b/arch/tile/configs/tilegx_defconfig
index 0270620..e459ef3 100644
--- a/arch/tile/configs/tilegx_defconfig
+++ b/arch/tile/configs/tilegx_defconfig
@@ -1,5 +1,4 @@
 CONFIG_TILEGX=y
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
diff --git a/arch/tile/configs/tilepro_defconfig b/arch/tile/configs/tilepro_defconfig
index c11de27..a7c4d69 100644
--- a/arch/tile/configs/tilepro_defconfig
+++ b/arch/tile/configs/tilepro_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
diff --git a/arch/tile/kvm/Kconfig b/arch/tile/kvm/Kconfig
index 669fcdb..2298cb1 100644
--- a/arch/tile/kvm/Kconfig
+++ b/arch/tile/kvm/Kconfig
@@ -18,7 +18,7 @@ if VIRTUALIZATION
 
 config KVM
 	tristate "Kernel-based Virtual Machine (KVM) support"
-	depends on HAVE_KVM && MODULES && EXPERIMENTAL
+	depends on HAVE_KVM && MODULES
 	select PREEMPT_NOTIFIERS
 	select ANON_INODES
 	---help---
diff --git a/arch/um/Kconfig.net b/arch/um/Kconfig.net
index 3160b1a..820a56f 100644
--- a/arch/um/Kconfig.net
+++ b/arch/um/Kconfig.net
@@ -157,7 +157,7 @@ config UML_NET_MCAST
 
 config UML_NET_PCAP
 	bool "pcap transport"
-	depends on UML_NET && EXPERIMENTAL
+	depends on UML_NET
 	help
 	The pcap transport makes a pcap packet stream on the host look
 	like an ethernet device inside UML.  This is useful for making
diff --git a/arch/um/Kconfig.um b/arch/um/Kconfig.um
index bf87f25..a7520c9 100644
--- a/arch/um/Kconfig.um
+++ b/arch/um/Kconfig.um
@@ -45,8 +45,8 @@ config HOSTFS
           say Y or M here; otherwise say N.
 
 config HPPFS
-	tristate "HoneyPot ProcFS (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && PROC_FS
+	tristate "HoneyPot ProcFS"
+	depends on PROC_FS
 	help
 	  hppfs (HoneyPot ProcFS) is a filesystem which allows UML /proc
 	  entries to be overridden, removed, or fabricated from the host.
@@ -96,7 +96,7 @@ config MAGIC_SYSRQ
 	  unless you really know what this hack does.
 
 config SMP
-	bool "Symmetric multi-processing support (EXPERIMENTAL)"
+	bool "Symmetric multi-processing support"
 	default n
 	depends on BROKEN
 	help
@@ -126,7 +126,7 @@ config NR_CPUS
 	default "32"
 
 config HIGHMEM
-	bool "Highmem support (EXPERIMENTAL)"
+	bool "Highmem support"
 	depends on !64BIT && BROKEN
 	default n
 	help
diff --git a/arch/um/defconfig b/arch/um/defconfig
index 08107a7..b20904d 100644
--- a/arch/um/defconfig
+++ b/arch/um/defconfig
@@ -112,7 +112,6 @@ CONFIG_NO_DMA=y
 #
 # General setup
 #
-CONFIG_EXPERIMENTAL=y
 CONFIG_BROKEN_ON_SMP=y
 CONFIG_INIT_ENV_ARG_LIMIT=128
 CONFIG_CROSS_COMPILE=""
diff --git a/arch/unicore32/Kconfig b/arch/unicore32/Kconfig
index b0a4743..f86b0b0 100644
--- a/arch/unicore32/Kconfig
+++ b/arch/unicore32/Kconfig
@@ -216,7 +216,7 @@ config PUV3_GPIO
 	bool
 	depends on !ARCH_FPGA
 	select GENERIC_GPIO
-	select GPIO_SYSFS if EXPERIMENTAL
+	select GPIO_SYSFS
 	default y
 
 config PUV3_PWM
diff --git a/arch/unicore32/configs/unicore32_defconfig b/arch/unicore32/configs/unicore32_defconfig
index c9dd319..1d2296d 100644
--- a/arch/unicore32/configs/unicore32_defconfig
+++ b/arch/unicore32/configs/unicore32_defconfig
@@ -1,5 +1,4 @@
 ### General setup
-CONFIG_EXPERIMENTAL=y
 CONFIG_LOCALVERSION="-unicore32"
 CONFIG_SWAP=y
 CONFIG_SYSVIPC=y
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 8ec3a1a..f42b198 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -204,7 +204,7 @@ config ARCH_SUPPORTS_DEBUG_PAGEALLOC
 
 config HAVE_INTEL_TXT
 	def_bool y
-	depends on EXPERIMENTAL && INTEL_IOMMU && ACPI
+	depends on INTEL_IOMMU && ACPI
 
 config X86_32_SMP
 	def_bool y
@@ -603,7 +603,7 @@ config PARAVIRT
 
 config PARAVIRT_SPINLOCKS
 	bool "Paravirtualization layer for spinlocks"
-	depends on PARAVIRT && SMP && EXPERIMENTAL
+	depends on PARAVIRT && SMP
 	---help---
 	  Paravirtualized spinlocks allow a pvops backend to replace the
 	  spinlock implementation with something virtualization-friendly
@@ -715,7 +715,7 @@ config GART_IOMMU
 config CALGARY_IOMMU
 	bool "IBM Calgary IOMMU support"
 	select SWIOTLB
-	depends on X86_64 && PCI && EXPERIMENTAL
+	depends on X86_64 && PCI
 	---help---
 	  Support for hardware IOMMUs in IBM's xSeries x366 and x460
 	  systems. Needed to run systems with more than 3GB of memory
@@ -756,7 +756,7 @@ config IOMMU_HELPER
 
 config MAXSMP
 	bool "Enable Maximum number of SMP Processors and NUMA Nodes"
-	depends on X86_64 && SMP && DEBUG_KERNEL && EXPERIMENTAL
+	depends on X86_64 && SMP && DEBUG_KERNEL
 	select CPUMASK_OFFSTACK
 	---help---
 	  Enable maximum number of CPUS and NUMA Nodes for this architecture.
@@ -1102,7 +1102,6 @@ config HIGHMEM64G
 endchoice
 
 choice
-	depends on EXPERIMENTAL
 	prompt "Memory split" if EXPERT
 	default VMSPLIT_3G
 	depends on X86_32
@@ -1177,7 +1176,7 @@ config DIRECT_GBPAGES
 config NUMA
 	bool "Numa Memory Allocation and Scheduler Support"
 	depends on SMP
-	depends on X86_64 || (X86_32 && HIGHMEM64G && (X86_NUMAQ || X86_BIGSMP || X86_SUMMIT && ACPI) && EXPERIMENTAL)
+	depends on X86_64 || (X86_32 && HIGHMEM64G && (X86_NUMAQ || X86_BIGSMP || X86_SUMMIT && ACPI))
 	default y if (X86_NUMAQ || X86_SUMMIT || X86_BIGSMP)
 	---help---
 	  Enable NUMA (Non Uniform Memory Access) support.
@@ -1272,7 +1271,7 @@ config ARCH_DISCONTIGMEM_DEFAULT
 
 config ARCH_SPARSEMEM_ENABLE
 	def_bool y
-	depends on X86_64 || NUMA || (EXPERIMENTAL && X86_32) || X86_32_NON_STANDARD
+	depends on X86_64 || NUMA || X86_32 || X86_32_NON_STANDARD
 	select SPARSEMEM_STATIC if X86_32
 	select SPARSEMEM_VMEMMAP_ENABLE if X86_64
 
@@ -1575,8 +1574,7 @@ config CRASH_DUMP
 	  For more details see Documentation/kdump/kdump.txt
 
 config KEXEC_JUMP
-	bool "kexec jump (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	bool "kexec jump"
 	depends on KEXEC && HIBERNATION
 	---help---
 	  Jump between original kernel and kexeced kernel and invoke
@@ -1976,7 +1974,7 @@ config PCI_MMCONFIG
 config PCI_CNB20LE_QUIRK
 	bool "Read CNB20LE Host Bridge Windows" if EXPERT
 	default n
-	depends on PCI && EXPERIMENTAL
+	depends on PCI
 	help
 	  Read the PCI windows out of the CNB20LE host bridge. This allows
 	  PCI hotplug to work on systems with the CNB20LE chipset which do
@@ -2169,8 +2167,8 @@ config IA32_AOUT
 	  Support old a.out binaries in the 32bit emulation.
 
 config X86_X32
-	bool "x32 ABI for 64-bit mode (EXPERIMENTAL)"
-	depends on X86_64 && IA32_EMULATION && EXPERIMENTAL
+	bool "x32 ABI for 64-bit mode"
+	depends on X86_64 && IA32_EMULATION
 	---help---
 	  Include code to run binaries for the x32 native 32-bit ABI
 	  for 64-bit processors.  An x32 process gets access to the
diff --git a/arch/x86/configs/i386_defconfig b/arch/x86/configs/i386_defconfig
index 119db67..4525e76 100644
--- a/arch/x86/configs/i386_defconfig
+++ b/arch/x86/configs/i386_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
diff --git a/arch/x86/configs/x86_64_defconfig b/arch/x86/configs/x86_64_defconfig
index 76eb290..51829f0 100644
--- a/arch/x86/configs/x86_64_defconfig
+++ b/arch/x86/configs/x86_64_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
diff --git a/arch/x86/um/Kconfig b/arch/x86/um/Kconfig
index 9926e11..1218e93 100644
--- a/arch/x86/um/Kconfig
+++ b/arch/x86/um/Kconfig
@@ -32,9 +32,8 @@ config RWSEM_GENERIC_SPINLOCK
 	def_bool !RWSEM_XCHGADD_ALGORITHM
 
 config 3_LEVEL_PGTABLES
-	bool "Three-level pagetables (EXPERIMENTAL)" if !64BIT
+	bool "Three-level pagetables" if !64BIT
 	default 64BIT
-	depends on EXPERIMENTAL
 	help
 	Three-level pagetables will let UML have more than 4G of physical
 	memory.  All the memory that can't be mapped directly will be treated
diff --git a/arch/xtensa/configs/common_defconfig b/arch/xtensa/configs/common_defconfig
index a182a4e..18b6561 100644
--- a/arch/xtensa/configs/common_defconfig
+++ b/arch/xtensa/configs/common_defconfig
@@ -13,7 +13,6 @@ CONFIG_GENERIC_HARDIRQS=y
 #
 # Code maturity level options
 #
-CONFIG_EXPERIMENTAL=y
 CONFIG_CLEAN_COMPILE=y
 CONFIG_BROKEN_ON_SMP=y
 
@@ -226,7 +225,7 @@ CONFIG_IP_PNP_RARP=y
 # CONFIG_NETFILTER is not set
 
 #
-# SCTP Configuration (EXPERIMENTAL)
+# SCTP Configuration
 #
 # CONFIG_IP_SCTP is not set
 # CONFIG_ATM is not set
diff --git a/arch/xtensa/configs/iss_defconfig b/arch/xtensa/configs/iss_defconfig
index ddab37b..bf80556 100644
--- a/arch/xtensa/configs/iss_defconfig
+++ b/arch/xtensa/configs/iss_defconfig
@@ -21,7 +21,6 @@ CONFIG_CONSTRUCTORS=y
 #
 # General setup
 #
-CONFIG_EXPERIMENTAL=y
 CONFIG_BROKEN_ON_SMP=y
 CONFIG_INIT_ENV_ARG_LIMIT=32
 CONFIG_LOCALVERSION=""
diff --git a/arch/xtensa/configs/s6105_defconfig b/arch/xtensa/configs/s6105_defconfig
index 550e8ed..c1a1331 100644
--- a/arch/xtensa/configs/s6105_defconfig
+++ b/arch/xtensa/configs/s6105_defconfig
@@ -20,7 +20,6 @@ CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
 #
 # General setup
 #
-CONFIG_EXPERIMENTAL=y
 CONFIG_BROKEN_ON_SMP=y
 CONFIG_INIT_ENV_ARG_LIMIT=32
 CONFIG_LOCALVERSION=""
diff --git a/block/Kconfig b/block/Kconfig
index 09acf1b..a7e40a7 100644
--- a/block/Kconfig
+++ b/block/Kconfig
@@ -89,7 +89,7 @@ config BLK_DEV_INTEGRITY
 
 config BLK_DEV_THROTTLING
 	bool "Block layer bio throttling support"
-	depends on BLK_CGROUP=y && EXPERIMENTAL
+	depends on BLK_CGROUP=y
 	default n
 	---help---
 	Block layer bio throttling support. It can be used to limit
diff --git a/crypto/Kconfig b/crypto/Kconfig
index a323805..87a54d9 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -134,8 +134,8 @@ config CRYPTO_NULL
 	  These are 'Null' algorithms, used by IPsec, which do nothing.
 
 config CRYPTO_PCRYPT
-	tristate "Parallel crypto engine (EXPERIMENTAL)"
-	depends on SMP && EXPERIMENTAL
+	tristate "Parallel crypto engine"
+	depends on SMP
 	select PADATA
 	select CRYPTO_MANAGER
 	select CRYPTO_AEAD
@@ -292,7 +292,6 @@ config CRYPTO_HMAC
 
 config CRYPTO_XCBC
 	tristate "XCBC support"
-	depends on EXPERIMENTAL
 	select CRYPTO_HASH
 	select CRYPTO_MANAGER
 	help
@@ -303,7 +302,6 @@ config CRYPTO_XCBC
 
 config CRYPTO_VMAC
 	tristate "VMAC support"
-	depends on EXPERIMENTAL
 	select CRYPTO_HASH
 	select CRYPTO_MANAGER
 	help
@@ -726,8 +724,7 @@ config CRYPTO_KHAZAD
 	  <http://www.larc.usp.br/~pbarreto/KhazadPage.html>
 
 config CRYPTO_SALSA20
-	tristate "Salsa20 stream cipher algorithm (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	tristate "Salsa20 stream cipher algorithm"
 	select CRYPTO_BLKCIPHER
 	help
 	  Salsa20 stream cipher algorithm.
@@ -739,9 +736,8 @@ config CRYPTO_SALSA20
 	  Bernstein <djb@cr.yp.to>. See <http://cr.yp.to/snuffle.html>
 
 config CRYPTO_SALSA20_586
-	tristate "Salsa20 stream cipher algorithm (i586) (EXPERIMENTAL)"
+	tristate "Salsa20 stream cipher algorithm (i586)"
 	depends on (X86 || UML_X86) && !64BIT
-	depends on EXPERIMENTAL
 	select CRYPTO_BLKCIPHER
 	help
 	  Salsa20 stream cipher algorithm.
@@ -753,9 +749,8 @@ config CRYPTO_SALSA20_586
 	  Bernstein <djb@cr.yp.to>. See <http://cr.yp.to/snuffle.html>
 
 config CRYPTO_SALSA20_X86_64
-	tristate "Salsa20 stream cipher algorithm (x86_64) (EXPERIMENTAL)"
+	tristate "Salsa20 stream cipher algorithm (x86_64)"
 	depends on (X86 || UML_X86) && 64BIT
-	depends on EXPERIMENTAL
 	select CRYPTO_BLKCIPHER
 	help
 	  Salsa20 stream cipher algorithm.
diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index 8099895..fb5e7eb 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -176,7 +176,6 @@ config ACPI_FAN
 
 config ACPI_DOCK
 	bool "Dock"
-	depends on EXPERIMENTAL
 	help
 	  This driver supports ACPI-controlled docking stations and removable
 	  drive bays such as the IBM Ultrabay and the Dell Module Bay.
@@ -196,7 +195,7 @@ config ACPI_PROCESSOR
 	  the module will be called processor.
 config ACPI_IPMI
 	tristate "IPMI"
-	depends on EXPERIMENTAL && IPMI_SI && IPMI_HANDLER
+	depends on IPMI_SI && IPMI_HANDLER
 	default n
 	help
 	  This driver enables the ACPI to access the BMC controller. And it
@@ -208,14 +207,13 @@ config ACPI_IPMI
 
 config ACPI_HOTPLUG_CPU
 	bool
-	depends on EXPERIMENTAL && ACPI_PROCESSOR && HOTPLUG_CPU
+	depends on ACPI_PROCESSOR && HOTPLUG_CPU
 	select ACPI_CONTAINER
 	default y
 
 config ACPI_PROCESSOR_AGGREGATOR
 	tristate "Processor Aggregator"
 	depends on ACPI_PROCESSOR
-	depends on EXPERIMENTAL
 	depends on X86
 	help
 	  ACPI 4.0 defines processor Aggregator, which enables OS to perform
@@ -322,8 +320,7 @@ config X86_PM_TIMER
 	  systems require this timer. 
 
 config ACPI_CONTAINER
-	tristate "Container and Module Devices (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	tristate "Container and Module Devices"
 	default (ACPI_HOTPLUG_MEMORY || ACPI_HOTPLUG_CPU || ACPI_HOTPLUG_IO)
 	help
 	  This driver supports ACPI Container and Module devices (IDs
diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index 27cecd3..e1d87bf 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -163,7 +163,7 @@ config SATA_QSTOR
 
 config SATA_SX4
 	tristate "Promise SATA SX4 support (Experimental)"
-	depends on PCI && EXPERIMENTAL
+	depends on PCI
 	help
 	  This option enables support for Promise Serial ATA SX4.
 
@@ -382,7 +382,7 @@ config PATA_CS5530
 
 config PATA_CS5535
 	tristate "CS5535 PATA support (Experimental)"
-	depends on PCI && X86 && !X86_64 && EXPERIMENTAL
+	depends on PCI && X86 && !X86_64
 	help
 	  This option enables support for the NatSemi/AMD CS5535
 	  companion chip used with the Geode processor family.
@@ -400,7 +400,7 @@ config PATA_CS5536
 
 config PATA_CYPRESS
 	tristate "Cypress CY82C693 PATA support (Very Experimental)"
-	depends on PCI && EXPERIMENTAL
+	depends on PCI
 	help
 	  This option enables support for the Cypress/Contaq CY82C693
 	  chipset found in some Alpha systems
@@ -488,7 +488,7 @@ config PATA_IMX
 
 config PATA_IT8213
 	tristate "IT8213 PATA support (Experimental)"
-	depends on PCI && EXPERIMENTAL
+	depends on PCI
 	help
 	  This option enables support for the ITE 821 PATA
           controllers via the new ATA layer.
@@ -581,7 +581,7 @@ config PATA_OLDPIIX
 
 config PATA_OPTIDMA
 	tristate "OPTI FireStar PATA support (Very Experimental)"
-	depends on PCI && EXPERIMENTAL
+	depends on PCI
 	help
 	  This option enables DMA/PIO support for the later OPTi
 	  controllers found on some old motherboards and in some
@@ -608,7 +608,7 @@ config PATA_PDC_OLD
 
 config PATA_RADISYS
 	tristate "RADISYS 82600 PATA support (Experimental)"
-	depends on PCI && EXPERIMENTAL
+	depends on PCI
 	help
 	  This option enables support for the RADISYS 82600
 	  PATA controllers via the new ATA layer
@@ -679,7 +679,7 @@ config PATA_SIS
 
 config PATA_TOSHIBA
 	tristate "Toshiba Piccolo support (Experimental)"
-	depends on PCI && EXPERIMENTAL
+	depends on PCI
 	help
 	  Support for the Toshiba Piccolo controllers. Currently only the
 	  primary channel is supported by this driver.
@@ -730,7 +730,7 @@ comment "PIO-only SFF controllers"
 
 config PATA_AT32
 	tristate "Atmel AVR32 PATA support (Experimental)"
-	depends on AVR32 && PLATFORM_AT32AP && EXPERIMENTAL
+	depends on AVR32 && PLATFORM_AT32AP
 	help
 	  This option enables support for the IDE devices on the
 	  Atmel AT32AP platform.
@@ -747,7 +747,7 @@ config PATA_AT91
 
 config PATA_CMD640_PCI
 	tristate "CMD640 PCI PATA support (Experimental)"
-	depends on PCI && EXPERIMENTAL
+	depends on PCI
 	help
 	  This option enables support for the CMD640 PCI IDE
 	  interface chip. Only the primary channel is currently
@@ -793,7 +793,7 @@ config PATA_NS87410
 
 config PATA_OPTI
 	tristate "OPTI621/6215 PATA support (Very Experimental)"
-	depends on PCI && EXPERIMENTAL
+	depends on PCI
 	help
 	  This option enables full PIO support for the early Opti ATA
 	  controllers found on some old motherboards.
@@ -873,7 +873,7 @@ config PATA_SAMSUNG_CF
 
 config PATA_WINBOND_VLB
 	tristate "Winbond W83759A VLB PATA support (Experimental)"
-	depends on ISA && EXPERIMENTAL
+	depends on ISA
 	select PATA_LEGACY
 	help
 	  Support for the Winbond W83759A controller on Vesa Local Bus
@@ -901,7 +901,7 @@ config ATA_GENERIC
 
 config PATA_LEGACY
 	tristate "Legacy ISA PATA support (Experimental)"
-	depends on (ISA || PCI) && EXPERIMENTAL
+	depends on (ISA || PCI)
 	help
 	  This option enables support for ISA/VLB/PCI bus legacy PATA
 	  ports and allows them to be accessed via the new ATA layer.
diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
index 08b4c52..e439ebc 100644
--- a/drivers/base/Kconfig
+++ b/drivers/base/Kconfig
@@ -57,7 +57,7 @@ config DEVTMPFS_MOUNT
 	  on the rootfs is completely empty.
 
 config STANDALONE
-	bool "Select only drivers that don't need compile-time external firmware" if EXPERIMENTAL
+	bool "Select only drivers that don't need compile-time external firmware"
 	default y
 	help
 	  Select this option if you don't have magic firmware for drivers that
@@ -185,7 +185,6 @@ config DMA_SHARED_BUFFER
 	bool
 	default n
 	select ANON_INODES
-	depends on EXPERIMENTAL
 	help
 	  This option enables the framework for buffer-sharing between
 	  multiple drivers. A buffer is associated with a file using driver
@@ -193,8 +192,8 @@ config DMA_SHARED_BUFFER
 	  driver.
 
 config CMA
-	bool "Contiguous Memory Allocator (EXPERIMENTAL)"
-	depends on HAVE_DMA_CONTIGUOUS && HAVE_MEMBLOCK && EXPERIMENTAL
+	bool "Contiguous Memory Allocator"
+	depends on HAVE_DMA_CONTIGUOUS && HAVE_MEMBLOCK
 	select MIGRATION
 	select MEMORY_ISOLATION
 	help
diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index a796407..0741c0d 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -166,8 +166,8 @@ config BLK_DEV_DAC960
 	  module will be called DAC960.
 
 config BLK_DEV_UMEM
-	tristate "Micro Memory MM5415 Battery Backed RAM support (EXPERIMENTAL)"
-	depends on PCI && EXPERIMENTAL
+	tristate "Micro Memory MM5415 Battery Backed RAM support"
+	depends on PCI
 	---help---
 	  Saying Y here will include support for the MM5415 family of
 	  battery backed (Non-volatile) RAM cards.
@@ -442,8 +442,8 @@ config CDROM_PKTCDVD_BUFFERS
 	  a disc is opened for writing.
 
 config CDROM_PKTCDVD_WCACHE
-	bool "Enable write caching (EXPERIMENTAL)"
-	depends on CDROM_PKTCDVD && EXPERIMENTAL
+	bool "Enable write caching"
+	depends on CDROM_PKTCDVD
 	help
 	  If enabled, write caching will be set for the CD-R/W device. For now
 	  this option is dangerous unless the CD-RW media is known good, as we
@@ -520,8 +520,8 @@ config XEN_BLKDEV_BACKEND
 
 
 config VIRTIO_BLK
-	tristate "Virtio block driver (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && VIRTIO
+	tristate "Virtio block driver"
+	depends on VIRTIO
 	---help---
 	  This is the virtual block driver for virtio.  It can be used with
           lguest or QEMU based VMMs (like KVM or Xen).  Say Y or M.
@@ -540,7 +540,7 @@ config BLK_DEV_HD
 
 config BLK_DEV_RBD
 	tristate "Rados block device (RBD)"
-	depends on INET && EXPERIMENTAL && BLOCK
+	depends on INET && BLOCK
 	select CEPH_LIB
 	select LIBCRC32C
 	select CRYPTO_AES
diff --git a/drivers/block/paride/Kconfig b/drivers/block/paride/Kconfig
index 28cf308..efefb5a 100644
--- a/drivers/block/paride/Kconfig
+++ b/drivers/block/paride/Kconfig
@@ -205,8 +205,8 @@ config PARIDE_EPAT
 	  support.
 
 config PARIDE_EPATC8
-	bool "Support c7/c8 chips (EXPERIMENTAL)"
-	depends on PARIDE_EPAT && EXPERIMENTAL
+	bool "Support c7/c8 chips"
+	depends on PARIDE_EPAT
 	help
 	  This option enables support for the newer Shuttle EP1284 (aka c7 and
 	  c8) chip. You need this if you are using any recent Imation SuperDisk
diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index ea6f632..72bedad 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -418,8 +418,8 @@ config APPLICOM
 	  If unsure, say N.
 
 config SONYPI
-	tristate "Sony Vaio Programmable I/O Control Device support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && X86 && PCI && INPUT && !64BIT
+	tristate "Sony Vaio Programmable I/O Control Device support"
+	depends on X86 && PCI && INPUT && !64BIT
 	---help---
 	  This driver enables access to the Sony Programmable I/O Control
 	  Device which can be found in many (all ?) Sony Vaio laptops.
@@ -566,7 +566,7 @@ source "drivers/char/tpm/Kconfig"
 
 config TELCLOCK
 	tristate "Telecom clock driver for ATCA SBC"
-	depends on EXPERIMENTAL && X86
+	depends on X86
 	default n
 	help
 	  The telecom clock device is specific to the MPCBL0010 and MPCBL0050
diff --git a/drivers/cpufreq/Kconfig.arm b/drivers/cpufreq/Kconfig.arm
index 5961e64..b63c335 100644
--- a/drivers/cpufreq/Kconfig.arm
+++ b/drivers/cpufreq/Kconfig.arm
@@ -21,8 +21,8 @@ config ARM_S3C2416_CPUFREQ
 	  If in doubt, say N.
 
 config ARM_S3C2416_CPUFREQ_VCORESCALE
-	bool "Allow voltage scaling for S3C2416 arm core (EXPERIMENTAL)"
-	depends on ARM_S3C2416_CPUFREQ && REGULATOR && EXPERIMENTAL
+	bool "Allow voltage scaling for S3C2416 arm core"
+	depends on ARM_S3C2416_CPUFREQ && REGULATOR
 	help
 	  Enable CPU voltage scaling when entering the dvs mode.
 	  It uses information gathered through existing hardware and
diff --git a/drivers/cpufreq/Kconfig.x86 b/drivers/cpufreq/Kconfig.x86
index 78ff7ee..c7d0eb5 100644
--- a/drivers/cpufreq/Kconfig.x86
+++ b/drivers/cpufreq/Kconfig.x86
@@ -160,7 +160,7 @@ config X86_SPEEDSTEP_ICH
 config X86_SPEEDSTEP_SMI
 	tristate "Intel SpeedStep on 440BX/ZX/MX chipsets (SMI interface)"
 	select CPU_FREQ_TABLE
-	depends on X86_32 && EXPERIMENTAL
+	depends on X86_32
 	help
 	  This adds the CPUFreq driver for certain mobile Intel Pentium III
 	  (Coppermine), all mobile Intel Pentium III-M (Tualatin)
@@ -192,7 +192,7 @@ config X86_P4_CLOCKMOD
 
 config X86_CPUFREQ_NFORCE2
 	tristate "nVidia nForce2 FSB changing"
-	depends on X86_32 && EXPERIMENTAL
+	depends on X86_32
 	help
 	  This adds the CPUFreq driver for FSB changing on nVidia nForce2
 	  platforms.
@@ -228,7 +228,7 @@ config X86_LONGHAUL
 config X86_E_POWERSAVER
 	tristate "VIA C7 Enhanced PowerSaver (DANGEROUS)"
 	select CPU_FREQ_TABLE
-	depends on X86_32 && EXPERIMENTAL
+	depends on X86_32
 	help
 	  This adds the CPUFreq driver for VIA C7 processors.  However, this driver
 	  does not have any safeguards to prevent operating the CPU out of spec
diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index d06ea29..54369fc 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -51,7 +51,7 @@ config ASYNC_TX_ENABLE_CHANNEL_SWITCH
 
 config AMBA_PL08X
 	bool "ARM PrimeCell PL080 or PL081 support"
-	depends on ARM_AMBA && EXPERIMENTAL
+	depends on ARM_AMBA
 	select DMA_ENGINE
 	select DMA_VIRTUAL_CHANNELS
 	help
diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
index 409b92b..2ab1b22 100644
--- a/drivers/edac/Kconfig
+++ b/drivers/edac/Kconfig
@@ -157,7 +157,7 @@ config EDAC_I3000
 
 config EDAC_I3200
 	tristate "Intel 3200"
-	depends on EDAC_MM_EDAC && PCI && X86 && EXPERIMENTAL
+	depends on EDAC_MM_EDAC && PCI && X86
 	help
 	  Support for error detection and correction on the Intel
 	  3200 and 3210 server chipsets.
@@ -223,7 +223,7 @@ config EDAC_I7300
 config EDAC_SBRIDGE
 	tristate "Intel Sandy-Bridge Integrated MC"
 	depends on EDAC_MM_EDAC && PCI && X86_64 && X86_MCE_INTEL
-	depends on PCI_MMCONFIG && EXPERIMENTAL
+	depends on PCI_MMCONFIG
 	help
 	  Support for error detection and correction the Intel
 	  Sandy Bridge Integrated Memory Controller.
diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index b16c8a7..207e692 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -62,7 +62,7 @@ config DEBUG_GPIO
 
 config GPIO_SYSFS
 	bool "/sys/class/gpio/... (sysfs interface)"
-	depends on SYSFS && EXPERIMENTAL
+	depends on SYSFS
 	help
 	  Say Y here to add a sysfs interface for GPIOs.
 
diff --git a/drivers/gpu/drm/ast/Kconfig b/drivers/gpu/drm/ast/Kconfig
index a277b12..da4a51e 100644
--- a/drivers/gpu/drm/ast/Kconfig
+++ b/drivers/gpu/drm/ast/Kconfig
@@ -1,6 +1,6 @@
 config DRM_AST
 	tristate "AST server chips"
-	depends on DRM && PCI && EXPERIMENTAL
+	depends on DRM && PCI
 	select DRM_TTM
 	select FB_SYS_COPYAREA
 	select FB_SYS_FILLRECT
diff --git a/drivers/gpu/drm/cirrus/Kconfig b/drivers/gpu/drm/cirrus/Kconfig
index fc154dd..bf67b22 100644
--- a/drivers/gpu/drm/cirrus/Kconfig
+++ b/drivers/gpu/drm/cirrus/Kconfig
@@ -1,6 +1,6 @@
 config DRM_CIRRUS_QEMU
 	tristate "Cirrus driver for QEMU emulated device"
-	depends on DRM && PCI && EXPERIMENTAL
+	depends on DRM && PCI
 	select FB_SYS_FILLRECT
 	select FB_SYS_COPYAREA
 	select FB_SYS_IMAGEBLIT
diff --git a/drivers/gpu/drm/gma500/Kconfig b/drivers/gpu/drm/gma500/Kconfig
index 42e665c..1188f0f 100644
--- a/drivers/gpu/drm/gma500/Kconfig
+++ b/drivers/gpu/drm/gma500/Kconfig
@@ -1,6 +1,6 @@
 config DRM_GMA500
 	tristate "Intel GMA5/600 KMS Framebuffer"
-	depends on DRM && PCI && X86 && EXPERIMENTAL
+	depends on DRM && PCI && X86
 	select FB_CFB_COPYAREA
         select FB_CFB_FILLRECT
         select FB_CFB_IMAGEBLIT
diff --git a/drivers/gpu/drm/mgag200/Kconfig b/drivers/gpu/drm/mgag200/Kconfig
index d630134..b487cde 100644
--- a/drivers/gpu/drm/mgag200/Kconfig
+++ b/drivers/gpu/drm/mgag200/Kconfig
@@ -1,6 +1,6 @@
 config DRM_MGAG200
 	tristate "Kernel modesetting driver for MGA G200 server engines"
-	depends on DRM && PCI && EXPERIMENTAL
+	depends on DRM && PCI
 	select FB_SYS_FILLRECT
 	select FB_SYS_COPYAREA
 	select FB_SYS_IMAGEBLIT
diff --git a/drivers/gpu/drm/udl/Kconfig b/drivers/gpu/drm/udl/Kconfig
index 56e0bf3..6222af1 100644
--- a/drivers/gpu/drm/udl/Kconfig
+++ b/drivers/gpu/drm/udl/Kconfig
@@ -1,6 +1,6 @@
 config DRM_UDL
 	tristate "DisplayLink"
-	depends on DRM && EXPERIMENTAL
+	depends on DRM
 	depends on USB_ARCH_HAS_HCD
 	select DRM_USB
 	select FB_SYS_FILLRECT
diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index b0a2e4c..7cc6e65 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -41,7 +41,7 @@ comment "Native drivers"
 
 config SENSORS_ABITUGURU
 	tristate "Abit uGuru (rev 1 & 2)"
-	depends on X86 && DMI && EXPERIMENTAL
+	depends on X86 && DMI
 	help
 	  If you say yes here you get support for the sensor part of the first
 	  and second revision of the Abit uGuru chip. The voltage and frequency
@@ -56,7 +56,7 @@ config SENSORS_ABITUGURU
 
 config SENSORS_ABITUGURU3
 	tristate "Abit uGuru (rev 3)"
-	depends on X86 && DMI && EXPERIMENTAL
+	depends on X86 && DMI
 	help
 	  If you say yes here you get support for the sensor part of the
 	  third revision of the Abit uGuru chip. Only reading the sensors
@@ -70,7 +70,7 @@ config SENSORS_ABITUGURU3
 
 config SENSORS_AD7314
 	tristate "Analog Devices AD7314 and compatibles"
-	depends on SPI && EXPERIMENTAL
+	depends on SPI
 	help
 	  If you say yes here you get support for the Analog Devices
 	  AD7314, ADT7301 and ADT7302 temperature sensors.
@@ -80,7 +80,7 @@ config SENSORS_AD7314
 
 config SENSORS_AD7414
 	tristate "Analog Devices AD7414"
-	depends on I2C && EXPERIMENTAL
+	depends on I2C
 	help
 	  If you say yes here you get support for the Analog Devices
 	  AD7414 temperature monitoring chip.
@@ -90,7 +90,7 @@ config SENSORS_AD7414
 
 config SENSORS_AD7418
 	tristate "Analog Devices AD7416, AD7417 and AD7418"
-	depends on I2C && EXPERIMENTAL
+	depends on I2C
 	help
 	  If you say yes here you get support for the Analog Devices
 	  AD7416, AD7417 and AD7418 temperature monitoring chips.
@@ -100,7 +100,7 @@ config SENSORS_AD7418
 
 config SENSORS_ADCXX
 	tristate "National Semiconductor ADCxxxSxxx"
-	depends on SPI_MASTER && EXPERIMENTAL
+	depends on SPI_MASTER
 	help
 	  If you say yes here you get support for the National Semiconductor
 	  ADC<bb><c>S<sss> chip family, where
@@ -181,7 +181,7 @@ config SENSORS_ADM9240
 
 config SENSORS_ADT7411
 	tristate "Analog Devices ADT7411"
-	depends on I2C && EXPERIMENTAL
+	depends on I2C
 	help
 	  If you say yes here you get support for the Analog Devices
 	  ADT7411 voltage and temperature monitoring chip.
@@ -191,7 +191,7 @@ config SENSORS_ADT7411
 
 config SENSORS_ADT7462
 	tristate "Analog Devices ADT7462"
-	depends on I2C && EXPERIMENTAL
+	depends on I2C
 	help
 	  If you say yes here you get support for the Analog Devices
 	  ADT7462 temperature monitoring chips.
@@ -201,7 +201,7 @@ config SENSORS_ADT7462
 
 config SENSORS_ADT7470
 	tristate "Analog Devices ADT7470"
-	depends on I2C && EXPERIMENTAL
+	depends on I2C
 	help
 	  If you say yes here you get support for the Analog Devices
 	  ADT7470 temperature monitoring chips.
@@ -236,7 +236,7 @@ config SENSORS_ASC7621
 
 config SENSORS_K8TEMP
 	tristate "AMD Athlon64/FX or Opteron temperature sensor"
-	depends on X86 && PCI && EXPERIMENTAL
+	depends on X86 && PCI
 	help
 	  If you say yes here you get support for the temperature
 	  sensor(s) inside your CPU. Supported is whole AMD K8
@@ -271,7 +271,7 @@ config SENSORS_FAM15H_POWER
 
 config SENSORS_ASB100
 	tristate "Asus ASB100 Bach"
-	depends on X86 && I2C && EXPERIMENTAL
+	depends on X86 && I2C
 	select HWMON_VID
 	help
 	  If you say yes here you get support for the ASB100 Bach sensor
@@ -282,7 +282,7 @@ config SENSORS_ASB100
 
 config SENSORS_ATXP1
 	tristate "Attansic ATXP1 VID controller"
-	depends on I2C && EXPERIMENTAL
+	depends on I2C
 	select HWMON_VID
 	help
 	  If you say yes here you get support for the Attansic ATXP1 VID
@@ -336,7 +336,7 @@ config SENSORS_EXYNOS4_TMU
 
 config SENSORS_I5K_AMB
 	tristate "FB-DIMM AMB temperature sensor on Intel 5000 series chipsets"
-	depends on PCI && EXPERIMENTAL
+	depends on PCI
 	help
 	  If you say yes here you get support for FB-DIMM AMB temperature
 	  monitoring chips on systems with the Intel 5000 series chipset.
@@ -445,7 +445,7 @@ config SENSORS_GPIO_FAN
 
 config SENSORS_HIH6130
 	tristate "Honeywell Humidicon HIH-6130 humidity/temperature sensor"
-	depends on I2C && EXPERIMENTAL
+	depends on I2C
 	help
 	  If you say yes here you get support for Honeywell Humidicon
 	  HIH-6130 and HIH-6131 Humidicon humidity sensors.
@@ -455,7 +455,7 @@ config SENSORS_HIH6130
 
 config SENSORS_CORETEMP
 	tristate "Intel Core/Core2/Atom temperature sensor"
-	depends on X86 && PCI && EXPERIMENTAL
+	depends on X86 && PCI
 	help
 	  If you say yes here you get support for the temperature
 	  sensor inside your CPU. Most of the family 6 CPUs
@@ -527,7 +527,7 @@ config SENSORS_JC42
 
 config SENSORS_LINEAGE
 	tristate "Lineage Compact Power Line Power Entry Module"
-	depends on I2C && EXPERIMENTAL
+	depends on I2C
 	help
 	  If you say yes here you get support for the Lineage Compact Power Line
 	  series of DC/DC and AC/DC converters such as CP1800, CP2000AC,
@@ -709,7 +709,7 @@ config SENSORS_LTC4151
 
 config SENSORS_LTC4215
 	tristate "Linear Technology LTC4215"
-	depends on I2C && EXPERIMENTAL
+	depends on I2C
 	default n
 	help
 	  If you say yes here you get support for Linear Technology LTC4215
@@ -720,7 +720,7 @@ config SENSORS_LTC4215
 
 config SENSORS_LTC4245
 	tristate "Linear Technology LTC4245"
-	depends on I2C && EXPERIMENTAL
+	depends on I2C
 	default n
 	help
 	  If you say yes here you get support for Linear Technology LTC4245
@@ -731,7 +731,7 @@ config SENSORS_LTC4245
 
 config SENSORS_LTC4261
 	tristate "Linear Technology LTC4261"
-	depends on I2C && EXPERIMENTAL
+	depends on I2C
 	default n
 	help
 	  If you say yes here you get support for Linear Technology LTC4261
@@ -752,7 +752,7 @@ config SENSORS_LM95241
 
 config SENSORS_LM95245
 	tristate "National Semiconductor LM95245 sensor chip"
-	depends on I2C && EXPERIMENTAL
+	depends on I2C
 	help
 	  If you say yes here you get support for LM95245 sensor chip.
 
@@ -795,7 +795,7 @@ config SENSORS_MAX1619
 
 config SENSORS_MAX1668
 	tristate "Maxim MAX1668 and compatibles"
-	depends on I2C && EXPERIMENTAL
+	depends on I2C
 	help
 	  If you say yes here you get support for MAX1668, MAX1989 and
 	  MAX1805 chips.
@@ -805,7 +805,7 @@ config SENSORS_MAX1668
 
 config SENSORS_MAX6639
 	tristate "Maxim MAX6639 sensor chip"
-	depends on I2C && EXPERIMENTAL
+	depends on I2C
 	help
 	  If you say yes here you get support for the MAX6639
 	  sensor chips.
@@ -815,7 +815,7 @@ config SENSORS_MAX6639
 
 config SENSORS_MAX6642
 	tristate "Maxim MAX6642 sensor chip"
-	depends on I2C && EXPERIMENTAL
+	depends on I2C
 	help
 	  If you say yes here you get support for MAX6642 sensor chip.
 	  MAX6642 is a SMBus-Compatible Remote/Local Temperature Sensor
@@ -826,7 +826,7 @@ config SENSORS_MAX6642
 
 config SENSORS_MAX6650
 	tristate "Maxim MAX6650 sensor chip"
-	depends on I2C && EXPERIMENTAL
+	depends on I2C
 	help
 	  If you say yes here you get support for the MAX6650 / MAX6651
 	  sensor chips.
@@ -836,7 +836,7 @@ config SENSORS_MAX6650
 
 config SENSORS_MCP3021
 	tristate "Microchip MCP3021"
-	depends on I2C && EXPERIMENTAL
+	depends on I2C
 	help
 	  If you say yes here you get support for the MCP3021 chip
 	  that is a A/D converter (ADC) with 10-bit resolution.
@@ -846,7 +846,6 @@ config SENSORS_MCP3021
 
 config SENSORS_NTC_THERMISTOR
 	tristate "NTC thermistor support"
-	depends on EXPERIMENTAL
 	help
 	  This driver supports NTC thermistors sensor reading and its
 	  interpretation. The driver can also monitor the temperature and
@@ -951,7 +950,7 @@ config SENSORS_SIS5595
 
 config SENSORS_SMM665
 	tristate "Summit Microelectronics SMM665"
-	depends on I2C && EXPERIMENTAL
+	depends on I2C
 	default n
 	help
 	  If you say yes here you get support for the hardware monitoring
@@ -966,7 +965,7 @@ config SENSORS_SMM665
 
 config SENSORS_DME1737
 	tristate "SMSC DME1737, SCH311x and compatibles"
-	depends on I2C && EXPERIMENTAL && !PPC
+	depends on I2C && !PPC
 	select HWMON_VID
 	help
 	  If you say yes here you get support for the hardware monitoring
@@ -1042,7 +1041,7 @@ config SENSORS_SMSC47M192
 
 config SENSORS_SMSC47B397
 	tristate "SMSC LPC47B397-NC"
-	depends on EXPERIMENTAL && !PPC
+	depends on !PPC
 	help
 	  If you say yes here you get support for the SMSC LPC47B397-NC
 	  sensor chip.
@@ -1116,7 +1115,7 @@ config SENSORS_ADS7871
 
 config SENSORS_AMC6821
 	tristate "Texas Instruments AMC6821"
-	depends on I2C  && EXPERIMENTAL
+	depends on I2C
 	help
 	  If you say yes here you get support for the Texas Instruments
 	  AMC6821 hardware monitoring chips.
@@ -1126,7 +1125,7 @@ config SENSORS_AMC6821
 
 config SENSORS_INA2XX
 	tristate "Texas Instruments INA219, INA226"
-	depends on I2C && EXPERIMENTAL
+	depends on I2C
 	help
 	  If you say yes here you get support for INA219 and INA226 power
 	  monitor chips.
@@ -1149,7 +1148,7 @@ config SENSORS_THMC50
 
 config SENSORS_TMP102
 	tristate "Texas Instruments TMP102"
-	depends on I2C && EXPERIMENTAL
+	depends on I2C
 	help
 	  If you say yes here you get support for Texas Instruments TMP102
 	  sensor chips.
@@ -1159,7 +1158,7 @@ config SENSORS_TMP102
 
 config SENSORS_TMP401
 	tristate "Texas Instruments TMP401 and compatibles"
-	depends on I2C && EXPERIMENTAL
+	depends on I2C
 	help
 	  If you say yes here you get support for Texas Instruments TMP401 and
 	  TMP411 temperature sensor chips.
@@ -1169,7 +1168,7 @@ config SENSORS_TMP401
 
 config SENSORS_TMP421
 	tristate "Texas Instruments TMP421 and compatible"
-	depends on I2C && EXPERIMENTAL
+	depends on I2C
 	help
 	  If you say yes here you get support for Texas Instruments TMP421,
 	  TMP422 and TMP423 temperature sensor chips.
@@ -1261,7 +1260,7 @@ config SENSORS_W83792D
 
 config SENSORS_W83793
 	tristate "Winbond W83793"
-	depends on I2C && EXPERIMENTAL
+	depends on I2C
 	select HWMON_VID
 	help
 	  If you say yes here you get support for the Winbond W83793
@@ -1273,7 +1272,7 @@ config SENSORS_W83793
 
 config SENSORS_W83795
 	tristate "Winbond/Nuvoton W83795G/ADG"
-	depends on I2C && EXPERIMENTAL
+	depends on I2C
 	help
 	  If you say yes here you get support for the Winbond W83795G and
 	  W83795ADG hardware monitoring chip, including manual fan speed
@@ -1284,7 +1283,7 @@ config SENSORS_W83795
 
 config SENSORS_W83795_FANCTRL
 	boolean "Include automatic fan control support (DANGEROUS)"
-	depends on SENSORS_W83795 && EXPERIMENTAL
+	depends on SENSORS_W83795
 	default n
 	help
 	  If you say yes here, support for automatic fan speed control
@@ -1301,7 +1300,7 @@ config SENSORS_W83795_FANCTRL
 
 config SENSORS_W83L785TS
 	tristate "Winbond W83L785TS-S"
-	depends on I2C && EXPERIMENTAL
+	depends on I2C
 	help
 	  If you say yes here you get support for the Winbond W83L785TS-S
 	  sensor chip, which is used on the Asus A7N8X, among other
@@ -1312,7 +1311,7 @@ config SENSORS_W83L785TS
 
 config SENSORS_W83L786NG
 	tristate "Winbond W83L786NG, W83L786NR"
-	depends on I2C && EXPERIMENTAL
+	depends on I2C
 	help
 	  If you say yes here you get support for the Winbond W83L786NG
 	  and W83L786NR sensor chips.
@@ -1427,7 +1426,7 @@ config SENSORS_ACPI_POWER
 
 config SENSORS_ATK0110
 	tristate "ASUS ATK0110"
-	depends on X86 && EXPERIMENTAL
+	depends on X86
 	help
 	  If you say yes here you get support for the ACPI hardware
 	  monitoring interface found in many ASUS motherboards. This
diff --git a/drivers/hwmon/pmbus/Kconfig b/drivers/hwmon/pmbus/Kconfig
index 2ca6a5a..60745a5 100644
--- a/drivers/hwmon/pmbus/Kconfig
+++ b/drivers/hwmon/pmbus/Kconfig
@@ -4,7 +4,7 @@
 
 menuconfig PMBUS
 	tristate "PMBus support"
-	depends on I2C && EXPERIMENTAL
+	depends on I2C
 	default n
 	help
 	  Say yes here if you want to enable PMBus support.
diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index b4aaa1b..bcfe300 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -21,7 +21,7 @@ config I2C_ALI1535
 
 config I2C_ALI1563
 	tristate "ALI 1563"
-	depends on PCI && EXPERIMENTAL
+	depends on PCI
 	help
 	  If you say yes to this option, support will be included for the SMB
 	  Host controller on Acer Labs Inc. (ALI) M1563 South Bridges.  The SMB
@@ -55,7 +55,7 @@ config I2C_AMD756
 
 config I2C_AMD756_S4882
 	tristate "SMBus multiplexing on the Tyan S4882"
-	depends on I2C_AMD756 && X86 && EXPERIMENTAL
+	depends on I2C_AMD756 && X86
 	help
 	  Enabling this option will add specific SMBus support for the Tyan
 	  S4882 motherboard.  On this 4-CPU board, the SMBus is multiplexed
@@ -162,7 +162,7 @@ config I2C_NFORCE2
 
 config I2C_NFORCE2_S4985
 	tristate "SMBus multiplexing on the Tyan S4985"
-	depends on I2C_NFORCE2 && X86 && EXPERIMENTAL
+	depends on I2C_NFORCE2 && X86
 	help
 	  Enabling this option will add specific SMBus support for the Tyan
 	  S4985 motherboard.  On this 4-CPU board, the SMBus is multiplexed
@@ -213,7 +213,7 @@ config I2C_SIS96X
 
 config I2C_VIA
 	tristate "VIA VT82C586B"
-	depends on PCI && EXPERIMENTAL
+	depends on PCI
 	select I2C_ALGOBIT
 	help
 	  If you say yes to this option, support will be included for the VIA
@@ -264,7 +264,7 @@ comment "Mac SMBus host controller drivers"
 
 config I2C_HYDRA
 	tristate "CHRP Apple Hydra Mac I/O I2C interface"
-	depends on PCI && PPC_CHRP && EXPERIMENTAL
+	depends on PCI && PPC_CHRP
 	select I2C_ALGOBIT
 	help
 	  This supports the use of the I2C interface in the Apple Hydra Mac
@@ -290,7 +290,7 @@ comment "I2C system bus drivers (mostly embedded / system-on-chip)"
 
 config I2C_AT91
 	tristate "Atmel AT91 I2C Two-Wire interface (TWI)"
-	depends on ARCH_AT91 && EXPERIMENTAL && BROKEN
+	depends on ARCH_AT91 && BROKEN
 	help
 	  This supports the use of the I2C interface on Atmel AT91
 	  processors.
@@ -498,7 +498,6 @@ config I2C_NUC900
 
 config I2C_OCORES
 	tristate "OpenCores I2C Controller"
-	depends on EXPERIMENTAL
 	help
 	  If you say yes to this option, support will be included for the
 	  OpenCores I2C controller. For details see
@@ -691,7 +690,7 @@ config I2C_OCTEON
 
 config I2C_XILINX
 	tristate "Xilinx I2C Controller"
-	depends on EXPERIMENTAL && HAS_IOMEM
+	depends on HAS_IOMEM
 	help
 	  If you say yes to this option, support will be included for the
 	  Xilinx I2C controller.
@@ -772,7 +771,6 @@ config I2C_PARPORT_LIGHT
 
 config I2C_TAOS_EVM
 	tristate "TAOS evaluation module"
-	depends on EXPERIMENTAL
 	select SERIO
 	select SERIO_SERPORT
 	default n
@@ -845,7 +843,7 @@ config I2C_SIBYTE
 
 config I2C_STUB
 	tristate "I2C/SMBus Test Stub"
-	depends on EXPERIMENTAL && m
+	depends on m
 	default 'n'
 	help
 	  This module may be useful to developers of SMBus client drivers,
diff --git a/drivers/i2c/muxes/Kconfig b/drivers/i2c/muxes/Kconfig
index a0edd98..0be5b83 100644
--- a/drivers/i2c/muxes/Kconfig
+++ b/drivers/i2c/muxes/Kconfig
@@ -19,7 +19,6 @@ config I2C_MUX_GPIO
 
 config I2C_MUX_PCA9541
 	tristate "NXP PCA9541 I2C Master Selector"
-	depends on EXPERIMENTAL
 	help
 	  If you say yes here you get support for the NXP PCA9541
 	  I2C Master Selector.
@@ -29,7 +28,6 @@ config I2C_MUX_PCA9541
 
 config I2C_MUX_PCA954x
 	tristate "Philips PCA954x I2C Mux/switches"
-	depends on EXPERIMENTAL
 	help
 	  If you say yes here you get support for the Philips PCA954x
 	  I2C mux/switch devices.
diff --git a/drivers/ide/Kconfig b/drivers/ide/Kconfig
index 5a26584..3c4417a 100644
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -322,8 +322,7 @@ config BLK_DEV_GENERIC
           which otherwise might not be supported.
 
 config BLK_DEV_OPTI621
-	tristate "OPTi 82C621 chipset enhanced support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	tristate "OPTi 82C621 chipset enhanced support"
 	select BLK_DEV_IDEPCI
 	help
 	  This is a driver for the OPTi 82C621 EIDE controller.
@@ -417,7 +416,6 @@ config BLK_DEV_CY82C693
 
 config BLK_DEV_CS5520
 	tristate "Cyrix CS5510/20 MediaGX chipset support (VERY EXPERIMENTAL)"
-	depends on EXPERIMENTAL
 	select BLK_DEV_IDEDMA_PCI
 	help
 	  Include support for PIO tuning and virtual DMA on the Cyrix MediaGX
@@ -761,8 +759,8 @@ config BLK_DEV_GAYLE
 	  use Gayle IDE interfaces on the Zorro expansion bus.
 
 config BLK_DEV_BUDDHA
-	tristate "Buddha/Catweasel/X-Surf IDE interface support (EXPERIMENTAL)"
-	depends on ZORRO && EXPERIMENTAL
+	tristate "Buddha/Catweasel/X-Surf IDE interface support"
+	depends on ZORRO
 	help
 	  This is the IDE driver for the IDE interfaces on the Buddha, Catweasel
 	  and X-Surf expansion boards.  It supports up to two interfaces on the
diff --git a/drivers/idle/Kconfig b/drivers/idle/Kconfig
index 8489eb5..4732dfc 100644
--- a/drivers/idle/Kconfig
+++ b/drivers/idle/Kconfig
@@ -18,7 +18,6 @@ config I7300_IDLE_IOAT_CHANNEL
 config I7300_IDLE
 	tristate "Intel chipset idle memory power saving driver"
 	select I7300_IDLE_IOAT_CHANNEL
-	depends on EXPERIMENTAL
 	help
 	  Enable memory power savings when idle with certain Intel server
 	  chipsets. The chipset must have I/O AT support, such as the
diff --git a/drivers/iio/dac/Kconfig b/drivers/iio/dac/Kconfig
index 1be15fa..7aa4aeb 100644
--- a/drivers/iio/dac/Kconfig
+++ b/drivers/iio/dac/Kconfig
@@ -110,7 +110,7 @@ config AD5686
 
 config MAX517
 	tristate "Maxim MAX517/518/519 DAC driver"
-	depends on I2C && EXPERIMENTAL
+	depends on I2C
 	help
 	  If you say yes here you get support for the Maxim chips MAX517,
 	  MAX518 and MAX519 (I2C 8-Bit DACs with rail-to-rail outputs).
diff --git a/drivers/input/keyboard/Kconfig b/drivers/input/keyboard/Kconfig
index c50fa75..f483ce6 100644
--- a/drivers/input/keyboard/Kconfig
+++ b/drivers/input/keyboard/Kconfig
@@ -134,7 +134,7 @@ config KEYBOARD_QT1070
 
 config KEYBOARD_QT2160
 	tristate "Atmel AT42QT2160 Touch Sensor Chip"
-	depends on I2C && EXPERIMENTAL
+	depends on I2C
 	help
 	  If you say yes here you get support for Atmel AT42QT2160 Touch
 	  Sensor chip as a keyboard input.
diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
index 7c0f1ec..a7719a2 100644
--- a/drivers/input/misc/Kconfig
+++ b/drivers/input/misc/Kconfig
@@ -290,8 +290,7 @@ config INPUT_ATI_REMOTE2
 	  called ati_remote2.
 
 config INPUT_KEYSPAN_REMOTE
-	tristate "Keyspan DMR USB remote control (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	tristate "Keyspan DMR USB remote control"
 	depends on USB_ARCH_HAS_HCD
 	select USB
 	help
@@ -340,7 +339,6 @@ config INPUT_POWERMATE
 
 config INPUT_YEALINK
 	tristate "Yealink usb-p1k voip phone"
-	depends on EXPERIMENTAL
 	depends on USB_ARCH_HAS_HCD
 	select USB
 	help
@@ -356,7 +354,6 @@ config INPUT_YEALINK
 
 config INPUT_CM109
 	tristate "C-Media CM109 USB I/O Controller"
-	depends on EXPERIMENTAL
 	depends on USB_ARCH_HAS_HCD
 	select USB
 	help
@@ -434,7 +431,7 @@ config INPUT_PCF50633_PMU
 
 config INPUT_PCF8574
 	tristate "PCF8574 Keypad input device"
-	depends on I2C && EXPERIMENTAL
+	depends on I2C
 	help
 	  Say Y here if you want to support a keypad connected via I2C
 	  with a PCF8574.
diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index 9f69b56..2baa2e2 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -65,8 +65,8 @@ config AMD_IOMMU_STATS
 	  If unsure, say N.
 
 config AMD_IOMMU_V2
-	tristate "AMD IOMMU Version 2 driver (EXPERIMENTAL)"
-	depends on AMD_IOMMU && PROFILING && EXPERIMENTAL
+	tristate "AMD IOMMU Version 2 driver"
+	depends on AMD_IOMMU && PROFILING
 	select MMU_NOTIFIER
 	---help---
 	  This option enables support for the AMD IOMMUv2 features of the IOMMU
@@ -119,8 +119,8 @@ config INTEL_IOMMU_FLOPPY_WA
 	  16MiB to make floppy (an ISA device) work.
 
 config IRQ_REMAP
-	bool "Support for Interrupt Remapping (EXPERIMENTAL)"
-	depends on X86_64 && X86_IO_APIC && PCI_MSI && ACPI && EXPERIMENTAL
+	bool "Support for Interrupt Remapping"
+	depends on X86_64 && X86_IO_APIC && PCI_MSI && ACPI
 	select DMAR_TABLE
 	---help---
 	  Supports Interrupt remapping for IO-APIC and MSI devices.
diff --git a/drivers/isdn/hisax/Kconfig b/drivers/isdn/hisax/Kconfig
index 452fde9..643d43b 100644
--- a/drivers/isdn/hisax/Kconfig
+++ b/drivers/isdn/hisax/Kconfig
@@ -389,8 +389,8 @@ config HISAX_TELES_CS
 comment "HiSax sub driver modules"
 
 config HISAX_ST5481
-	tristate "ST5481 USB ISDN modem (EXPERIMENTAL)"
-	depends on USB && EXPERIMENTAL
+	tristate "ST5481 USB ISDN modem"
+	depends on USB
 	select ISDN_HDLC
 	select CRC_CCITT
 	select BITREVERSE
@@ -399,20 +399,19 @@ config HISAX_ST5481
 	  e.g. the BeWan Gazel 128 USB
 
 config HISAX_HFCUSB
-	tristate "HFC USB based ISDN modems (EXPERIMENTAL)"
-	depends on USB && EXPERIMENTAL
+	tristate "HFC USB based ISDN modems"
+	depends on USB
 	help
 	  This enables the driver for HFC USB based ISDN modems.
 
 config HISAX_HFC4S8S
-	tristate "HFC-4S/8S based ISDN cards (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	tristate "HFC-4S/8S based ISDN cards"
 	help
 	  This enables the driver for HFC-4S/8S based ISDN cards.
 
 config HISAX_FRITZ_PCIPNP
-	tristate "AVM Fritz!Card PCI/PCIv2/PnP support (EXPERIMENTAL)"
-	depends on PCI && EXPERIMENTAL
+	tristate "AVM Fritz!Card PCI/PCIv2/PnP support"
+	depends on PCI
 	help
 	  This enables the driver for the AVM Fritz!Card PCI,
 	  Fritz!Card PCI v2 and Fritz!Card PnP.
diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index c96bbaa..75e58ef 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -143,7 +143,7 @@ config LEDS_HP6XX
 config LEDS_PCA9532
 	tristate "LED driver for PCA9532 dimmer"
 	depends on LEDS_CLASS
-	depends on I2C && INPUT && EXPERIMENTAL
+	depends on I2C && INPUT
 	help
 	  This option enables support for NXP pca9532
 	  LED controller. It is generally only useful
diff --git a/drivers/lguest/Kconfig b/drivers/lguest/Kconfig
index 34ae49d..6cdcdb0 100644
--- a/drivers/lguest/Kconfig
+++ b/drivers/lguest/Kconfig
@@ -1,6 +1,6 @@
 config LGUEST
 	tristate "Linux hypervisor example code"
-	depends on X86_32 && EXPERIMENTAL && EVENTFD
+	depends on X86_32 && EVENTFD
 	select HVC_DRIVER
 	---help---
 	  This is a very simple module which allows you to run
diff --git a/drivers/macintosh/Kconfig b/drivers/macintosh/Kconfig
index a555da6..696238b 100644
--- a/drivers/macintosh/Kconfig
+++ b/drivers/macintosh/Kconfig
@@ -278,7 +278,7 @@ config PMAC_RACKMETER
 
 config SENSORS_AMS
 	tristate "Apple Motion Sensor driver"
-	depends on PPC_PMAC && !PPC64 && INPUT && ((ADB_PMU && I2C = y) || (ADB_PMU && !I2C) || I2C) && EXPERIMENTAL
+	depends on PPC_PMAC && !PPC64 && INPUT && ((ADB_PMU && I2C = y) || (ADB_PMU && !I2C) || I2C)
 	select INPUT_POLLDEV
 	help
 	  Support for the motion sensor included in PowerBooks. Includes
diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index d949b78..e9f6e70 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -155,10 +155,9 @@ config MD_RAID456
 	  If unsure, say Y.
 
 config MULTICORE_RAID456
-	bool "RAID-4/RAID-5/RAID-6 Multicore processing (EXPERIMENTAL)"
+	bool "RAID-4/RAID-5/RAID-6 Multicore processing"
 	depends on MD_RAID456
 	depends on SMP
-	depends on EXPERIMENTAL
 	---help---
 	  Enable the raid456 module to dispatch per-stripe raid operations to a
 	  thread pool.
@@ -210,7 +209,7 @@ config DM_DEBUG
 
 config DM_BUFIO
        tristate
-       depends on BLK_DEV_DM && EXPERIMENTAL
+       depends on BLK_DEV_DM
        ---help---
 	 This interface allows you to do buffered I/O on a device and acts
 	 as a cache, holding recently-read blocks in memory and performing
@@ -244,8 +243,8 @@ config DM_SNAPSHOT
          Allow volume managers to take writable snapshots of a device.
 
 config DM_THIN_PROVISIONING
-       tristate "Thin provisioning target (EXPERIMENTAL)"
-       depends on BLK_DEV_DM && EXPERIMENTAL
+       tristate "Thin provisioning target"
+       depends on BLK_DEV_DM
        select DM_PERSISTENT_DATA
        ---help---
          Provides thin provisioning and snapshots that share a data store.
@@ -294,8 +293,8 @@ config DM_RAID
 	 in one of the available parity distribution methods.
 
 config DM_LOG_USERSPACE
-	tristate "Mirror userspace logging (EXPERIMENTAL)"
-	depends on DM_MIRROR && EXPERIMENTAL && NET
+	tristate "Mirror userspace logging"
+	depends on DM_MIRROR && NET
 	select CONNECTOR
 	---help---
 	  The userspace logging module provides a mechanism for
@@ -342,8 +341,8 @@ config DM_MULTIPATH_ST
 	  If unsure, say N.
 
 config DM_DELAY
-	tristate "I/O delaying target (EXPERIMENTAL)"
-	depends on BLK_DEV_DM && EXPERIMENTAL
+	tristate "I/O delaying target"
+	depends on BLK_DEV_DM
 	---help---
 	A target that delays reads and/or writes and can send
 	them to different devices.  Useful for testing.
@@ -357,14 +356,14 @@ config DM_UEVENT
 	Generate udev events for DM events.
 
 config DM_FLAKEY
-       tristate "Flakey target (EXPERIMENTAL)"
-       depends on BLK_DEV_DM && EXPERIMENTAL
+       tristate "Flakey target"
+       depends on BLK_DEV_DM
        ---help---
          A target that intermittently fails I/O for debugging purposes.
 
 config DM_VERITY
-	tristate "Verity target support (EXPERIMENTAL)"
-	depends on BLK_DEV_DM && EXPERIMENTAL
+	tristate "Verity target support"
+	depends on BLK_DEV_DM
 	select CRYPTO
 	select CRYPTO_HASH
 	select DM_BUFIO
diff --git a/drivers/md/persistent-data/Kconfig b/drivers/md/persistent-data/Kconfig
index ceb3590..19b2687 100644
--- a/drivers/md/persistent-data/Kconfig
+++ b/drivers/md/persistent-data/Kconfig
@@ -1,6 +1,6 @@
 config DM_PERSISTENT_DATA
        tristate
-       depends on BLK_DEV_DM && EXPERIMENTAL
+       depends on BLK_DEV_DM
        select LIBCRC32C
        select DM_BUFIO
        ---help---
diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
index d941581..3cdc89f 100644
--- a/drivers/media/Kconfig
+++ b/drivers/media/Kconfig
@@ -79,8 +79,7 @@ config MEDIA_RC_SUPPORT
 #
 
 config MEDIA_CONTROLLER
-	bool "Media Controller API (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	bool "Media Controller API"
 	depends on MEDIA_CAMERA_SUPPORT
 	---help---
 	  Enable the media controller API used to query media devices internal
@@ -105,8 +104,8 @@ config VIDEO_V4L2_COMMON
 	default (I2C || I2C=n) && VIDEO_DEV
 
 config VIDEO_V4L2_SUBDEV_API
-	bool "V4L2 sub-device userspace API (EXPERIMENTAL)"
-	depends on VIDEO_DEV && MEDIA_CONTROLLER && EXPERIMENTAL
+	bool "V4L2 sub-device userspace API"
+	depends on VIDEO_DEV && MEDIA_CONTROLLER
 	---help---
 	  Enables the V4L2 sub-device pad-level userspace API used to configure
 	  video format, size and frame rate between hardware blocks.
diff --git a/drivers/media/common/tuners/Kconfig b/drivers/media/common/tuners/Kconfig
index 94c6ff7..bfcaaf2 100644
--- a/drivers/media/common/tuners/Kconfig
+++ b/drivers/media/common/tuners/Kconfig
@@ -27,7 +27,7 @@ config MEDIA_TUNER
 	select MEDIA_TUNER_XC4000 if !MEDIA_TUNER_CUSTOMISE
 	select MEDIA_TUNER_MT20XX if !MEDIA_TUNER_CUSTOMISE
 	select MEDIA_TUNER_TDA8290 if !MEDIA_TUNER_CUSTOMISE
-	select MEDIA_TUNER_TEA5761 if !MEDIA_TUNER_CUSTOMISE && MEDIA_RADIO_SUPPORT && EXPERIMENTAL
+	select MEDIA_TUNER_TEA5761 if !MEDIA_TUNER_CUSTOMISE && MEDIA_RADIO_SUPPORT
 	select MEDIA_TUNER_TEA5767 if !MEDIA_TUNER_CUSTOMISE && MEDIA_RADIO_SUPPORT
 	select MEDIA_TUNER_SIMPLE if !MEDIA_TUNER_CUSTOMISE
 	select MEDIA_TUNER_TDA9887 if !MEDIA_TUNER_CUSTOMISE
@@ -90,9 +90,8 @@ config MEDIA_TUNER_TDA9887
 	  analog IF demodulator.
 
 config MEDIA_TUNER_TEA5761
-	tristate "TEA 5761 radio tuner (EXPERIMENTAL)"
+	tristate "TEA 5761 radio tuner"
 	depends on MEDIA_SUPPORT && I2C
-	depends on EXPERIMENTAL
 	default m if MEDIA_TUNER_CUSTOMISE
 	help
 	  Say Y here to include support for the Philips TEA5761 radio tuner.
diff --git a/drivers/media/dvb/dvb-usb/Kconfig b/drivers/media/dvb/dvb-usb/Kconfig
index c216156..c1e9861 100644
--- a/drivers/media/dvb/dvb-usb/Kconfig
+++ b/drivers/media/dvb/dvb-usb/Kconfig
@@ -244,7 +244,7 @@ config DVB_USB_OPERA1
 
 config DVB_USB_AF9005
 	tristate "Afatech AF9005 DVB-T USB1.1 support"
-	depends on DVB_USB && EXPERIMENTAL
+	depends on DVB_USB
 	select MEDIA_TUNER_MT2060 if !MEDIA_TUNER_CUSTOMISE
 	select MEDIA_TUNER_QT1010 if !MEDIA_TUNER_CUSTOMISE
 	help
@@ -416,7 +416,7 @@ config DVB_USB_MXL111SF
 
 config DVB_USB_RTL28XXU
 	tristate "Realtek RTL28xxU DVB USB support"
-	depends on DVB_USB && EXPERIMENTAL
+	depends on DVB_USB
 	select DVB_RTL2830
 	select DVB_RTL2832
 	select MEDIA_TUNER_QT1010 if !MEDIA_TUNER_CUSTOMISE
diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index c128fac..27beae6 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -213,7 +213,7 @@ config VIDEO_CS53L32A
 
 config VIDEO_TLV320AIC23B
 	tristate "Texas Instruments TLV320AIC23B audio codec"
-	depends on VIDEO_V4L2 && I2C && EXPERIMENTAL
+	depends on VIDEO_V4L2 && I2C
 	---help---
 	  Support for the Texas Instruments TLV320AIC23B audio codec.
 
@@ -565,7 +565,7 @@ config VIDEO_SR030PC30
 
 config VIDEO_NOON010PC30
 	tristate "Siliconfile NOON010PC30 sensor support"
-	depends on I2C && VIDEO_V4L2 && EXPERIMENTAL && VIDEO_V4L2_SUBDEV_API
+	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
 	depends on MEDIA_CAMERA_SUPPORT
 	---help---
 	  This driver supports NOON010PC30 CIF camera from Siliconfile
@@ -698,7 +698,7 @@ config USB_ZR364XX
 
 config USB_STKWEBCAM
 	tristate "USB Syntek DC1125 Camera support"
-	depends on VIDEO_V4L2 && EXPERIMENTAL
+	depends on VIDEO_V4L2
 	---help---
 	  Say Y here if you want to use this type of camera.
 	  Supported devices are typically found in some Asus laptops,
@@ -1003,8 +1003,8 @@ config VIDEO_M32R_AR_M64278
 	  module will be called arv.
 
 config VIDEO_OMAP3
-	tristate "OMAP 3 Camera support (EXPERIMENTAL)"
-	depends on OMAP_IOVMM && VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API && ARCH_OMAP3 && EXPERIMENTAL
+	tristate "OMAP 3 Camera support"
+	depends on OMAP_IOVMM && VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API && ARCH_OMAP3
 	---help---
 	  Driver for an OMAP 3 camera controller.
 
@@ -1235,8 +1235,8 @@ config VIDEO_SAMSUNG_S5P_G2D
 	  2d graphics accelerator.
 
 config VIDEO_SAMSUNG_S5P_JPEG
-	tristate "Samsung S5P/Exynos4 JPEG codec driver (EXPERIMENTAL)"
-	depends on VIDEO_DEV && VIDEO_V4L2 && PLAT_S5P && EXPERIMENTAL
+	tristate "Samsung S5P/Exynos4 JPEG codec driver"
+	depends on VIDEO_DEV && VIDEO_V4L2 && PLAT_S5P
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
 	---help---
diff --git a/drivers/media/video/cx18/Kconfig b/drivers/media/video/cx18/Kconfig
index 53b3c77..8288092 100644
--- a/drivers/media/video/cx18/Kconfig
+++ b/drivers/media/video/cx18/Kconfig
@@ -1,6 +1,6 @@
 config VIDEO_CX18
 	tristate "Conexant cx23418 MPEG encoder support"
-	depends on VIDEO_V4L2 && DVB_CORE && PCI && I2C && EXPERIMENTAL
+	depends on VIDEO_V4L2 && DVB_CORE && PCI && I2C
 	select I2C_ALGOBIT
 	select VIDEOBUF_VMALLOC
 	depends on RC_CORE
@@ -25,7 +25,7 @@ config VIDEO_CX18
 
 config VIDEO_CX18_ALSA
 	tristate "Conexant 23418 DMA audio support"
-	depends on VIDEO_CX18 && SND && EXPERIMENTAL
+	depends on VIDEO_CX18 && SND
 	select SND_PCM
 	---help---
 	  This is a video4linux driver for direct (DMA) audio on
diff --git a/drivers/media/video/cx25821/Kconfig b/drivers/media/video/cx25821/Kconfig
index 5f6b542..4017c94 100644
--- a/drivers/media/video/cx25821/Kconfig
+++ b/drivers/media/video/cx25821/Kconfig
@@ -18,7 +18,7 @@ config VIDEO_CX25821
 
 config VIDEO_CX25821_ALSA
 	tristate "Conexant 25821 DMA audio support"
-	depends on VIDEO_CX25821 && SND && EXPERIMENTAL
+	depends on VIDEO_CX25821 && SND
 	select SND_PCM
 	---help---
 	  This is a video4linux driver for direct (DMA) audio on
diff --git a/drivers/media/video/pvrusb2/Kconfig b/drivers/media/video/pvrusb2/Kconfig
index 25e412e..e3abaa8 100644
--- a/drivers/media/video/pvrusb2/Kconfig
+++ b/drivers/media/video/pvrusb2/Kconfig
@@ -17,9 +17,9 @@ config VIDEO_PVRUSB2
 	  module will be called pvrusb2
 
 config VIDEO_PVRUSB2_SYSFS
-	bool "pvrusb2 sysfs support (EXPERIMENTAL)"
+	bool "pvrusb2 sysfs support"
 	default y
-	depends on VIDEO_PVRUSB2 && SYSFS && EXPERIMENTAL
+	depends on VIDEO_PVRUSB2 && SYSFS
 	---help---
 	  This option enables the operation of a sysfs based
 	  interface for query and control of the pvrusb2 driver.
@@ -33,9 +33,9 @@ config VIDEO_PVRUSB2_SYSFS
 	  Note: This feature is experimental and subject to change.
 
 config VIDEO_PVRUSB2_DVB
-	bool "pvrusb2 ATSC/DVB support (EXPERIMENTAL)"
+	bool "pvrusb2 ATSC/DVB support"
 	default y
-	depends on VIDEO_PVRUSB2 && DVB_CORE && EXPERIMENTAL
+	depends on VIDEO_PVRUSB2 && DVB_CORE
 	select DVB_LGDT330X if !DVB_FE_CUSTOMISE
 	select DVB_S5H1409 if !DVB_FE_CUSTOMISE
 	select DVB_S5H1411 if !DVB_FE_CUSTOMISE
diff --git a/drivers/media/video/s5p-fimc/Kconfig b/drivers/media/video/s5p-fimc/Kconfig
index a564f7e..0310f7c 100644
--- a/drivers/media/video/s5p-fimc/Kconfig
+++ b/drivers/media/video/s5p-fimc/Kconfig
@@ -2,7 +2,6 @@
 config VIDEO_SAMSUNG_S5P_FIMC
 	bool "Samsung S5P/EXYNOS SoC camera interface driver (experimental)"
 	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && PLAT_S5P && PM_RUNTIME
-	depends on EXPERIMENTAL
 	help
 	  Say Y here to enable camera host interface devices for
 	  Samsung S5P and EXYNOS SoC series.
diff --git a/drivers/media/video/s5p-tv/Kconfig b/drivers/media/video/s5p-tv/Kconfig
index f248b28..119cffc 100644
--- a/drivers/media/video/s5p-tv/Kconfig
+++ b/drivers/media/video/s5p-tv/Kconfig
@@ -9,7 +9,6 @@
 config VIDEO_SAMSUNG_S5P_TV
 	bool "Samsung TV driver for S5P platform (experimental)"
 	depends on PLAT_S5P && PM_RUNTIME
-	depends on EXPERIMENTAL
 	default n
 	---help---
 	  Say Y here to enable selecting the TV output devices for
diff --git a/drivers/media/video/zoran/Kconfig b/drivers/media/video/zoran/Kconfig
index fd4120e..215153b 100644
--- a/drivers/media/video/zoran/Kconfig
+++ b/drivers/media/video/zoran/Kconfig
@@ -65,8 +65,8 @@ config VIDEO_ZORAN_LML33R10
 	  card.
 
 config VIDEO_ZORAN_AVS6EYES
-	tristate "AverMedia 6 Eyes support (EXPERIMENTAL)"
-	depends on VIDEO_ZORAN_ZR36060 && EXPERIMENTAL
+	tristate "AverMedia 6 Eyes support"
+	depends on VIDEO_ZORAN_ZR36060
 	select VIDEO_BT856 if VIDEO_HELPER_CHIPS_AUTO
 	select VIDEO_BT866 if VIDEO_HELPER_CHIPS_AUTO
 	select VIDEO_KS0127 if VIDEO_HELPER_CHIPS_AUTO
diff --git a/drivers/memstick/Kconfig b/drivers/memstick/Kconfig
index f0ca41c..1314605 100644
--- a/drivers/memstick/Kconfig
+++ b/drivers/memstick/Kconfig
@@ -3,7 +3,7 @@
 #
 
 menuconfig MEMSTICK
-	tristate "Sony MemoryStick card support (EXPERIMENTAL)"
+	tristate "Sony MemoryStick card support"
 	help
 	  Sony MemoryStick is a proprietary storage/extension card protocol.
 
diff --git a/drivers/memstick/host/Kconfig b/drivers/memstick/host/Kconfig
index cc0997a..0e6a907 100644
--- a/drivers/memstick/host/Kconfig
+++ b/drivers/memstick/host/Kconfig
@@ -5,8 +5,8 @@
 comment "MemoryStick Host Controller Drivers"
 
 config MEMSTICK_TIFM_MS
-	tristate "TI Flash Media MemoryStick Interface support  (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && PCI
+	tristate "TI Flash Media MemoryStick Interface support "
+	depends on PCI
 	select TIFM_CORE
 	help
 	  Say Y here if you want to be able to access MemoryStick cards with
@@ -21,8 +21,8 @@ config MEMSTICK_TIFM_MS
 	  module will be called tifm_ms.
 
 config MEMSTICK_JMICRON_38X
-	tristate "JMicron JMB38X MemoryStick interface support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && PCI
+	tristate "JMicron JMB38X MemoryStick interface support"
+	depends on PCI
 
 	help
 	  Say Y here if you want to be able to access MemoryStick cards with
@@ -32,8 +32,8 @@ config MEMSTICK_JMICRON_38X
 	  module will be called jmb38x_ms.
 
 config MEMSTICK_R592
-	tristate "Ricoh R5C592 MemoryStick interface support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && PCI
+	tristate "Ricoh R5C592 MemoryStick interface support"
+	depends on PCI
 
 	help
 	  Say Y here if you want to be able to access MemoryStick cards with
diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 98a442d..99c7335 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -105,7 +105,7 @@ config ATMEL_TCB_CLKSRC_BLOCK
 
 config IBM_ASM
 	tristate "Device driver for IBM RSA service processor"
-	depends on X86 && PCI && INPUT && EXPERIMENTAL
+	depends on X86 && PCI && INPUT
 	---help---
 	  This option enables device driver support for in-band access to the
 	  IBM RSA (Condor) service processor in eServer xSeries systems.
@@ -162,8 +162,8 @@ config SGI_IOC4
 	  Otherwise say N.
 
 config TIFM_CORE
-	tristate "TI Flash Media interface support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && PCI
+	tristate "TI Flash Media interface support"
+	depends on PCI
 	help
 	  If you want support for Texas Instruments(R) Flash Media adapters
 	  you should select this option and then also choose an appropriate
@@ -178,8 +178,8 @@ config TIFM_CORE
 	  be called tifm_core.
 
 config TIFM_7XX1
-	tristate "TI Flash Media PCI74xx/PCI76xx host adapter support (EXPERIMENTAL)"
-	depends on PCI && TIFM_CORE && EXPERIMENTAL
+	tristate "TI Flash Media PCI74xx/PCI76xx host adapter support"
+	depends on PCI && TIFM_CORE
 	default TIFM_CORE
 	help
 	  This option enables support for Texas Instruments(R) PCI74xx and
@@ -192,7 +192,7 @@ config TIFM_7XX1
 
 config ICS932S401
 	tristate "Integrated Circuits ICS932S401"
-	depends on I2C && EXPERIMENTAL
+	depends on I2C
 	help
 	  If you say yes here you get support for the Integrated Circuits
 	  ICS932S401 clock control chips.
@@ -398,7 +398,7 @@ config EP93XX_PWM
 
 config DS1682
 	tristate "Dallas DS1682 Total Elapsed Time Recorder with Alarm"
-	depends on I2C && EXPERIMENTAL
+	depends on I2C
 	help
 	  If you say yes here you get support for Dallas Semiconductor
 	  DS1682 Total Elapsed Time Recorder.
diff --git a/drivers/misc/c2port/Kconfig b/drivers/misc/c2port/Kconfig
index 33ee834..0dd690e 100644
--- a/drivers/misc/c2port/Kconfig
+++ b/drivers/misc/c2port/Kconfig
@@ -3,8 +3,7 @@
 #
 
 menuconfig C2PORT
-	tristate "Silicon Labs C2 port support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	tristate "Silicon Labs C2 port support"
 	default n
 	help
 	  This option enables support for Silicon Labs C2 port used to
@@ -22,7 +21,7 @@ menuconfig C2PORT
 if C2PORT
 
 config C2PORT_DURAMAR_2150
-	tristate "C2 port support for Eurotech's Duramar 2150 (EXPERIMENTAL)"
+	tristate "C2 port support for Eurotech's Duramar 2150"
 	depends on X86
 	default n
 	help
diff --git a/drivers/misc/eeprom/Kconfig b/drivers/misc/eeprom/Kconfig
index 701edf6..c9e695e 100644
--- a/drivers/misc/eeprom/Kconfig
+++ b/drivers/misc/eeprom/Kconfig
@@ -50,7 +50,7 @@ config EEPROM_LEGACY
 
 config EEPROM_MAX6875
 	tristate "Maxim MAX6874/5 power supply supervisor"
-	depends on I2C && EXPERIMENTAL
+	depends on I2C
 	help
 	  If you say yes here you get read-only support for the user EEPROM of
 	  the Maxim MAX6874/5 EEPROM-programmable, quad power-supply
diff --git a/drivers/misc/mei/Kconfig b/drivers/misc/mei/Kconfig
index 47d78a7..5a79ccd 100644
--- a/drivers/misc/mei/Kconfig
+++ b/drivers/misc/mei/Kconfig
@@ -1,6 +1,6 @@
 config INTEL_MEI
 	tristate "Intel Management Engine Interface (Intel MEI)"
-	depends on X86 && PCI && EXPERIMENTAL && WATCHDOG_CORE
+	depends on X86 && PCI && WATCHDOG_CORE
 	help
 	  The Intel Management Engine (Intel ME) provides Manageability,
 	  Security and Media services for system containing Intel chipsets.
diff --git a/drivers/mmc/core/Kconfig b/drivers/mmc/core/Kconfig
index ef10387..269d072 100644
--- a/drivers/mmc/core/Kconfig
+++ b/drivers/mmc/core/Kconfig
@@ -18,8 +18,7 @@ config MMC_UNSAFE_RESUME
 	  module parameter "removable=0" or "removable=1".
 
 config MMC_CLKGATE
-	bool "MMC host clock gating (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	bool "MMC host clock gating"
 	help
 	  This will attempt to aggressively gate the clock to the MMC card.
 	  This is done to save power due to gating off the logic and bus
diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
index aa131b3..86a8638 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -69,7 +69,7 @@ config MMC_SDHCI_PCI
 	  If unsure, say N.
 
 config MMC_RICOH_MMC
-	bool "Ricoh MMC Controller Disabler  (EXPERIMENTAL)"
+	bool "Ricoh MMC Controller Disabler "
 	depends on MMC_SDHCI_PCI
 	help
 	  This adds a pci quirk to disable Ricoh MMC Controller. This
@@ -174,9 +174,6 @@ config MMC_SDHCI_S3C
 	  often referrered to as the HSMMC block in some of the Samsung S3C
 	  range of SoC.
 
-	  Note, due to the problems with DMA, the DMA support is only
-	  available with CONFIG_EXPERIMENTAL is selected.
-
 	  If you have a controller with this interface, say Y or M here.
 
 	  If unsure, say N.
@@ -221,7 +218,7 @@ config MMC_SDHCI_SPEAR
 
 config MMC_SDHCI_S3C_DMA
 	bool "DMA support on S3C SDHCI"
-	depends on MMC_SDHCI_S3C && EXPERIMENTAL
+	depends on MMC_SDHCI_S3C
 	help
 	  Enable DMA support on the Samsung S3C SDHCI glue. The DMA
 	  has proved to be problematic if the controller encounters
@@ -338,8 +335,8 @@ config MMC_MXS
 	  If unsure, say N.
 
 config MMC_TIFM_SD
-	tristate "TI Flash Media MMC/SD Interface support  (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && PCI
+	tristate "TI Flash Media MMC/SD Interface support "
+	depends on PCI
 	select TIFM_CORE
 	help
 	  Say Y here if you want to be able to access MMC/SD cards with
@@ -418,8 +415,7 @@ config MMC_S3C_PIO
 	  the S3C MCI driver.
 
 config MMC_S3C_DMA
-	bool "Use DMA transfers only (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	bool "Use DMA transfers only"
 	help
 	  Use DMA to transfer data between memory and the hardare.
 
@@ -428,7 +424,7 @@ config MMC_S3C_DMA
 	  option is useful.
 
 config MMC_S3C_PIODMA
-	bool "Support for both PIO and DMA (EXPERIMENTAL)"
+	bool "Support for both PIO and DMA"
 	help
 	  Compile both the PIO and DMA transfer routines into the
 	  driver and let the platform select at run-time which one
@@ -439,8 +435,8 @@ config MMC_S3C_PIODMA
 endchoice
 
 config MMC_SDRICOH_CS
-	tristate "MMC/SD driver for Ricoh Bay1Controllers (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && PCI && PCMCIA
+	tristate "MMC/SD driver for Ricoh Bay1Controllers"
+	depends on PCI && PCMCIA
 	help
 	  Say Y here if your Notebook reports a Ricoh Bay1Controller PCMCIA
 	  card whenever you insert a MMC or SD card into the card slot.
diff --git a/drivers/mtd/Kconfig b/drivers/mtd/Kconfig
index 27143e0..f5e3e33 100644
--- a/drivers/mtd/Kconfig
+++ b/drivers/mtd/Kconfig
@@ -284,7 +284,7 @@ config SSFDC
 
 config SM_FTL
 	tristate "SmartMedia/xD new translation layer"
-	depends on EXPERIMENTAL && BLOCK
+	depends on BLOCK
 	select MTD_BLKDEVS
 	select MTD_NAND_ECC
 	help
diff --git a/drivers/mtd/chips/Kconfig b/drivers/mtd/chips/Kconfig
index b1e3c26..42795e4 100644
--- a/drivers/mtd/chips/Kconfig
+++ b/drivers/mtd/chips/Kconfig
@@ -232,7 +232,7 @@ config MTD_ABSENT
 
 config MTD_XIP
 	bool "XIP aware MTD support"
-	depends on !SMP && (MTD_CFI_INTELEXT || MTD_CFI_AMDSTD) && EXPERIMENTAL && ARCH_MTD_XIP
+	depends on !SMP && (MTD_CFI_INTELEXT || MTD_CFI_AMDSTD) && ARCH_MTD_XIP
 	default y if XIP_KERNEL
 	help
 	  This allows MTD support to work with flash memory which is also
diff --git a/drivers/mtd/devices/Kconfig b/drivers/mtd/devices/Kconfig
index 4cdb2af..70f26cc 100644
--- a/drivers/mtd/devices/Kconfig
+++ b/drivers/mtd/devices/Kconfig
@@ -52,7 +52,7 @@ config MTD_MS02NV
 
 config MTD_DATAFLASH
 	tristate "Support for AT45xxx DataFlash"
-	depends on SPI_MASTER && EXPERIMENTAL
+	depends on SPI_MASTER
 	help
 	  This enables access to AT45xxx DataFlash chips, using SPI.
 	  Sometimes DataFlash chips are packaged inside MMC-format
@@ -81,7 +81,7 @@ config MTD_DATAFLASH_OTP
 
 config MTD_M25P80
 	tristate "Support most SPI Flash chips (AT26DF, M25P, W25X, ...)"
-	depends on SPI_MASTER && EXPERIMENTAL
+	depends on SPI_MASTER
 	help
 	  This enables access to most modern SPI flash chips, used for
 	  program and data storage.   Series supported include Atmel AT26DF,
diff --git a/drivers/mtd/nand/Kconfig b/drivers/mtd/nand/Kconfig
index 8ca4176..9beabdc 100644
--- a/drivers/mtd/nand/Kconfig
+++ b/drivers/mtd/nand/Kconfig
@@ -284,8 +284,7 @@ config MTD_NAND_BCM_UMI_HWCS
 	  This should only be used if you know the external NAND CS can toggle.
 
 config MTD_NAND_DISKONCHIP
-	tristate "DiskOnChip 2000, Millennium and Millennium Plus (NAND reimplementation) (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	tristate "DiskOnChip 2000, Millennium and Millennium Plus (NAND reimplementation)"
 	depends on HAS_IOMEM
 	select REED_SOLOMON
 	select REED_SOLOMON_DEC16
@@ -355,8 +354,7 @@ config MTD_NAND_DISKONCHIP_BBTWRITE
 	  parameter "inftl_bbt_write=1".
 
 config MTD_NAND_DOCG4
-	tristate "Support for DiskOnChip G4 (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	tristate "Support for DiskOnChip G4"
 	select BCH
 	select BITREVERSE
 	help
diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 0c2bd80..c75f6c7 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -125,8 +125,7 @@ config IFB
 source "drivers/net/team/Kconfig"
 
 config MACVLAN
-	tristate "MAC-VLAN support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	tristate "MAC-VLAN support"
 	---help---
 	  This allows one to create virtual interfaces that map packets to
 	  or from specific MAC addresses to a particular interface.
@@ -140,7 +139,7 @@ config MACVLAN
 	  will be called macvlan.
 
 config MACVTAP
-	tristate "MAC-VLAN based tap driver (EXPERIMENTAL)"
+	tristate "MAC-VLAN based tap driver"
 	depends on MACVLAN
 	help
 	  This adds a specialized tap character device driver that is based
@@ -223,8 +222,8 @@ config VETH
 	  versa.
 
 config VIRTIO_NET
-	tristate "Virtio network driver (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && VIRTIO
+	tristate "Virtio network driver"
+	depends on VIRTIO
 	---help---
 	  This is the virtual network driver for virtio.  It can be used with
 	  lguest or QEMU based VMMs (like KVM or Xen).  Say Y or M.
diff --git a/drivers/net/ethernet/8390/Kconfig b/drivers/net/ethernet/8390/Kconfig
index e1219e0..8e15bd4 100644
--- a/drivers/net/ethernet/8390/Kconfig
+++ b/drivers/net/ethernet/8390/Kconfig
@@ -5,10 +5,7 @@
 config NET_VENDOR_8390
 	bool "National Semi-conductor 8390 devices"
 	default y
-	depends on NET_VENDOR_NATSEMI && (AMIGA_PCMCIA || PCI || SUPERH || \
-		   ISA || MCA || EISA || MAC || M32R || MACH_TX49XX || \
-		   MCA_LEGACY || H8300 || ARM || MIPS || ZORRO || PCMCIA || \
-		   EXPERIMENTAL)
+	depends on NET_VENDOR_NATSEMI
 	---help---
 	  If you have a network (Ethernet) card belonging to this class, say Y
 	  and read the Ethernet-HOWTO, available from
@@ -34,8 +31,8 @@ config EL2
 	  will be called 3c503.
 
 config AC3200
-	tristate "Ansel Communications EISA 3200 support (EXPERIMENTAL)"
-	depends on PCI && (ISA || EISA) && EXPERIMENTAL
+	tristate "Ansel Communications EISA 3200 support"
+	depends on PCI && (ISA || EISA)
 	select CRC32
 	---help---
 	  If you have a network (Ethernet) card of this type, say Y and read
@@ -87,8 +84,8 @@ config E2100
 	  will be called e2100.
 
 config ES3210
-	tristate "Racal-Interlan EISA ES3210 support (EXPERIMENTAL)"
-	depends on PCI && EISA && EXPERIMENTAL
+	tristate "Racal-Interlan EISA ES3210 support"
+	depends on PCI && EISA
 	select CRC32
 	---help---
 	  If you have a network (Ethernet) card of this type, say Y and read
@@ -141,8 +138,8 @@ config ARM_ETHERH
 	  should say Y to this option if you wish to use it with Linux.
 
 config LNE390
-	tristate "Mylex EISA LNE390A/B support (EXPERIMENTAL)"
-	depends on PCI && EISA && EXPERIMENTAL
+	tristate "Mylex EISA LNE390A/B support"
+	depends on PCI && EISA
 	select CRC32
 	---help---
 	  If you have a network (Ethernet) card of this type, say Y and read
@@ -227,8 +224,8 @@ config APNE
 	  will be called apne.
 
 config NE3210
-	tristate "Novell/Eagle/Microdyne NE3210 EISA support (EXPERIMENTAL)"
-	depends on PCI && EISA && EXPERIMENTAL
+	tristate "Novell/Eagle/Microdyne NE3210 EISA support"
+	depends on PCI && EISA
 	select CRC32
 	---help---
 	  If you have a network (Ethernet) card of this type, say Y and read
diff --git a/drivers/net/ethernet/atheros/Kconfig b/drivers/net/ethernet/atheros/Kconfig
index 1ed886d..36d6abd 100644
--- a/drivers/net/ethernet/atheros/Kconfig
+++ b/drivers/net/ethernet/atheros/Kconfig
@@ -44,8 +44,8 @@ config ATL1
 	  will be called atl1.
 
 config ATL1E
-	tristate "Atheros L1E Gigabit Ethernet support (EXPERIMENTAL)"
-	depends on PCI && EXPERIMENTAL
+	tristate "Atheros L1E Gigabit Ethernet support"
+	depends on PCI
 	select CRC32
 	select NET_CORE
 	select MII
@@ -56,8 +56,8 @@ config ATL1E
 	  will be called atl1e.
 
 config ATL1C
-	tristate "Atheros L1C Gigabit Ethernet support (EXPERIMENTAL)"
-	depends on PCI && EXPERIMENTAL
+	tristate "Atheros L1C Gigabit Ethernet support"
+	depends on PCI
 	select CRC32
 	select NET_CORE
 	select MII
diff --git a/drivers/net/ethernet/dec/tulip/Kconfig b/drivers/net/ethernet/dec/tulip/Kconfig
index 1203be0..0c37fb2 100644
--- a/drivers/net/ethernet/dec/tulip/Kconfig
+++ b/drivers/net/ethernet/dec/tulip/Kconfig
@@ -57,8 +57,8 @@ config TULIP
 	  be called tulip.
 
 config TULIP_MWI
-	bool "New bus configuration (EXPERIMENTAL)"
-	depends on TULIP && EXPERIMENTAL
+	bool "New bus configuration"
+	depends on TULIP
 	---help---
 	  This configures your Tulip card specifically for the card and
 	  system cache line size type you are using.
diff --git a/drivers/net/ethernet/fujitsu/Kconfig b/drivers/net/ethernet/fujitsu/Kconfig
index dffee9d..80926c1 100644
--- a/drivers/net/ethernet/fujitsu/Kconfig
+++ b/drivers/net/ethernet/fujitsu/Kconfig
@@ -5,7 +5,7 @@
 config NET_VENDOR_FUJITSU
 	bool "Fujitsu devices"
 	default y
-	depends on ISA || PCMCIA || ((ISA || MCA_LEGACY) && EXPERIMENTAL)
+	depends on ISA || PCMCIA || MCA_LEGACY
 	---help---
 	  If you have a network (Ethernet) card belonging to this class, say Y
 	  and read the Ethernet-HOWTO, available from
@@ -18,8 +18,8 @@ config NET_VENDOR_FUJITSU
 if NET_VENDOR_FUJITSU
 
 config AT1700
-	tristate "AT1700/1720 support (EXPERIMENTAL)"
-	depends on (ISA || MCA_LEGACY) && EXPERIMENTAL
+	tristate "AT1700/1720 support"
+	depends on (ISA || MCA_LEGACY)
 	select CRC32
 	---help---
 	  If you have a network (Ethernet) card of this type, say Y and read
diff --git a/drivers/net/ethernet/i825xx/Kconfig b/drivers/net/ethernet/i825xx/Kconfig
index fed5080..e37274f 100644
--- a/drivers/net/ethernet/i825xx/Kconfig
+++ b/drivers/net/ethernet/i825xx/Kconfig
@@ -5,9 +5,7 @@
 config NET_VENDOR_I825XX
 	bool "Intel (82586/82593/82596) devices"
 	default y
-	depends on NET_VENDOR_INTEL && (ISA || ISA_DMA_API || ARM || \
-		   ARCH_ACORN || MCA || MCA_LEGACY || SNI_RM || SUN3 || \
-		   GSC || BVME6000 || MVME16x || EXPERIMENTAL)
+	depends on NET_VENDOR_INTEL
 	---help---
 	  If you have a network (Ethernet) card belonging to this class, say Y
 	  and read the Ethernet-HOWTO, available from
@@ -33,8 +31,8 @@ config ELPLUS
 	  will be called 3c505.
 
 config EL16
-	tristate "3c507 \"EtherLink 16\" support (EXPERIMENTAL)"
-	depends on ISA && EXPERIMENTAL
+	tristate "3c507 \"EtherLink 16\" support"
+	depends on ISA
 	---help---
 	  If you have a network (Ethernet) card of this type, say Y and read
 	  the Ethernet-HOWTO, available from
@@ -149,8 +147,8 @@ config SUN3_82586
 	  VME boards.
 
 config ZNET
-	tristate "Zenith Z-Note support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && ISA_DMA_API
+	tristate "Zenith Z-Note support"
+	depends on ISA_DMA_API
 	---help---
 	  The Zenith Z-Note notebook computer has a built-in network
 	  (Ethernet) card, and this is the Linux driver for it. Note that the
diff --git a/drivers/net/ethernet/icplus/Kconfig b/drivers/net/ethernet/icplus/Kconfig
index 3aff81d..5119ef1 100644
--- a/drivers/net/ethernet/icplus/Kconfig
+++ b/drivers/net/ethernet/icplus/Kconfig
@@ -4,7 +4,7 @@
 
 config IP1000
 	tristate "IP1000 Gigabit Ethernet support"
-	depends on PCI && EXPERIMENTAL
+	depends on PCI
 	select NET_CORE
 	select MII
 	---help---
diff --git a/drivers/net/ethernet/intel/Kconfig b/drivers/net/ethernet/intel/Kconfig
index 0cafe4f..ec45200 100644
--- a/drivers/net/ethernet/intel/Kconfig
+++ b/drivers/net/ethernet/intel/Kconfig
@@ -5,11 +5,6 @@
 config NET_VENDOR_INTEL
 	bool "Intel devices"
 	default y
-	depends on PCI || PCI_MSI || ISA || ISA_DMA_API || ARM || \
-		   ARCH_ACORN || MCA || MCA_LEGACY || SNI_RM || SUN3 || \
-		   GSC || BVME6000 || MVME16x || \
-		   (ARM && ARCH_IXP4XX && IXP4XX_NPE && IXP4XX_QMGR) || \
-		   EXPERIMENTAL
 	---help---
 	  If you have a network (Ethernet) card belonging to this class, say Y
 	  and read the Ethernet-HOWTO, available from
@@ -123,7 +118,7 @@ config IGB_DCA
 config IGB_PTP
 	bool "PTP Hardware Clock (PHC)"
 	default n
-	depends on IGB && EXPERIMENTAL
+	depends on IGB
 	select PPS
 	select PTP_1588_CLOCK
 	---help---
@@ -225,7 +220,7 @@ config IXGBE_DCB
 config IXGBE_PTP
 	bool "PTP Clock Support"
 	default n
-	depends on IXGBE && EXPERIMENTAL
+	depends on IXGBE
 	select PPS
 	select PTP_1588_CLOCK
 	---help---
diff --git a/drivers/net/ethernet/microchip/Kconfig b/drivers/net/ethernet/microchip/Kconfig
index 8163fd0..afaf0c0 100644
--- a/drivers/net/ethernet/microchip/Kconfig
+++ b/drivers/net/ethernet/microchip/Kconfig
@@ -5,7 +5,7 @@
 config NET_VENDOR_MICROCHIP
 	bool "Microchip devices"
 	default y
-	depends on SPI && EXPERIMENTAL
+	depends on SPI
 	---help---
 	  If you have a network (Ethernet) card belonging to this class, say Y
 	  and read the Ethernet-HOWTO, available from
@@ -20,7 +20,7 @@ if NET_VENDOR_MICROCHIP
 
 config ENC28J60
 	tristate "ENC28J60 support"
-	depends on SPI && EXPERIMENTAL
+	depends on SPI
 	select CRC32
 	---help---
 	  Support for the Microchip EN28J60 ethernet chip.
diff --git a/drivers/net/ethernet/natsemi/Kconfig b/drivers/net/ethernet/natsemi/Kconfig
index f157334..a100860 100644
--- a/drivers/net/ethernet/natsemi/Kconfig
+++ b/drivers/net/ethernet/natsemi/Kconfig
@@ -5,9 +5,6 @@
 config NET_VENDOR_NATSEMI
 	bool "National Semi-conductor devices"
 	default y
-	depends on AMIGA_PCMCIA || ARM || EISA || EXPERIMENTAL || H8300 || \
-		   ISA || M32R || MAC || MACH_JAZZ || MACH_TX49XX || MIPS || \
-		   PCI || PCMCIA || SUPERH || XTENSA_PLATFORM_XT2000 || ZORRO
 	---help---
 	  If you have a network (Ethernet) card belonging to this class, say Y
 	  and read the Ethernet-HOWTO, available from
diff --git a/drivers/net/ethernet/packetengines/Kconfig b/drivers/net/ethernet/packetengines/Kconfig
index 8f29feb..cbbeca3 100644
--- a/drivers/net/ethernet/packetengines/Kconfig
+++ b/drivers/net/ethernet/packetengines/Kconfig
@@ -32,8 +32,8 @@ config HAMACHI
 	  called hamachi.
 
 config YELLOWFIN
-	tristate "Packet Engines Yellowfin Gigabit-NIC support (EXPERIMENTAL)"
-	depends on PCI && EXPERIMENTAL
+	tristate "Packet Engines Yellowfin Gigabit-NIC support"
+	depends on PCI
 	select CRC32
 	---help---
 	  Say Y here if you have a Packet Engines G-NIC PCI Gigabit Ethernet
diff --git a/drivers/net/ethernet/racal/Kconfig b/drivers/net/ethernet/racal/Kconfig
index 01969e0..53c6af1 100644
--- a/drivers/net/ethernet/racal/Kconfig
+++ b/drivers/net/ethernet/racal/Kconfig
@@ -19,8 +19,8 @@ config NET_VENDOR_RACAL
 if NET_VENDOR_RACAL
 
 config NI5010
-	tristate "NI5010 support (EXPERIMENTAL)"
-	depends on ISA && EXPERIMENTAL && BROKEN_ON_SMP
+	tristate "NI5010 support"
+	depends on ISA && BROKEN_ON_SMP
 	---help---
 	  If you have a network (Ethernet) card of this type, say Y and read
 	  the Ethernet-HOWTO, available from
diff --git a/drivers/net/ethernet/realtek/Kconfig b/drivers/net/ethernet/realtek/Kconfig
index 5821966..783fa8b 100644
--- a/drivers/net/ethernet/realtek/Kconfig
+++ b/drivers/net/ethernet/realtek/Kconfig
@@ -34,8 +34,8 @@ config ATP
 	  will be called atp.
 
 config 8139CP
-	tristate "RealTek RTL-8139 C+ PCI Fast Ethernet Adapter support (EXPERIMENTAL)"
-	depends on PCI && EXPERIMENTAL
+	tristate "RealTek RTL-8139 C+ PCI Fast Ethernet Adapter support"
+	depends on PCI
 	select CRC32
 	select NET_CORE
 	select MII
diff --git a/drivers/net/ethernet/seeq/Kconfig b/drivers/net/ethernet/seeq/Kconfig
index 29f1853..2366fa0 100644
--- a/drivers/net/ethernet/seeq/Kconfig
+++ b/drivers/net/ethernet/seeq/Kconfig
@@ -6,7 +6,6 @@ config NET_VENDOR_SEEQ
 	bool "SEEQ devices"
 	default y
 	depends on HAS_IOMEM
-	depends on (ARM && ARCH_ACORN) || SGI_HAS_SEEQ || EXPERIMENTAL
 	---help---
 	  If you have a network (Ethernet) card belonging to this class, say Y
 	  and read the Ethernet-HOWTO, available from
@@ -27,8 +26,7 @@ config ARM_ETHER3
 	  should say Y to this option if you wish to use it with Linux.
 
 config SEEQ8005
-	tristate "SEEQ8005 support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	tristate "SEEQ8005 support"
 	---help---
 	  This is a driver for the SEEQ 8005 network (Ethernet) card.  If this
 	  is for you, read the Ethernet-HOWTO, available from
diff --git a/drivers/net/ethernet/silan/Kconfig b/drivers/net/ethernet/silan/Kconfig
index ae1ce17..3409b3f 100644
--- a/drivers/net/ethernet/silan/Kconfig
+++ b/drivers/net/ethernet/silan/Kconfig
@@ -5,7 +5,7 @@
 config NET_VENDOR_SILAN
 	bool "Silan devices"
 	default y
-	depends on PCI && EXPERIMENTAL
+	depends on PCI
 	---help---
 	  If you have a network (Ethernet) card belonging to this class, say Y
 	  and read the Ethernet-HOWTO, available from
@@ -19,8 +19,8 @@ config NET_VENDOR_SILAN
 if NET_VENDOR_SILAN
 
 config SC92031
-	tristate "Silan SC92031 PCI Fast Ethernet Adapter driver (EXPERIMENTAL)"
-	depends on PCI && EXPERIMENTAL
+	tristate "Silan SC92031 PCI Fast Ethernet Adapter driver"
+	depends on PCI
 	select CRC32
 	---help---
 	  This is a driver for the Fast Ethernet PCI network cards based on
diff --git a/drivers/net/ethernet/stmicro/stmmac/Kconfig b/drivers/net/ethernet/stmicro/stmmac/Kconfig
index 9f44827..24bc663 100644
--- a/drivers/net/ethernet/stmicro/stmmac/Kconfig
+++ b/drivers/net/ethernet/stmicro/stmmac/Kconfig
@@ -26,8 +26,8 @@ config STMMAC_PLATFORM
 	  If unsure, say N.
 
 config STMMAC_PCI
-	bool "STMMAC PCI bus support (EXPERIMENTAL)"
-	depends on STMMAC_ETH && PCI && EXPERIMENTAL
+	bool "STMMAC PCI bus support"
+	depends on STMMAC_ETH && PCI
 	---help---
 	  This is to select the Synopsys DWMAC available on PCI devices,
 	  if you have a controller with this interface, say Y or M here.
diff --git a/drivers/net/ethernet/sun/Kconfig b/drivers/net/ethernet/sun/Kconfig
index 57bfd85..ae3a355 100644
--- a/drivers/net/ethernet/sun/Kconfig
+++ b/drivers/net/ethernet/sun/Kconfig
@@ -32,8 +32,8 @@ config HAPPYMEAL
 	  will be called sunhme.
 
 config SUNBMAC
-	tristate "Sun BigMAC 10/100baseT support (EXPERIMENTAL)"
-	depends on SBUS && EXPERIMENTAL
+	tristate "Sun BigMAC 10/100baseT support"
+	depends on SBUS
 	select CRC32
 	---help---
 	  This driver supports the "be" interface available as an Sbus option.
diff --git a/drivers/net/ethernet/ti/Kconfig b/drivers/net/ethernet/ti/Kconfig
index 1b173a6..b6ff548 100644
--- a/drivers/net/ethernet/ti/Kconfig
+++ b/drivers/net/ethernet/ti/Kconfig
@@ -79,8 +79,8 @@ config TLAN
 	  Please email feedback to <torben.mathiasen@compaq.com>.
 
 config CPMAC
-	tristate "TI AR7 CPMAC Ethernet support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && AR7
+	tristate "TI AR7 CPMAC Ethernet support"
+	depends on AR7
 	select PHYLIB
 	---help---
 	  TI AR7 CPMAC Ethernet support
diff --git a/drivers/net/hippi/Kconfig b/drivers/net/hippi/Kconfig
index 95eb34f..f71515d 100644
--- a/drivers/net/hippi/Kconfig
+++ b/drivers/net/hippi/Kconfig
@@ -3,8 +3,8 @@
 #
 
 config HIPPI
-	bool "HIPPI driver support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && INET && PCI
+	bool "HIPPI driver support"
+	depends on INET && PCI
 	---help---
 	  HIgh Performance Parallel Interface (HIPPI) is a 800Mbit/sec and
 	  1600Mbit/sec dual-simplex switched or point-to-point network. HIPPI
@@ -18,7 +18,7 @@ config HIPPI
 if HIPPI
 
 config ROADRUNNER
-	tristate "Essential RoadRunner HIPPI PCI adapter support (EXPERIMENTAL)"
+	tristate "Essential RoadRunner HIPPI PCI adapter support"
 	depends on PCI
 	---help---
 	  Say Y here if this is your PCI HIPPI network card.
@@ -27,7 +27,7 @@ config ROADRUNNER
 	  will be called rrunner.  If unsure, say N.
 
 config ROADRUNNER_LARGE_RINGS
-	bool "Use large TX/RX rings (EXPERIMENTAL)"
+	bool "Use large TX/RX rings"
 	depends on ROADRUNNER
 	---help---
 	  If you say Y here, the RoadRunner driver will preallocate up to 2 MB
diff --git a/drivers/net/irda/Kconfig b/drivers/net/irda/Kconfig
index 5952054..59e9d9e 100644
--- a/drivers/net/irda/Kconfig
+++ b/drivers/net/irda/Kconfig
@@ -140,7 +140,7 @@ config LITELINK_DONGLE
 
 config MA600_DONGLE
 	tristate "Mobile Action MA600 dongle"
-	depends on IRTTY_SIR && DONGLE && IRDA && EXPERIMENTAL
+	depends on IRTTY_SIR && DONGLE && IRDA
 	help
 	  Say Y here if you want to build support for the Mobile Action MA600
 	  dongle.  To compile it as a module, choose M here. The MA600 dongle
@@ -153,7 +153,7 @@ config MA600_DONGLE
 
 config GIRBIL_DONGLE
 	tristate "Greenwich GIrBIL dongle"
-	depends on IRTTY_SIR && DONGLE && IRDA && EXPERIMENTAL
+	depends on IRTTY_SIR && DONGLE && IRDA
 	help
 	  Say Y here if you want to build support for the Greenwich GIrBIL
 	  dongle.  If you want to compile it as a module, choose M here.
@@ -164,7 +164,7 @@ config GIRBIL_DONGLE
 
 config MCP2120_DONGLE
 	tristate "Microchip MCP2120"
-	depends on IRTTY_SIR && DONGLE && IRDA && EXPERIMENTAL
+	depends on IRTTY_SIR && DONGLE && IRDA
 	help
 	  Say Y here if you want to build support for the Microchip MCP2120
 	  dongle.  If you want to compile it as a module, choose M here.
@@ -178,7 +178,7 @@ config MCP2120_DONGLE
 
 config OLD_BELKIN_DONGLE
 	tristate "Old Belkin dongle"
-	depends on IRTTY_SIR && DONGLE && IRDA && EXPERIMENTAL
+	depends on IRTTY_SIR && DONGLE && IRDA
 	help
 	  Say Y here if you want to build support for the Adaptec Airport 1000
 	  and 2000 dongles.  If you want to compile it as a module, choose
@@ -187,7 +187,7 @@ config OLD_BELKIN_DONGLE
 
 config ACT200L_DONGLE
 	tristate "ACTiSYS IR-200L dongle"
-	depends on IRTTY_SIR && DONGLE && IRDA && EXPERIMENTAL
+	depends on IRTTY_SIR && DONGLE && IRDA
 	help
 	  Say Y here if you want to build support for the ACTiSYS IR-200L
 	  dongle. If you want to compile it as a module, choose M here.
@@ -198,7 +198,7 @@ config ACT200L_DONGLE
 
 config KINGSUN_DONGLE
 	tristate "KingSun/DonShine DS-620 IrDA-USB dongle"
-	depends on IRDA && USB && EXPERIMENTAL
+	depends on IRDA && USB
 	help
 	  Say Y or M here if you want to build support for the KingSun/DonShine
 	  DS-620 IrDA-USB bridge device driver.
@@ -212,14 +212,14 @@ config KINGSUN_DONGLE
 
 config EP7211_DONGLE
 	tristate "Cirrus Logic clps711x I/R support"
-	depends on IRTTY_SIR && ARCH_CLPS711X && IRDA && EXPERIMENTAL
+	depends on IRTTY_SIR && ARCH_CLPS711X && IRDA
 	help
 	  Say Y here if you want to build support for the Cirrus logic
 	  EP7211 chipset's infrared module.
 
 config KSDAZZLE_DONGLE
-	tristate "KingSun Dazzle IrDA-USB dongle (EXPERIMENTAL)"
-	depends on IRDA && USB && EXPERIMENTAL
+	tristate "KingSun Dazzle IrDA-USB dongle"
+	depends on IRDA && USB
 	help
 	  Say Y or M here if you want to build support for the KingSun Dazzle
 	  IrDA-USB bridge device driver.
@@ -232,8 +232,8 @@ config KSDAZZLE_DONGLE
 	  ksdazzle-sir.
 
 config KS959_DONGLE
-	tristate "KingSun KS-959 IrDA-USB dongle (EXPERIMENTAL)"
-	depends on IRDA && USB && EXPERIMENTAL
+	tristate "KingSun KS-959 IrDA-USB dongle"
+	depends on IRDA && USB
 	help
 	  Say Y or M here if you want to build support for the KingSun KS-959
 	  IrDA-USB bridge device driver.
@@ -264,8 +264,8 @@ config USB_IRDA
 	  you will need both USB and IrDA support in your kernel...
 
 config SIGMATEL_FIR
-	tristate "SigmaTel STIr4200 bridge (EXPERIMENTAL)"
-	depends on IRDA && USB && EXPERIMENTAL
+	tristate "SigmaTel STIr4200 bridge"
+	depends on IRDA && USB
 	select CRC32
 	---help---
 	  Say Y here if you want to build support for the SigmaTel STIr4200
@@ -331,8 +331,8 @@ config SMC_IRCC_FIR
 	  smsc-ircc2.o.
 
 config ALI_FIR
-	tristate "ALi M5123 FIR (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && IRDA && ISA_DMA_API
+	tristate "ALi M5123 FIR"
+	depends on IRDA && ISA_DMA_API
 	help
 	  Say Y here if you want to build support for the ALi M5123 FIR
 	  Controller.  The ALi M5123 FIR Controller is embedded in ALi M1543C,
@@ -343,8 +343,8 @@ config ALI_FIR
 	  ali-ircc.
 
 config VLSI_FIR
-	tristate "VLSI 82C147 SIR/MIR/FIR (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && IRDA && PCI
+	tristate "VLSI 82C147 SIR/MIR/FIR"
+	depends on IRDA && PCI
 	help
 	  Say Y here if you want to build support for the VLSI 82C147
 	  PCI-IrDA Controller. This controller is used by the HP OmniBook 800
@@ -387,7 +387,7 @@ config PXA_FICP
 
 config MCS_FIR
 	tristate "MosChip MCS7780 IrDA-USB dongle"
-	depends on IRDA && USB && EXPERIMENTAL
+	depends on IRDA && USB
 	select CRC32
 	help
 	  Say Y or M here if you want to build support for the MosChip
diff --git a/drivers/net/ppp/Kconfig b/drivers/net/ppp/Kconfig
index 872df3e..278dea0 100644
--- a/drivers/net/ppp/Kconfig
+++ b/drivers/net/ppp/Kconfig
@@ -82,8 +82,8 @@ config PPP_FILTER
 	  If unsure, say N.
 
 config PPP_MPPE
-	tristate "PPP MPPE compression (encryption) (EXPERIMENTAL)"
-	depends on PPP && EXPERIMENTAL
+	tristate "PPP MPPE compression (encryption)"
+	depends on PPP
 	select CRYPTO
 	select CRYPTO_SHA1
 	select CRYPTO_ARC4
@@ -96,8 +96,8 @@ config PPP_MPPE
 	  configuring PPTP clients and servers to utilize this method.
 
 config PPP_MULTILINK
-	bool "PPP multilink support (EXPERIMENTAL)"
-	depends on PPP && EXPERIMENTAL
+	bool "PPP multilink support"
+	depends on PPP
 	---help---
 	  PPP multilink is a protocol (defined in RFC 1990) which allows you
 	  to combine several (logical or physical) lines into one logical PPP
@@ -118,8 +118,8 @@ config PPPOATM
 	  changes its encapsulation unilaterally.
 
 config PPPOE
-	tristate "PPP over Ethernet (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && PPP
+	tristate "PPP over Ethernet"
+	depends on PPP
 	---help---
 	  Support for PPP over Ethernet.
 
@@ -130,8 +130,8 @@ config PPPOE
 	  the heading "Kernel mode PPPoE").
 
 config PPTP
-	tristate "PPP over IPv4 (PPTP) (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && PPP && NET_IPGRE_DEMUX
+	tristate "PPP over IPv4 (PPTP)"
+	depends on PPP && NET_IPGRE_DEMUX
 	---help---
 	  Support for PPP over IPv4.(Point-to-Point Tunneling Protocol)
 
@@ -141,8 +141,8 @@ config PPTP
 	  utilize this module.
 
 config PPPOL2TP
-	tristate "PPP over L2TP (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && L2TP && PPP
+	tristate "PPP over L2TP"
+	depends on L2TP && PPP
 	---help---
 	  Support for PPP-over-L2TP socket family. L2TP is a protocol
 	  used by ISPs and enterprises to tunnel PPP traffic over UDP
diff --git a/drivers/net/team/Kconfig b/drivers/net/team/Kconfig
index 6a7260b..1b3cdd1 100644
--- a/drivers/net/team/Kconfig
+++ b/drivers/net/team/Kconfig
@@ -1,6 +1,5 @@
 menuconfig NET_TEAM
-	tristate "Ethernet team driver support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	tristate "Ethernet team driver support"
 	---help---
 	  This allows one to create virtual interfaces that teams together
 	  multiple ethernet devices.
diff --git a/drivers/net/usb/Kconfig b/drivers/net/usb/Kconfig
index c1ae769..4d5c34d 100644
--- a/drivers/net/usb/Kconfig
+++ b/drivers/net/usb/Kconfig
@@ -8,8 +8,7 @@ menu "USB Network Adapters"
 	depends on USB && NET
 
 config USB_CATC
-	tristate "USB CATC NetMate-based Ethernet device support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	tristate "USB CATC NetMate-based Ethernet device support"
 	select CRC32
 	---help---
 	  Say Y if you want to use one of the following 10Mbps USB Ethernet
@@ -83,8 +82,7 @@ config USB_PEGASUS
 	  module will be called pegasus.
 
 config USB_RTL8150
-	tristate "USB RTL8150 based ethernet device support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	tristate "USB RTL8150 based ethernet device support"
 	select NET_CORE
 	select MII
 	help
@@ -188,7 +186,7 @@ config USB_NET_CDCETHER
 
 config USB_NET_CDC_EEM
 	tristate "CDC EEM support"
-	depends on USB_USBNET && EXPERIMENTAL
+	depends on USB_USBNET
 	help
 	  This option supports devices conforming to the Communication Device
 	  Class (CDC) Ethernet Emulation Model, a specification that's easy to
@@ -265,7 +263,7 @@ config USB_NET_PLUSB
 	tristate "Prolific PL-2301/2302/25A1 based cables"
 	# if the handshake/init/reset problems, from original 'plusb',
 	# are ever resolved ... then remove "experimental"
-	depends on USB_USBNET && EXPERIMENTAL
+	depends on USB_USBNET
 	help
 	  Choose this option if you're using a host-to-host cable
 	  with one of these chips.
@@ -279,8 +277,8 @@ config USB_NET_MCS7830
 	  adapters marketed under the DeLOCK brand.
 
 config USB_NET_RNDIS_HOST
-	tristate "Host for RNDIS and ActiveSync devices (EXPERIMENTAL)"
-	depends on USB_USBNET && EXPERIMENTAL
+	tristate "Host for RNDIS and ActiveSync devices"
+	depends on USB_USBNET
 	select USB_NET_CDCETHER
 	help
 	  This option enables hosting "Remote NDIS" USB networking links,
@@ -358,7 +356,7 @@ config USB_EPSON2888
 
 config USB_KC2190
 	boolean "KT Technology KC2190 based cables (InstaNet)"
-	depends on USB_NET_CDC_SUBSET && EXPERIMENTAL
+	depends on USB_NET_CDC_SUBSET
 	help
 	  Choose this option if you're using a host-to-host cable
 	  with one of these chips.
diff --git a/drivers/net/wan/Kconfig b/drivers/net/wan/Kconfig
index d58431e..c0cd88d 100644
--- a/drivers/net/wan/Kconfig
+++ b/drivers/net/wan/Kconfig
@@ -375,7 +375,7 @@ config WAN_ROUTER_DRIVERS
 	  If unsure, say N.
 
 config CYCLADES_SYNC
-	tristate "Cyclom 2X(tm) cards (EXPERIMENTAL)"
+	tristate "Cyclom 2X(tm) cards"
 	depends on WAN_ROUTER_DRIVERS && (PCI || ISA)
 	---help---
 	  Cyclom 2X from Cyclades Corporation <http://www.avocent.com/> is an
@@ -403,7 +403,7 @@ config CYCLADES_SYNC
 	  module will be called cyclomx.
 
 config CYCLOMX_X25
-	bool "Cyclom 2X X.25 support (EXPERIMENTAL)"
+	bool "Cyclom 2X X.25 support"
 	depends on CYCLADES_SYNC
 	help
 	  Connect a Cyclom 2X card to an X.25 network.
@@ -412,7 +412,7 @@ config CYCLOMX_X25
 
 # X.25 network drivers
 config LAPBETHER
-	tristate "LAPB over Ethernet driver (EXPERIMENTAL)"
+	tristate "LAPB over Ethernet driver"
 	depends on LAPB && X25
 	---help---
 	  Driver for a pseudo device (typically called /dev/lapb0) which allows
@@ -428,7 +428,7 @@ config LAPBETHER
 	  If unsure, say N.
 
 config X25_ASY
-	tristate "X.25 async driver (EXPERIMENTAL)"
+	tristate "X.25 async driver"
 	depends on LAPB && X25
 	---help---
 	  Send and receive X.25 frames over regular asynchronous serial
diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index 6deaae1..fbeb7ac 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -138,7 +138,7 @@ config AIRO_CS
 
 config PCMCIA_WL3501
 	tristate "Planet WL3501 PCMCIA cards"
-	depends on EXPERIMENTAL && PCMCIA
+	depends on PCMCIA
 	select WIRELESS_EXT
 	select WEXT_SPY
 	help
@@ -148,7 +148,7 @@ config PCMCIA_WL3501
 
 config PRISM54
 	tristate 'Intersil Prism GT/Duette/Indigo PCI/Cardbus (DEPRECATED)'
-	depends on PCI && EXPERIMENTAL
+	depends on PCI
 	select WIRELESS_EXT
 	select WEXT_SPY
 	select WEXT_PRIV
@@ -191,7 +191,7 @@ config USB_ZD1201
 
 config USB_NET_RNDIS_WLAN
 	tristate "Wireless RNDIS USB support"
-	depends on USB && EXPERIMENTAL
+	depends on USB
 	depends on CFG80211
 	select USB_USBNET
 	select USB_NET_CDCETHER
@@ -221,7 +221,7 @@ source "drivers/net/wireless/rtl818x/Kconfig"
 
 config ADM8211
 	tristate "ADMtek ADM8211 support"
-	depends on MAC80211 && PCI && EXPERIMENTAL
+	depends on MAC80211 && PCI
 	select CRC32
 	select EEPROM_93CX6
 	---help---
@@ -261,7 +261,7 @@ config MAC80211_HWSIM
 
 config MWL8K
 	tristate "Marvell 88W8xxx PCI/PCIe Wireless support"
-	depends on MAC80211 && PCI && EXPERIMENTAL
+	depends on MAC80211 && PCI
 	---help---
 	  This driver supports Marvell TOPDOG 802.11 wireless cards.
 
diff --git a/drivers/net/wireless/ath/ath6kl/Kconfig b/drivers/net/wireless/ath/ath6kl/Kconfig
index d755a5e..d7368dd 100644
--- a/drivers/net/wireless/ath/ath6kl/Kconfig
+++ b/drivers/net/wireless/ath/ath6kl/Kconfig
@@ -18,7 +18,6 @@ config ATH6KL_USB
 	depends on ATH6KL
 	depends on USB
 	depends on CFG80211
-	depends on EXPERIMENTAL
 	---help---
 	  This module adds support for wireless adapters based on
 	  Atheros AR6004 chipset running over USB. This is still under
diff --git a/drivers/net/wireless/ath/carl9170/Kconfig b/drivers/net/wireless/ath/carl9170/Kconfig
index 267d5dc..50c55c7 100644
--- a/drivers/net/wireless/ath/carl9170/Kconfig
+++ b/drivers/net/wireless/ath/carl9170/Kconfig
@@ -1,6 +1,6 @@
 config CARL9170
 	tristate "Linux Community AR9170 802.11n USB support"
-	depends on USB && MAC80211 && EXPERIMENTAL
+	depends on USB && MAC80211
 	select FW_LOADER
 	select CRC32
 	help
diff --git a/drivers/net/wireless/b43/Kconfig b/drivers/net/wireless/b43/Kconfig
index 3876c7e..c3566ea 100644
--- a/drivers/net/wireless/b43/Kconfig
+++ b/drivers/net/wireless/b43/Kconfig
@@ -78,8 +78,8 @@ config B43_PCMCIA
 	  If unsure, say N.
 
 config B43_SDIO
-	bool "Broadcom 43xx SDIO device support (EXPERIMENTAL)"
-	depends on B43 && SSB_SDIOHOST_POSSIBLE && EXPERIMENTAL
+	bool "Broadcom 43xx SDIO device support"
+	depends on B43 && SSB_SDIOHOST_POSSIBLE
 	select SSB_SDIOHOST
 	---help---
 	  Broadcom 43xx device support for Soft-MAC SDIO devices.
@@ -109,8 +109,8 @@ config B43_PIO
 	default y
 
 config B43_PHY_N
-	bool "Support for 802.11n (N-PHY) devices (EXPERIMENTAL)"
-	depends on B43 && EXPERIMENTAL
+	bool "Support for 802.11n (N-PHY) devices"
+	depends on B43
 	---help---
 	  Support for the N-PHY.
 
@@ -130,8 +130,8 @@ config B43_PHY_LP
 	  (802.11a support is optional, and currently disabled).
 
 config B43_PHY_HT
-	bool "Support for HT-PHY (high throughput) devices (EXPERIMENTAL)"
-	depends on B43 && EXPERIMENTAL
+	bool "Support for HT-PHY (high throughput) devices"
+	depends on B43
 	---help---
 	  Support for the HT-PHY.
 
diff --git a/drivers/net/wireless/ipw2x00/Kconfig b/drivers/net/wireless/ipw2x00/Kconfig
index 2715b10..91c0cb3 100644
--- a/drivers/net/wireless/ipw2x00/Kconfig
+++ b/drivers/net/wireless/ipw2x00/Kconfig
@@ -137,7 +137,7 @@ config IPW2200_PROMISCUOUS
 
 config IPW2200_QOS
         bool "Enable QoS support"
-        depends on IPW2200 && EXPERIMENTAL
+        depends on IPW2200
 
 config IPW2200_DEBUG
 	bool "Enable full debugging output in IPW2200 module."
diff --git a/drivers/net/wireless/p54/Kconfig b/drivers/net/wireless/p54/Kconfig
index 0ec55b5..15ea36b 100644
--- a/drivers/net/wireless/p54/Kconfig
+++ b/drivers/net/wireless/p54/Kconfig
@@ -1,6 +1,6 @@
 config P54_COMMON
 	tristate "Softmac Prism54 support"
-	depends on MAC80211 && EXPERIMENTAL
+	depends on MAC80211
 	select FW_LOADER
 	select CRC_CCITT
 	---help---
diff --git a/drivers/net/wireless/rt2x00/Kconfig b/drivers/net/wireless/rt2x00/Kconfig
index c7548da..b3d7e9a 100644
--- a/drivers/net/wireless/rt2x00/Kconfig
+++ b/drivers/net/wireless/rt2x00/Kconfig
@@ -81,8 +81,7 @@ config RT2800PCI_RT33XX
 	  Supported chips: RT3390
 
 config RT2800PCI_RT35XX
-	bool "rt2800pci - Include support for rt35xx devices (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	bool "rt2800pci - Include support for rt35xx devices"
 	default y
 	---help---
 	  This adds support for rt35xx wireless chipset family to the
@@ -91,8 +90,7 @@ config RT2800PCI_RT35XX
 
 
 config RT2800PCI_RT53XX
-       bool "rt2800pci - Include support for rt53xx devices (EXPERIMENTAL)"
-       depends on EXPERIMENTAL
+       bool "rt2800pci - Include support for rt53xx devices"
        default y
        ---help---
          This adds support for rt53xx wireless chipset family to the
@@ -100,8 +98,7 @@ config RT2800PCI_RT53XX
          Supported chips: RT5390
 
 config RT2800PCI_RT3290
-       bool "rt2800pci - Include support for rt3290 devices (EXPERIMENTAL)"
-       depends on EXPERIMENTAL
+       bool "rt2800pci - Include support for rt3290 devices"
        default y
        ---help---
          This adds support for rt3290 wireless chipset family to the
@@ -158,8 +155,7 @@ config RT2800USB_RT33XX
 	  Supported chips: RT3370
 
 config RT2800USB_RT35XX
-	bool "rt2800usb - Include support for rt35xx devices (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	bool "rt2800usb - Include support for rt35xx devices"
 	default y
 	---help---
 	  This adds support for rt35xx wireless chipset family to the
@@ -167,8 +163,7 @@ config RT2800USB_RT35XX
 	  Supported chips: RT3572
 
 config RT2800USB_RT53XX
-       bool "rt2800usb - Include support for rt53xx devices (EXPERIMENTAL)"
-       depends on EXPERIMENTAL
+       bool "rt2800usb - Include support for rt53xx devices"
        ---help---
          This adds support for rt53xx wireless chipset family to the
          rt2800usb driver.
diff --git a/drivers/net/wireless/rtl818x/Kconfig b/drivers/net/wireless/rtl818x/Kconfig
index 17d80fe..3033217 100644
--- a/drivers/net/wireless/rtl818x/Kconfig
+++ b/drivers/net/wireless/rtl818x/Kconfig
@@ -3,7 +3,7 @@
 #
 config RTL8180
 	tristate "Realtek 8180/8185 PCI support"
-	depends on MAC80211 && PCI && EXPERIMENTAL
+	depends on MAC80211 && PCI
 	select EEPROM_93CX6
 	---help---
 	  This is a driver for RTL8180 and RTL8185 based cards.
diff --git a/drivers/net/wireless/rtlwifi/Kconfig b/drivers/net/wireless/rtlwifi/Kconfig
index cefac6a..6b28e92 100644
--- a/drivers/net/wireless/rtlwifi/Kconfig
+++ b/drivers/net/wireless/rtlwifi/Kconfig
@@ -1,6 +1,6 @@
 config RTL8192CE
 	tristate "Realtek RTL8192CE/RTL8188CE Wireless Network Adapter"
-	depends on MAC80211 && PCI && EXPERIMENTAL
+	depends on MAC80211 && PCI
 	select FW_LOADER
 	select RTLWIFI
 	select RTL8192C_COMMON
@@ -12,7 +12,7 @@ config RTL8192CE
 
 config RTL8192SE
 	tristate "Realtek RTL8192SE/RTL8191SE PCIe Wireless Network Adapter"
-	depends on MAC80211 && EXPERIMENTAL && PCI
+	depends on MAC80211 && PCI
 	select FW_LOADER
 	select RTLWIFI
 	---help---
@@ -23,7 +23,7 @@ config RTL8192SE
 
 config RTL8192DE
 	tristate "Realtek RTL8192DE/RTL8188DE PCIe Wireless Network Adapter"
-	depends on MAC80211 && EXPERIMENTAL && PCI
+	depends on MAC80211 && PCI
 	select FW_LOADER
 	select RTLWIFI
 	---help---
@@ -34,7 +34,7 @@ config RTL8192DE
 
 config RTL8192CU
 	tristate "Realtek RTL8192CU/RTL8188CU USB Wireless Network Adapter"
-	depends on MAC80211 && USB && EXPERIMENTAL
+	depends on MAC80211 && USB
 	select FW_LOADER
 	select RTLWIFI
 	select RTL8192C_COMMON
diff --git a/drivers/net/wireless/ti/wl1251/Kconfig b/drivers/net/wireless/ti/wl1251/Kconfig
index 1fb6584..8fec4ed 100644
--- a/drivers/net/wireless/ti/wl1251/Kconfig
+++ b/drivers/net/wireless/ti/wl1251/Kconfig
@@ -1,6 +1,6 @@
 menuconfig WL1251
 	tristate "TI wl1251 driver support"
-	depends on MAC80211 && EXPERIMENTAL && GENERIC_HARDIRQS
+	depends on MAC80211 && GENERIC_HARDIRQS
 	select FW_LOADER
 	select CRC7
 	---help---
diff --git a/drivers/net/wireless/zd1211rw/Kconfig b/drivers/net/wireless/zd1211rw/Kconfig
index 5f80969..96c8e1d 100644
--- a/drivers/net/wireless/zd1211rw/Kconfig
+++ b/drivers/net/wireless/zd1211rw/Kconfig
@@ -1,6 +1,6 @@
 config ZD1211RW
 	tristate "ZyDAS ZD1211/ZD1211B USB-wireless support"
-	depends on USB && MAC80211 && EXPERIMENTAL
+	depends on USB && MAC80211
 	select FW_LOADER
 	---help---
 	  This is an experimental driver for the ZyDAS ZD1211/ZD1211B wireless
diff --git a/drivers/parport/Kconfig b/drivers/parport/Kconfig
index d92185a..f25ecfd 100644
--- a/drivers/parport/Kconfig
+++ b/drivers/parport/Kconfig
@@ -57,8 +57,8 @@ config PARPORT_SERIAL
 	  will be called parport_serial.
 
 config PARPORT_PC_FIFO
-	bool "Use FIFO/DMA if available (EXPERIMENTAL)"
-	depends on PARPORT_PC && EXPERIMENTAL
+	bool "Use FIFO/DMA if available"
+	depends on PARPORT_PC
 	help
 	  Many parallel port chipsets provide hardware that can speed up
 	  printing. Say Y here if you want to take advantage of that.
@@ -70,8 +70,8 @@ config PARPORT_PC_FIFO
 	  specify which IRQ/DMA to use.
 
 config PARPORT_PC_SUPERIO
-	bool "SuperIO chipset support (EXPERIMENTAL)"
-	depends on PARPORT_PC && EXPERIMENTAL
+	bool "SuperIO chipset support"
+	depends on PARPORT_PC
 	help
 	  Saying Y here enables some probes for Super-IO chipsets in order to
 	  find out things like base addresses, IRQ lines and DMA channels.  It
@@ -85,8 +85,8 @@ config PARPORT_PC_PCMCIA
 	  ports. If unsure, say N.
 
 config PARPORT_IP32
-	tristate "SGI IP32 builtin port (EXPERIMENTAL)"
-	depends on SGI_IP32 && EXPERIMENTAL
+	tristate "SGI IP32 builtin port"
+	depends on SGI_IP32
 	select PARPORT_NOT_PC
 	help
 	  Say Y here if you need support for the parallel port on
@@ -126,8 +126,8 @@ config PARPORT_GSC
 	select PARPORT_NOT_PC
 
 config PARPORT_SUNBPP
-	tristate "Sparc hardware (EXPERIMENTAL)"
-	depends on SBUS && EXPERIMENTAL
+	tristate "Sparc hardware"
+	depends on SBUS
 	select PARPORT_NOT_PC
 	help
 	  This driver provides support for the bidirectional parallel port
diff --git a/drivers/pci/pcie/Kconfig b/drivers/pci/pcie/Kconfig
index 6c8bc58..fde4a32 100644
--- a/drivers/pci/pcie/Kconfig
+++ b/drivers/pci/pcie/Kconfig
@@ -82,4 +82,4 @@ endchoice
 
 config PCIE_PME
 	def_bool y
-	depends on PCIEPORTBUS && PM_RUNTIME && EXPERIMENTAL && ACPI
+	depends on PCIEPORTBUS && PM_RUNTIME && ACPI
diff --git a/drivers/pcmcia/Kconfig b/drivers/pcmcia/Kconfig
index 8fd255f..b90f85b 100644
--- a/drivers/pcmcia/Kconfig
+++ b/drivers/pcmcia/Kconfig
@@ -36,8 +36,8 @@ config PCMCIA
 	   If unsure, say Y.
 
 config PCMCIA_LOAD_CIS
-	bool "Load CIS updates from userspace (EXPERIMENTAL)"
-	depends on PCMCIA && EXPERIMENTAL
+	bool "Load CIS updates from userspace"
+	depends on PCMCIA
 	select FW_LOADER
 	default y
 	help
diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index c86bae8..7ab0b2f 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -80,10 +80,9 @@ config ASUS_LAPTOP
 	  If you have an ACPI-compatible ASUS laptop, say Y or M here.
 
 config DELL_LAPTOP
-	tristate "Dell Laptop Extras (EXPERIMENTAL)"
+	tristate "Dell Laptop Extras"
 	depends on X86
 	depends on DCDBAS
-	depends on EXPERIMENTAL
 	depends on BACKLIGHT_CLASS_DEVICE
 	depends on RFKILL || RFKILL = n
 	depends on SERIO_I8042
@@ -171,9 +170,8 @@ config AMILO_RFKILL
 	  laptops.
 
 config TC1100_WMI
-	tristate "HP Compaq TC1100 Tablet WMI Extras (EXPERIMENTAL)"
+	tristate "HP Compaq TC1100 Tablet WMI Extras"
 	depends on !X86_64
-	depends on EXPERIMENTAL
 	depends on ACPI
 	depends on ACPI_WMI
 	---help---
diff --git a/drivers/pnp/pnpbios/Kconfig b/drivers/pnp/pnpbios/Kconfig
index b986d9f..50c3dd0 100644
--- a/drivers/pnp/pnpbios/Kconfig
+++ b/drivers/pnp/pnpbios/Kconfig
@@ -2,8 +2,8 @@
 # Plug and Play BIOS configuration
 #
 config PNPBIOS
-	bool "Plug and Play BIOS support (EXPERIMENTAL)"
-	depends on ISA && X86 && EXPERIMENTAL
+	bool "Plug and Play BIOS support"
+	depends on ISA && X86
 	default n
 	---help---
 	  Linux uses the PNPBIOS as defined in "Plug and Play BIOS
diff --git a/drivers/pps/Kconfig b/drivers/pps/Kconfig
index 258ca59..982d16b 100644
--- a/drivers/pps/Kconfig
+++ b/drivers/pps/Kconfig
@@ -6,7 +6,6 @@ menu "PPS support"
 
 config PPS
 	tristate "PPS support"
-	depends on EXPERIMENTAL
 	---help---
 	  PPS (Pulse Per Second) is a special pulse provided by some GPS
 	  antennae. Userland can use it to get a high-precision time
diff --git a/drivers/ptp/Kconfig b/drivers/ptp/Kconfig
index ffdf712..a6e4b7c 100644
--- a/drivers/ptp/Kconfig
+++ b/drivers/ptp/Kconfig
@@ -9,7 +9,6 @@ comment "Enable Device Drivers -> PPS to see the PTP clock options."
 
 config PTP_1588_CLOCK
 	tristate "PTP clock support"
-	depends on EXPERIMENTAL
 	depends on PPS
 	help
 	  The IEEE 1588 standard defines a method to precisely
diff --git a/drivers/remoteproc/Kconfig b/drivers/remoteproc/Kconfig
index f8d818a..79c182b 100644
--- a/drivers/remoteproc/Kconfig
+++ b/drivers/remoteproc/Kconfig
@@ -1,14 +1,12 @@
-menu "Remoteproc drivers (EXPERIMENTAL)"
+menu "Remoteproc drivers"
 
 # REMOTEPROC gets selected by whoever wants it
 config REMOTEPROC
 	tristate
-	depends on EXPERIMENTAL
 	select FW_CONFIG
 
 config OMAP_REMOTEPROC
 	tristate "OMAP remoteproc support"
-	depends on EXPERIMENTAL
 	depends on ARCH_OMAP4
 	depends on OMAP_IOMMU
 	select REMOTEPROC
diff --git a/drivers/rpmsg/Kconfig b/drivers/rpmsg/Kconfig
index 32aead6..98aca55 100644
--- a/drivers/rpmsg/Kconfig
+++ b/drivers/rpmsg/Kconfig
@@ -1,10 +1,9 @@
-menu "Rpmsg drivers (EXPERIMENTAL)"
+menu "Rpmsg drivers"
 
 # RPMSG always gets selected by whoever wants it
 config RPMSG
 	tristate
 	select VIRTIO
 	select VIRTIO_RING
-	depends on EXPERIMENTAL
 
 endmenu
diff --git a/drivers/sbus/char/Kconfig b/drivers/sbus/char/Kconfig
index 73cde85..5ba684f 100644
--- a/drivers/sbus/char/Kconfig
+++ b/drivers/sbus/char/Kconfig
@@ -21,8 +21,7 @@ config OBP_FLASH
 	  able to upgrade the OBP firmware, say Y here.
 
 config TADPOLE_TS102_UCTRL
-	tristate "Tadpole TS102 Microcontroller support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	tristate "Tadpole TS102 Microcontroller support"
 	help
 	  Say Y here to directly support the TS102 Microcontroller interface
 	  on the Tadpole Sparcbook 3.  This device handles power-management
@@ -30,8 +29,8 @@ config TADPOLE_TS102_UCTRL
 	  monitors and mice.
 
 config SUN_JSFLASH
-	tristate "JavaStation OS Flash SIMM (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && SPARC32
+	tristate "JavaStation OS Flash SIMM"
+	depends on SPARC32
 	help
 	  If you say Y here, you will be able to boot from your JavaStation's
 	  Flash memory.
diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 74bf1aa..e2c33d3 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -42,7 +42,7 @@ config SCSI_DMA
 
 config SCSI_TGT
 	tristate "SCSI target support"
-	depends on SCSI && EXPERIMENTAL
+	depends on SCSI
 	---help---
 	  If you want to use SCSI target mode drivers enable this option.
 	  If you choose M, the module will be called scsi_tgt.
@@ -1391,8 +1391,8 @@ config SCSI_SYM53C416
 	  module will be called sym53c416.
 
 config SCSI_DC395x
-	tristate "Tekram DC395(U/UW/F) and DC315(U) SCSI support (EXPERIMENTAL)"
-	depends on PCI && SCSI && EXPERIMENTAL
+	tristate "Tekram DC395(U/UW/F) and DC315(U) SCSI support"
+	depends on PCI && SCSI
 	---help---
 	  This driver supports PCI SCSI host adapters based on the ASIC
 	  TRM-S1040 chip, e.g Tekram DC395(U/UW/F) and DC315(U) variants.
@@ -1617,8 +1617,8 @@ config GVP11_SCSI
 	  module will be called gvp11.
 
 config SCSI_A4000T
-	tristate "A4000T NCR53c710 SCSI support (EXPERIMENTAL)"
-	depends on AMIGA && SCSI && EXPERIMENTAL
+	tristate "A4000T NCR53c710 SCSI support"
+	depends on AMIGA && SCSI
 	select SCSI_SPI_ATTRS
 	help
 	  If you have an Amiga 4000T and have SCSI devices connected to the
@@ -1628,8 +1628,8 @@ config SCSI_A4000T
 	  module will be called a4000t.
 
 config SCSI_ZORRO7XX
-	tristate "Zorro NCR53c710 SCSI support (EXPERIMENTAL)"
-	depends on ZORRO && SCSI && EXPERIMENTAL
+	tristate "Zorro NCR53c710 SCSI support"
+	depends on ZORRO && SCSI
 	select SCSI_SPI_ATTRS
 	help
 	  Support for various NCR53c710-based SCSI controllers on Zorro
@@ -1806,8 +1806,8 @@ config SCSI_BFA_FC
 	  be called bfa.
 
 config SCSI_VIRTIO
-	tristate "virtio-scsi support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && VIRTIO
+	tristate "virtio-scsi support"
+	depends on VIRTIO
 	help
           This is the virtual HBA driver for virtio.  If the kernel will
           be used in a virtual machine, say Y or M.
diff --git a/drivers/scsi/arm/Kconfig b/drivers/scsi/arm/Kconfig
index a8587f1..cfd172a 100644
--- a/drivers/scsi/arm/Kconfig
+++ b/drivers/scsi/arm/Kconfig
@@ -64,19 +64,19 @@ config SCSI_POWERTECSCSI
 	  you have one of these, say Y. If unsure, say N.
 
 comment "The following drivers are not fully supported"
-	depends on ARCH_ACORN && EXPERIMENTAL
+	depends on ARCH_ACORN
 
 config SCSI_CUMANA_1
-	tristate "CumanaSCSI I support (EXPERIMENTAL)"
-	depends on ARCH_ACORN && EXPERIMENTAL && SCSI
+	tristate "CumanaSCSI I support"
+	depends on ARCH_ACORN && SCSI
 	select SCSI_SPI_ATTRS
 	help
 	  This enables support for the Cumana SCSI I card. If you have an
 	  Acorn system with one of these, say Y. If unsure, say N.
 
 config SCSI_OAK1
-	tristate "Oak SCSI support (EXPERIMENTAL)"
-	depends on ARCH_ACORN && EXPERIMENTAL && SCSI
+	tristate "Oak SCSI support"
+	depends on ARCH_ACORN && SCSI
 	select SCSI_SPI_ATTRS
 	help
 	  This enables support for the Oak SCSI card. If you have an Acorn
diff --git a/drivers/scsi/device_handler/Kconfig b/drivers/scsi/device_handler/Kconfig
index 6707025..69abd0a 100644
--- a/drivers/scsi/device_handler/Kconfig
+++ b/drivers/scsi/device_handler/Kconfig
@@ -32,8 +32,8 @@ config SCSI_DH_EMC
 	If you have a EMC CLARiiON select y. Otherwise, say N.
 
 config SCSI_DH_ALUA
-	tristate "SPC-3 ALUA Device Handler (EXPERIMENTAL)"
-	depends on SCSI_DH && EXPERIMENTAL
+	tristate "SPC-3 ALUA Device Handler"
+	depends on SCSI_DH
 	help
 	  SCSI Device handler for generic SPC-3 Asymmetric Logical Unit
 	  Access (ALUA).
diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
index 5f84b55..01ac6ce 100644
--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -88,7 +88,7 @@ config SPI_BFIN_SPORT
 
 config SPI_AU1550
 	tristate "Au1550/Au1200/Au1300 SPI Controller"
-	depends on MIPS_ALCHEMY && EXPERIMENTAL
+	depends on MIPS_ALCHEMY
 	select SPI_BITBANG
 	help
 	  If you say yes to this option, support will be included for the
@@ -180,7 +180,7 @@ config SPI_IMX
 
 config SPI_LM70_LLP
 	tristate "Parallel port adapter for LM70 eval board (DEVELOPMENT)"
-	depends on PARPORT && EXPERIMENTAL
+	depends on PARPORT
 	select SPI_BITBANG
 	help
 	  This driver supports the NS LM70 LLP Evaluation Board,
@@ -196,7 +196,7 @@ config SPI_MPC52xx
 
 config SPI_MPC52xx_PSC
 	tristate "Freescale MPC52xx PSC SPI controller"
-	depends on PPC_MPC52xx && EXPERIMENTAL
+	depends on PPC_MPC52xx
 	help
 	  This enables using the Freescale MPC52xx Programmable Serial
 	  Controller in master SPI mode.
@@ -258,8 +258,8 @@ config SPI_OMAP_100K
 	  OMAP SPI 100K master controller for omap7xx boards.
 
 config SPI_ORION
-	tristate "Orion SPI master (EXPERIMENTAL)"
-	depends on PLAT_ORION && EXPERIMENTAL
+	tristate "Orion SPI master"
+	depends on PLAT_ORION
 	help
 	  This enables using the SPI master controller on the Orion chips.
 
@@ -284,7 +284,7 @@ config SPI_PPC4xx
 
 config SPI_PXA2XX
 	tristate "PXA2xx SSP SPI master"
-	depends on (ARCH_PXA || (X86_32 && PCI)) && EXPERIMENTAL
+	depends on (ARCH_PXA || (X86_32 && PCI))
 	select PXA_SSP if ARCH_PXA
 	help
 	  This enables using a PXA2xx or Sodaville SSP port as a SPI master
@@ -302,7 +302,7 @@ config SPI_RSPI
 
 config SPI_S3C24XX
 	tristate "Samsung S3C24XX series SPI"
-	depends on ARCH_S3C24XX && EXPERIMENTAL
+	depends on ARCH_S3C24XX
 	select SPI_BITBANG
 	help
 	  SPI driver for Samsung S3C24XX series ARM SoCs
@@ -402,7 +402,7 @@ config SPI_XCOMM
 
 config SPI_XILINX
 	tristate "Xilinx SPI controller common module"
-	depends on HAS_IOMEM && EXPERIMENTAL
+	depends on HAS_IOMEM
 	select SPI_BITBANG
 	help
 	  This exposes the SPI controller IP from the Xilinx EDK.
@@ -414,7 +414,7 @@ config SPI_XILINX
 
 config SPI_NUC900
 	tristate "Nuvoton NUC900 series SPI"
-	depends on ARCH_W90X900 && EXPERIMENTAL
+	depends on ARCH_W90X900
 	select SPI_BITBANG
 	help
 	  SPI driver for Nuvoton NUC900 series ARM SoCs
@@ -448,7 +448,6 @@ comment "SPI Protocol Masters"
 
 config SPI_SPIDEV
 	tristate "User mode SPI device driver support"
-	depends on EXPERIMENTAL
 	help
 	  This supports user mode SPI protocol drivers.
 
diff --git a/drivers/staging/bcm/Kconfig b/drivers/staging/bcm/Kconfig
index 96adb10..83c9752 100644
--- a/drivers/staging/bcm/Kconfig
+++ b/drivers/staging/bcm/Kconfig
@@ -1,6 +1,6 @@
 config BCM_WIMAX
        tristate "Beceem BCS200/BCS220-3 and BCSM250 wimax support"
-       depends on USB && NET && EXPERIMENTAL
+       depends on USB && NET
        default N
        help
          This is an experimental driver for the Beceem WIMAX chipset used
diff --git a/drivers/staging/usbip/Kconfig b/drivers/staging/usbip/Kconfig
index dd13c02..199b1d4 100644
--- a/drivers/staging/usbip/Kconfig
+++ b/drivers/staging/usbip/Kconfig
@@ -1,6 +1,6 @@
 config USBIP_CORE
-	tristate "USB/IP support (EXPERIMENTAL)"
-	depends on USB && NET && EXPERIMENTAL
+	tristate "USB/IP support"
+	depends on USB && NET
 	default N
 	---help---
 	  This enables pushing USB packets over IP to allow remote
diff --git a/drivers/staging/winbond/Kconfig b/drivers/staging/winbond/Kconfig
index 132671d..a29f608 100644
--- a/drivers/staging/winbond/Kconfig
+++ b/drivers/staging/winbond/Kconfig
@@ -1,6 +1,6 @@
 config W35UND
 	tristate "IS89C35 WLAN USB driver"
-	depends on MAC80211 && WLAN && USB && EXPERIMENTAL
+	depends on MAC80211 && WLAN && USB
 	default n
 	---help---
 	  This is highly experimental driver for Winbond WIFI card.
diff --git a/drivers/staging/wlags49_h2/man/wlags49.4 b/drivers/staging/wlags49_h2/man/wlags49.4
index a345885..37df998 100644
--- a/drivers/staging/wlags49_h2/man/wlags49.4
+++ b/drivers/staging/wlags49_h2/man/wlags49.4
@@ -108,7 +108,7 @@ with the I/O base address and MAC address used by the card.
  \- Card power management
  \- Support for Hermes-II & Hermes-II.5 based PCMCIA, Mini PCI, and CardBus cards
  \- Wired Equivalent Privacy (WEP)
- \- WPA-PSK support (EXPERIMENTAL)
+ \- WPA-PSK support
  \- Driver utility interface (UIL)
  \- Wireless Extensions
  \- Software AP mode
diff --git a/drivers/target/sbp/Kconfig b/drivers/target/sbp/Kconfig
index 132da54..1614bc7 100644
--- a/drivers/target/sbp/Kconfig
+++ b/drivers/target/sbp/Kconfig
@@ -1,6 +1,6 @@
 config SBP_TARGET
 	tristate "FireWire SBP-2 fabric module"
-	depends on FIREWIRE && EXPERIMENTAL
+	depends on FIREWIRE
 	help
 	  Say Y or M here to enable SCSI target functionality over FireWire.
 	  This enables you to expose SCSI devices to other nodes on the FireWire
diff --git a/drivers/tty/Kconfig b/drivers/tty/Kconfig
index 830cd62..b46c430 100644
--- a/drivers/tty/Kconfig
+++ b/drivers/tty/Kconfig
@@ -214,8 +214,8 @@ config CYCLADES
 	  If you haven't heard about it, it's safe to say N.
 
 config CYZ_INTR
-	bool "Cyclades-Z interrupt mode operation (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && CYCLADES
+	bool "Cyclades-Z interrupt mode operation"
+	depends on CYCLADES
 	help
 	  The Cyclades-Z family of multiport cards allows 2 (two) driver op
 	  modes: polling and interrupt. In polling mode, the driver will check
@@ -285,7 +285,7 @@ config SYNCLINK_GT
 
 config NOZOMI
 	tristate "HSDPA Broadband Wireless Data Card - Globe Trotter"
-	depends on PCI && EXPERIMENTAL
+	depends on PCI
 	help
 	  If you have a HSDPA driver Broadband Wireless Data Card -
 	  Globe Trotter PCMCIA card, say Y here.
@@ -294,7 +294,7 @@ config NOZOMI
 	  will be called nozomi.
 
 config ISI
-	tristate "Multi-Tech multiport card support (EXPERIMENTAL)"
+	tristate "Multi-Tech multiport card support"
 	depends on SERIAL_NONSTANDARD && PCI
 	select FW_LOADER
 	help
@@ -316,8 +316,7 @@ config N_HDLC
 	  here.
 
 config N_GSM
-	tristate "GSM MUX line discipline support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	tristate "GSM MUX line discipline support"
 	depends on NET
 	help
 	  This line discipline provides support for the GSM MUX protocol and
diff --git a/drivers/tty/hvc/Kconfig b/drivers/tty/hvc/Kconfig
index 0282a83..f47b734 100644
--- a/drivers/tty/hvc/Kconfig
+++ b/drivers/tty/hvc/Kconfig
@@ -76,7 +76,7 @@ config HVC_XEN_FRONTEND
 
 config HVC_UDBG
        bool "udbg based fake hypervisor console"
-       depends on PPC && EXPERIMENTAL
+       depends on PPC
        select HVC_DRIVER
        default n
        help
diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
index 4720b4b..0bc2d58 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -686,7 +686,7 @@ config SERIAL_SH_SCI_CONSOLE
 
 config SERIAL_SH_SCI_DMA
 	bool "DMA support"
-	depends on SERIAL_SH_SCI && SH_DMAE && EXPERIMENTAL
+	depends on SERIAL_SH_SCI && SH_DMAE
 
 config SERIAL_PNX8XXX
 	bool "Enable PNX8XXX SoCs' UART Support"
@@ -1259,8 +1259,8 @@ config SERIAL_ALTERA_UART_CONSOLE
 	  Enable a Altera UART port to be the system console.
 
 config SERIAL_IFX6X60
-        tristate "SPI protocol driver for Infineon 6x60 modem (EXPERIMENTAL)"
-	depends on GPIOLIB && SPI && EXPERIMENTAL
+        tristate "SPI protocol driver for Infineon 6x60 modem"
+	depends on GPIOLIB && SPI
 	help
 	  Support for the IFX6x60 modem devices on Intel MID platforms.
 
diff --git a/drivers/usb/core/Kconfig b/drivers/usb/core/Kconfig
index 9981984..f70c1a1 100644
--- a/drivers/usb/core/Kconfig
+++ b/drivers/usb/core/Kconfig
@@ -56,7 +56,7 @@ config USB_SUSPEND
 
 config USB_OTG
 	bool "OTG support"
-	depends on USB && EXPERIMENTAL
+	depends on USB
 	depends on USB_SUSPEND
 	default n
 	help
diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
index 51ab5fd..c54dbe5 100644
--- a/drivers/usb/gadget/Kconfig
+++ b/drivers/usb/gadget/Kconfig
@@ -564,7 +564,7 @@ config USB_ZERO_HNPTEST
 	  one serve as the USB host instead (in the "B-Host" role).
 
 config USB_AUDIO
-	tristate "Audio Gadget (EXPERIMENTAL)"
+	tristate "Audio Gadget"
 	depends on SND
 	select SND_PCM
 	help
@@ -674,8 +674,7 @@ config USB_G_NCM
 	  dynamically linked module called "g_ncm".
 
 config USB_GADGETFS
-	tristate "Gadget Filesystem (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	tristate "Gadget Filesystem"
 	help
 	  This driver provides a filesystem based API that lets user mode
 	  programs implement a single-configuration USB device, including
@@ -683,15 +682,14 @@ config USB_GADGETFS
 	  All endpoints, transfer speeds, and transfer types supported by
 	  the hardware are available, through read() and write() calls.
 
-	  Currently, this option is still labelled as EXPERIMENTAL because
-	  of existing race conditions in the underlying in-kernel AIO core.
+	  Currently, this option is potentially buggy due to existing race
+	  conditions in the underlying in-kernel AIO core.
 
 	  Say "y" to link the driver statically, or "m" to build a
 	  dynamically linked module called "gadgetfs".
 
 config USB_FUNCTIONFS
-	tristate "Function Filesystem (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	tristate "Function Filesystem"
 	select USB_FUNCTIONFS_GENERIC if !(USB_FUNCTIONFS_ETH || USB_FUNCTIONFS_RNDIS)
 	help
 	  The Function Filesystem (FunctionFS) lets one create USB
@@ -797,8 +795,8 @@ config USB_G_SERIAL
 	  make MS-Windows work with CDC ACM.
 
 config USB_MIDI_GADGET
-	tristate "MIDI Gadget (EXPERIMENTAL)"
-	depends on SND && EXPERIMENTAL
+	tristate "MIDI Gadget"
+	depends on SND
 	select SND_RAWMIDI
 	help
 	  The MIDI Gadget acts as a USB Audio device, with one MIDI
@@ -860,7 +858,7 @@ config USB_G_ACM_MS
 	  dynamically linked module called "g_acm_ms".
 
 config USB_G_MULTI
-	tristate "Multifunction Composite Gadget (EXPERIMENTAL)"
+	tristate "Multifunction Composite Gadget"
 	depends on BLOCK && NET
 	select USB_G_MULTI_CDC if !USB_G_MULTI_RNDIS
 	help
diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
index 075d2ec..d9de451 100644
--- a/drivers/usb/host/Kconfig
+++ b/drivers/usb/host/Kconfig
@@ -18,8 +18,8 @@ config USB_C67X00_HCD
 	  module will be called c67x00.
 
 config USB_XHCI_HCD
-	tristate "xHCI HCD (USB 3.0) support (EXPERIMENTAL)"
-	depends on USB && USB_ARCH_HAS_XHCI && EXPERIMENTAL
+	tristate "xHCI HCD (USB 3.0) support"
+	depends on USB && USB_ARCH_HAS_XHCI
 	---help---
 	  The eXtensible Host Controller Interface (xHCI) is standard for USB 3.0
 	  "SuperSpeed" host controller hardware.
@@ -262,7 +262,7 @@ config USB_ISP116X_HCD
 
 config USB_ISP1760_HCD
 	tristate "ISP 1760 HCD support"
-	depends on USB && EXPERIMENTAL
+	depends on USB
 	---help---
 	  The ISP1760 chip is a USB 2.0 host controller.
 
@@ -376,7 +376,7 @@ config USB_OHCI_HCD_PCI
 
 config USB_OHCI_HCD_SSB
 	bool "OHCI support for Broadcom SSB OHCI core (DEPRECATED)"
-	depends on USB_OHCI_HCD && (SSB = y || SSB = USB_OHCI_HCD) && EXPERIMENTAL
+	depends on USB_OHCI_HCD && (SSB = y || SSB = USB_OHCI_HCD)
 	select USB_HCD_SSB
 	select USB_OHCI_HCD_PLATFORM
 	default n
@@ -414,7 +414,7 @@ config USB_CNS3XXX_OHCI
 
 config USB_OHCI_HCD_PLATFORM
 	bool "Generic OHCI driver for a platform device"
-	depends on USB_OHCI_HCD && EXPERIMENTAL
+	depends on USB_OHCI_HCD
 	default n
 	---help---
 	  Adds an OHCI host driver for a generic platform device, which
@@ -424,7 +424,7 @@ config USB_OHCI_HCD_PLATFORM
 
 config USB_EHCI_HCD_PLATFORM
 	bool "Generic EHCI driver for a platform device"
-	depends on USB_EHCI_HCD && EXPERIMENTAL
+	depends on USB_EHCI_HCD
 	default n
 	---help---
 	  Adds an EHCI host driver for a generic platform device, which
@@ -583,8 +583,7 @@ config USB_RENESAS_USBHS_HCD
 	  module will be called renesas-usbhs.
 
 config USB_WHCI_HCD
-	tristate "Wireless USB Host Controller Interface (WHCI) driver (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	tristate "Wireless USB Host Controller Interface (WHCI) driver"
 	depends on PCI && USB && UWB
 	select USB_WUSB
 	select UWB_WHCI
@@ -596,8 +595,7 @@ config USB_WHCI_HCD
 	  will be called "whci-hcd".
 
 config USB_HWA_HCD
-	tristate "Host Wire Adapter (HWA) driver (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	tristate "Host Wire Adapter (HWA) driver"
 	depends on USB && UWB
 	select USB_WUSB
 	select UWB_HWA
@@ -648,7 +646,7 @@ config USB_OCTEON2_COMMON
 
 config USB_HCD_BCMA
 	tristate "BCMA usb host driver"
-	depends on BCMA && EXPERIMENTAL
+	depends on BCMA
 	select USB_OHCI_HCD_PLATFORM if USB_OHCI_HCD
 	select USB_EHCI_HCD_PLATFORM if USB_EHCI_HCD
 	help
@@ -660,7 +658,7 @@ config USB_HCD_BCMA
 
 config USB_HCD_SSB
 	tristate "SSB usb host driver"
-	depends on SSB && EXPERIMENTAL
+	depends on SSB
 	select USB_OHCI_HCD_PLATFORM if USB_OHCI_HCD
 	select USB_EHCI_HCD_PLATFORM if USB_EHCI_HCD
 	help
diff --git a/drivers/usb/wusbcore/Kconfig b/drivers/usb/wusbcore/Kconfig
index f29fdd7..8bf1976 100644
--- a/drivers/usb/wusbcore/Kconfig
+++ b/drivers/usb/wusbcore/Kconfig
@@ -2,8 +2,7 @@
 # Wireless USB Core configuration
 #
 config USB_WUSB
-	tristate "Enable Wireless USB extensions (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	tristate "Enable Wireless USB extensions"
 	depends on USB
 	depends on PCI
 	depends on UWB
diff --git a/drivers/uwb/Kconfig b/drivers/uwb/Kconfig
index d100f54..2431eed 100644
--- a/drivers/uwb/Kconfig
+++ b/drivers/uwb/Kconfig
@@ -3,8 +3,7 @@
 #
 
 menuconfig UWB
-	tristate "Ultra Wideband devices (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	tristate "Ultra Wideband devices"
 	depends on PCI
 	default n
 	help
diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
index 202bba6..bf24317 100644
--- a/drivers/vhost/Kconfig
+++ b/drivers/vhost/Kconfig
@@ -1,6 +1,6 @@
 config VHOST_NET
-	tristate "Host kernel accelerator for virtio net (EXPERIMENTAL)"
-	depends on NET && EVENTFD && (TUN || !TUN) && (MACVTAP || !MACVTAP) && EXPERIMENTAL
+	tristate "Host kernel accelerator for virtio net"
+	depends on NET && EVENTFD && (TUN || !TUN) && (MACVTAP || !MACVTAP)
 	---help---
 	  This kernel module can be loaded in host kernel to accelerate
 	  guest networking with virtio_net. Not to be confused with virtio_net
diff --git a/drivers/vhost/Kconfig.tcm b/drivers/vhost/Kconfig.tcm
index a9c6f76..7e3aa28 100644
--- a/drivers/vhost/Kconfig.tcm
+++ b/drivers/vhost/Kconfig.tcm
@@ -1,6 +1,6 @@
 config TCM_VHOST
-	tristate "TCM_VHOST fabric module (EXPERIMENTAL)"
-	depends on TARGET_CORE && EVENTFD && EXPERIMENTAL && m
+	tristate "TCM_VHOST fabric module"
+	depends on TARGET_CORE && EVENTFD && m
 	default n
 	---help---
 	Say M here to enable the TCM_VHOST fabric module for use with virtio-scsi guests
diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index 0217f74..17ebf25 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -1124,8 +1124,8 @@ config FB_RIVA_BACKLIGHT
 	  Say Y here if you want to control the backlight of your display.
 
 config FB_I740
-	tristate "Intel740 support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && FB && PCI
+	tristate "Intel740 support"
+	depends on FB && PCI
 	select FB_MODE_HELPERS
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
@@ -1136,8 +1136,8 @@ config FB_I740
 	  This driver supports graphics cards based on Intel740 chip.
 
 config FB_I810
-	tristate "Intel 810/815 support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && FB && PCI && X86_32 && AGP_INTEL
+	tristate "Intel 810/815 support"
+	depends on FB && PCI && X86_32 && AGP_INTEL
 	select FB_MODE_HELPERS
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
@@ -1199,8 +1199,8 @@ config FB_CARILLO_RANCH
 	  This driver supports the LE80578 (Carillo Ranch) board
 
 config FB_INTEL
-	tristate "Intel 830M/845G/852GM/855GM/865G/915G/945G/945GM/965G/965GM support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && FB && PCI && X86 && AGP_INTEL && EXPERT
+	tristate "Intel 830M/845G/852GM/855GM/865G/915G/945G/945GM/965G/965GM support"
+	depends on FB && PCI && X86 && AGP_INTEL && EXPERT
 	select FB_MODE_HELPERS
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
@@ -1444,7 +1444,7 @@ config FB_ATY_CT
 	  is at <http://support.ati.com/products/pc/mach64/mach64.html>.
 
 config FB_ATY_GENERIC_LCD
-	bool "Mach64 generic LCD support (EXPERIMENTAL)"
+	bool "Mach64 generic LCD support"
 	depends on FB_ATY_CT
 	help
 	  Say Y if you have a laptop with an ATI Rage LT PRO, Rage Mobility,
@@ -1491,7 +1491,7 @@ config FB_S3_DDC
 
 config FB_SAVAGE
 	tristate "S3 Savage support"
-	depends on FB && PCI && EXPERIMENTAL
+	depends on FB && PCI
 	select FB_MODE_HELPERS
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
@@ -1645,15 +1645,15 @@ config FB_3DFX
 	  module will be called tdfxfb.
 
 config FB_3DFX_ACCEL
-	bool "3Dfx Acceleration functions (EXPERIMENTAL)"
-	depends on FB_3DFX && EXPERIMENTAL
+	bool "3Dfx Acceleration functions"
+	depends on FB_3DFX
 	---help---
 	This will compile the 3Dfx Banshee/Voodoo3/VSA-100 frame buffer
 	device driver with acceleration functions.
 
 config FB_3DFX_I2C
 	bool "Enable DDC/I2C support"
-	depends on FB_3DFX && EXPERIMENTAL
+	depends on FB_3DFX
 	select FB_DDC
 	default y
 	help
@@ -1726,8 +1726,8 @@ config FB_ARK
 	  and ICS 5342 RAMDAC.
 
 config FB_PM3
-	tristate "Permedia3 support (EXPERIMENTAL)"
-	depends on FB && PCI && EXPERIMENTAL
+	tristate "Permedia3 support"
+	depends on FB && PCI
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
diff --git a/drivers/video/console/Kconfig b/drivers/video/console/Kconfig
index e2c96d0..bc922c4 100644
--- a/drivers/video/console/Kconfig
+++ b/drivers/video/console/Kconfig
@@ -46,7 +46,7 @@ config VGACON_SOFT_SCROLLBACK_SIZE
 
 config MDA_CONSOLE
 	depends on !M68K && !PARISC && ISA
-	tristate "MDA text console (dual-headed) (EXPERIMENTAL)"
+	tristate "MDA text console (dual-headed)"
 	---help---
 	  Say Y here if you have an old MDA or monochrome Hercules graphics
 	  adapter in your system acting as a second head ( = video card). You
diff --git a/drivers/video/geode/Kconfig b/drivers/video/geode/Kconfig
index c5d8ba4..21e351a 100644
--- a/drivers/video/geode/Kconfig
+++ b/drivers/video/geode/Kconfig
@@ -2,14 +2,14 @@
 # Geode family framebuffer configuration
 #
 config FB_GEODE
-	bool "AMD Geode family framebuffer support (EXPERIMENTAL)"
-	depends on FB && PCI && EXPERIMENTAL && X86
+	bool "AMD Geode family framebuffer support"
+	depends on FB && PCI && X86
 	---help---
 	  Say 'Y' here to allow you to select framebuffer drivers for
 	  the AMD Geode family of processors.
 
 config FB_GEODE_LX
-	tristate "AMD Geode LX framebuffer support (EXPERIMENTAL)"
+	tristate "AMD Geode LX framebuffer support"
 	depends on FB && FB_GEODE
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
@@ -24,8 +24,8 @@ config FB_GEODE_LX
 	  If unsure, say N.
 
 config FB_GEODE_GX
-	tristate "AMD Geode GX framebuffer support (EXPERIMENTAL)"
-	depends on FB && FB_GEODE && EXPERIMENTAL
+	tristate "AMD Geode GX framebuffer support"
+	depends on FB && FB_GEODE
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
@@ -39,8 +39,8 @@ config FB_GEODE_GX
 	  If unsure, say N.
 
 config FB_GEODE_GX1
-	tristate "AMD Geode GX1 framebuffer support (EXPERIMENTAL)"
-	depends on FB && FB_GEODE && EXPERIMENTAL
+	tristate "AMD Geode GX1 framebuffer support"
+	depends on FB && FB_GEODE
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
diff --git a/drivers/video/omap/Kconfig b/drivers/video/omap/Kconfig
index b48f95f..e512581 100644
--- a/drivers/video/omap/Kconfig
+++ b/drivers/video/omap/Kconfig
@@ -1,5 +1,5 @@
 config FB_OMAP
-	tristate "OMAP frame buffer support (EXPERIMENTAL)"
+	tristate "OMAP frame buffer support"
 	depends on FB
 	depends on ARCH_OMAP1
 	select FB_CFB_FILLRECT
diff --git a/drivers/virtio/Kconfig b/drivers/virtio/Kconfig
index f38b17a..5f61f88 100644
--- a/drivers/virtio/Kconfig
+++ b/drivers/virtio/Kconfig
@@ -10,8 +10,8 @@ config VIRTIO_RING
 menu "Virtio drivers"
 
 config VIRTIO_PCI
-	tristate "PCI driver for virtio devices (EXPERIMENTAL)"
-	depends on PCI && EXPERIMENTAL
+	tristate "PCI driver for virtio devices"
+	depends on PCI
 	select VIRTIO
 	select VIRTIO_RING
 	---help---
@@ -26,7 +26,7 @@ config VIRTIO_PCI
 	  If unsure, say M.
 
 config VIRTIO_BALLOON
-	tristate "Virtio balloon driver (EXPERIMENTAL)"
+	tristate "Virtio balloon driver"
 	select VIRTIO
 	select VIRTIO_RING
 	---help---
@@ -36,8 +36,8 @@ config VIRTIO_BALLOON
 	 If unsure, say M.
 
  config VIRTIO_MMIO
- 	tristate "Platform bus driver for memory mapped virtio devices (EXPERIMENTAL)"
- 	depends on HAS_IOMEM && EXPERIMENTAL
+ 	tristate "Platform bus driver for memory mapped virtio devices"
+ 	depends on HAS_IOMEM
  	select VIRTIO
  	select VIRTIO_RING
  	---help---
diff --git a/drivers/vlynq/Kconfig b/drivers/vlynq/Kconfig
index d874b4f..e011620 100644
--- a/drivers/vlynq/Kconfig
+++ b/drivers/vlynq/Kconfig
@@ -1,5 +1,5 @@
 menu "TI VLYNQ"
-	depends on AR7 && EXPERIMENTAL
+	depends on AR7
 
 config VLYNQ
 	bool "TI VLYNQ bus support"
diff --git a/drivers/w1/masters/Kconfig b/drivers/w1/masters/Kconfig
index 5ceb1cd..5016b8d 100644
--- a/drivers/w1/masters/Kconfig
+++ b/drivers/w1/masters/Kconfig
@@ -26,7 +26,7 @@ config W1_MASTER_DS2490
 
 config W1_MASTER_DS2482
 	tristate "Maxim DS2482 I2C to 1-Wire bridge"
-	depends on I2C && EXPERIMENTAL
+	depends on I2C
 	help
 	  If you say yes here you get support for the Maxim DS2482
 	  I2C to 1-Wire bridge.
diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 53d7571..23407b5 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -431,7 +431,7 @@ config ALIM7101_WDT
 
 config F71808E_WDT
 	tristate "Fintek F71808E, F71862FG, F71869, F71882FG and F71889FG Watchdog"
-	depends on X86 && EXPERIMENTAL
+	depends on X86
 	help
 	  This is the driver for the hardware watchdog on the Fintek
 	  F71808E, F71862FG, F71869, F71882FG and F71889FG Super I/O controllers.
@@ -622,7 +622,7 @@ config IT8712F_WDT
 
 config IT87_WDT
 	tristate "IT87 Watchdog Timer"
-	depends on X86 && EXPERIMENTAL
+	depends on X86
 	---help---
 	  This is the driver for the hardware watchdog on the ITE IT8702,
 	  IT8712, IT8716, IT8718, IT8720, IT8721, IT8726 and IT8728
diff --git a/fs/9p/Kconfig b/fs/9p/Kconfig
index 0a93dc1..55abfd6 100644
--- a/fs/9p/Kconfig
+++ b/fs/9p/Kconfig
@@ -11,8 +11,7 @@ config 9P_FS
 
 if 9P_FS
 config 9P_FSCACHE
-	bool "Enable 9P client caching support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	bool "Enable 9P client caching support"
 	depends on 9P_FS=m && FSCACHE || 9P_FS=y && FSCACHE=y
 	help
 	  Choose Y here to enable persistent, read-only local
diff --git a/fs/adfs/Kconfig b/fs/adfs/Kconfig
index e55182a..c5a7787 100644
--- a/fs/adfs/Kconfig
+++ b/fs/adfs/Kconfig
@@ -1,6 +1,6 @@
 config ADFS_FS
-	tristate "ADFS file system support (EXPERIMENTAL)"
-	depends on BLOCK && EXPERIMENTAL
+	tristate "ADFS file system support"
+	depends on BLOCK
 	help
 	  The Acorn Disc Filing System is the standard file system of the
 	  RiscOS operating system which runs on Acorn's ARM-based Risc PC
diff --git a/fs/affs/Kconfig b/fs/affs/Kconfig
index cfad9af..a04d9e8 100644
--- a/fs/affs/Kconfig
+++ b/fs/affs/Kconfig
@@ -1,6 +1,6 @@
 config AFFS_FS
-	tristate "Amiga FFS file system support (EXPERIMENTAL)"
-	depends on BLOCK && EXPERIMENTAL
+	tristate "Amiga FFS file system support"
+	depends on BLOCK
 	help
 	  The Fast File System (FFS) is the common file system used on hard
 	  disks by Amiga(tm) systems since AmigaOS Version 1.3 (34.20).  Say Y
diff --git a/fs/afs/Kconfig b/fs/afs/Kconfig
index 8f975f2..ebba3b1 100644
--- a/fs/afs/Kconfig
+++ b/fs/afs/Kconfig
@@ -1,6 +1,6 @@
 config AFS_FS
-	tristate "Andrew File System support (AFS) (EXPERIMENTAL)"
-	depends on INET && EXPERIMENTAL
+	tristate "Andrew File System support (AFS)"
+	depends on INET
 	select AF_RXRPC
 	select DNS_RESOLVER
 	help
@@ -22,8 +22,7 @@ config AFS_DEBUG
 	  If unsure, say N.
 
 config AFS_FSCACHE
-	bool "Provide AFS client caching support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	bool "Provide AFS client caching support"
 	depends on AFS_FS=m && FSCACHE || AFS_FS=y && FSCACHE=y
 	help
 	  Say Y here if you want AFS data to be cached locally on disk through
diff --git a/fs/befs/Kconfig b/fs/befs/Kconfig
index 7835d30..edc5cc2 100644
--- a/fs/befs/Kconfig
+++ b/fs/befs/Kconfig
@@ -1,6 +1,6 @@
 config BEFS_FS
-	tristate "BeOS file system (BeFS) support (read only) (EXPERIMENTAL)"
-	depends on BLOCK && EXPERIMENTAL
+	tristate "BeOS file system (BeFS) support (read only)"
+	depends on BLOCK
 	select NLS
 	help
 	  The BeOS File System (BeFS) is the native file system of Be, Inc's
diff --git a/fs/bfs/Kconfig b/fs/bfs/Kconfig
index c2336c6..3728a64 100644
--- a/fs/bfs/Kconfig
+++ b/fs/bfs/Kconfig
@@ -1,6 +1,6 @@
 config BFS_FS
-	tristate "BFS file system support (EXPERIMENTAL)"
-	depends on BLOCK && EXPERIMENTAL
+	tristate "BFS file system support"
+	depends on BLOCK
 	help
 	  Boot File System (BFS) is a file system used under SCO UnixWare to
 	  allow the bootloader access to the kernel image and other important
diff --git a/fs/btrfs/Kconfig b/fs/btrfs/Kconfig
index d33f01c..ccd25ba 100644
--- a/fs/btrfs/Kconfig
+++ b/fs/btrfs/Kconfig
@@ -1,6 +1,5 @@
 config BTRFS_FS
-	tristate "Btrfs filesystem (EXPERIMENTAL) Unstable disk format"
-	depends on EXPERIMENTAL
+	tristate "Btrfs filesystem Unstable disk format"
 	select LIBCRC32C
 	select ZLIB_INFLATE
 	select ZLIB_DEFLATE
diff --git a/fs/ceph/Kconfig b/fs/ceph/Kconfig
index 9eb134e..a96aade 100644
--- a/fs/ceph/Kconfig
+++ b/fs/ceph/Kconfig
@@ -1,6 +1,6 @@
 config CEPH_FS
-        tristate "Ceph distributed file system (EXPERIMENTAL)"
-	depends on INET && EXPERIMENTAL
+        tristate "Ceph distributed file system"
+	depends on INET
 	select CEPH_LIB
 	select LIBCRC32C
 	select CRYPTO_AES
diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig
index a08306a..bc95744 100644
--- a/fs/cifs/Kconfig
+++ b/fs/cifs/Kconfig
@@ -154,14 +154,14 @@ config CIFS_ACL
 	    is handed over to the application/caller.
 
 config CIFS_NFSD_EXPORT
-	  bool "Allow nfsd to export CIFS file system (EXPERIMENTAL)"
-	  depends on CIFS && EXPERIMENTAL && BROKEN
+	  bool "Allow nfsd to export CIFS file system"
+	  depends on CIFS && BROKEN
 	  help
 	   Allows NFS server to export a CIFS mounted share (nfsd over cifs)
 
 config CIFS_SMB2
-	bool "SMB2 network file system support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && INET && BROKEN
+	bool "SMB2 network file system support"
+	depends on INET && BROKEN
 	select NLS
 	select KEYS
 	select FSCACHE
diff --git a/fs/dlm/Kconfig b/fs/dlm/Kconfig
index 1897eb1..e4242c3 100644
--- a/fs/dlm/Kconfig
+++ b/fs/dlm/Kconfig
@@ -1,6 +1,6 @@
 menuconfig DLM
 	tristate "Distributed Lock Manager (DLM)"
-	depends on EXPERIMENTAL && INET
+	depends on INET
 	depends on SYSFS && CONFIGFS_FS && (IPV6 || IPV6=n)
 	select IP_SCTP
 	help
diff --git a/fs/ecryptfs/Kconfig b/fs/ecryptfs/Kconfig
index cc16562..e15ef38 100644
--- a/fs/ecryptfs/Kconfig
+++ b/fs/ecryptfs/Kconfig
@@ -1,6 +1,6 @@
 config ECRYPT_FS
-	tristate "eCrypt filesystem layer support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && KEYS && CRYPTO && (ENCRYPTED_KEYS || ENCRYPTED_KEYS=n)
+	tristate "eCrypt filesystem layer support"
+	depends on KEYS && CRYPTO && (ENCRYPTED_KEYS || ENCRYPTED_KEYS=n)
 	select CRYPTO_ECB
 	select CRYPTO_CBC
 	select CRYPTO_MD5
diff --git a/fs/efs/Kconfig b/fs/efs/Kconfig
index 6ebfc1c..d020e3c 100644
--- a/fs/efs/Kconfig
+++ b/fs/efs/Kconfig
@@ -1,6 +1,6 @@
 config EFS_FS
-	tristate "EFS file system support (read only) (EXPERIMENTAL)"
-	depends on BLOCK && EXPERIMENTAL
+	tristate "EFS file system support (read only)"
+	depends on BLOCK
 	help
 	  EFS is an older file system used for non-ISO9660 CD-ROMs and hard
 	  disk partitions by SGI's IRIX operating system (IRIX 6.0 and newer
diff --git a/fs/hfs/Kconfig b/fs/hfs/Kconfig
index b77c5bc..998e3a6 100644
--- a/fs/hfs/Kconfig
+++ b/fs/hfs/Kconfig
@@ -1,6 +1,6 @@
 config HFS_FS
-	tristate "Apple Macintosh file system support (EXPERIMENTAL)"
-	depends on BLOCK && EXPERIMENTAL
+	tristate "Apple Macintosh file system support"
+	depends on BLOCK
 	select NLS
 	help
 	  If you say Y here, you will be able to mount Macintosh-formatted
diff --git a/fs/jffs2/Kconfig b/fs/jffs2/Kconfig
index 6ae169c..d8bb6c4 100644
--- a/fs/jffs2/Kconfig
+++ b/fs/jffs2/Kconfig
@@ -50,8 +50,8 @@ config JFFS2_FS_WBUF_VERIFY
 	  write-buffer, and check for errors.
 
 config JFFS2_SUMMARY
-	bool "JFFS2 summary support (EXPERIMENTAL)"
-	depends on JFFS2_FS && EXPERIMENTAL
+	bool "JFFS2 summary support"
+	depends on JFFS2_FS
 	default n
 	help
 	  This feature makes it possible to use summary information
@@ -63,8 +63,8 @@ config JFFS2_SUMMARY
 	  If unsure, say 'N'.
 
 config JFFS2_FS_XATTR
-	bool "JFFS2 XATTR support (EXPERIMENTAL)"
-	depends on JFFS2_FS && EXPERIMENTAL
+	bool "JFFS2 XATTR support"
+	depends on JFFS2_FS
 	default n
 	help
 	  Extended attributes are name:value pairs associated with inodes by
@@ -173,7 +173,7 @@ config JFFS2_CMODE_PRIORITY
 	  successful one.
 
 config JFFS2_CMODE_SIZE
-	bool "size (EXPERIMENTAL)"
+	bool "size"
 	help
 	  Tries all compressors and chooses the one which has the smallest
 	  result.
diff --git a/fs/logfs/Kconfig b/fs/logfs/Kconfig
index daf9a9b..09ed066 100644
--- a/fs/logfs/Kconfig
+++ b/fs/logfs/Kconfig
@@ -1,6 +1,6 @@
 config LOGFS
-	tristate "LogFS file system (EXPERIMENTAL)"
-	depends on (MTD || BLOCK) && EXPERIMENTAL
+	tristate "LogFS file system"
+	depends on (MTD || BLOCK)
 	select ZLIB_INFLATE
 	select ZLIB_DEFLATE
 	select CRC32
diff --git a/fs/nfs/Kconfig b/fs/nfs/Kconfig
index db7ad71..13ca196 100644
--- a/fs/nfs/Kconfig
+++ b/fs/nfs/Kconfig
@@ -95,8 +95,8 @@ config NFS_SWAP
 	  This option enables swapon to work on files located on NFS mounts.
 
 config NFS_V4_1
-	bool "NFS client support for NFSv4.1 (EXPERIMENTAL)"
-	depends on NFS_V4 && EXPERIMENTAL
+	bool "NFS client support for NFSv4.1"
+	depends on NFS_V4
 	select SUNRPC_BACKCHANNEL
 	help
 	  This option enables support for minor version 1 of the NFSv4 protocol
diff --git a/fs/nfsd/Kconfig b/fs/nfsd/Kconfig
index 8df1ea4..430b687 100644
--- a/fs/nfsd/Kconfig
+++ b/fs/nfsd/Kconfig
@@ -65,8 +65,8 @@ config NFSD_V3_ACL
 	  If unsure, say N.
 
 config NFSD_V4
-	bool "NFS server support for NFS version 4 (EXPERIMENTAL)"
-	depends on NFSD && PROC_FS && EXPERIMENTAL
+	bool "NFS server support for NFS version 4"
+	depends on NFSD && PROC_FS
 	select NFSD_V3
 	select FS_POSIX_ACL
 	select SUNRPC_GSS
diff --git a/fs/nilfs2/Kconfig b/fs/nilfs2/Kconfig
index 251da07..80da8eb 100644
--- a/fs/nilfs2/Kconfig
+++ b/fs/nilfs2/Kconfig
@@ -1,6 +1,5 @@
 config NILFS2_FS
-	tristate "NILFS2 file system support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	tristate "NILFS2 file system support"
 	select CRC32
 	help
 	  NILFS2 is a log-structured file system (LFS) supporting continuous
diff --git a/fs/ufs/Kconfig b/fs/ufs/Kconfig
index e4f10a4..0bf6e16 100644
--- a/fs/ufs/Kconfig
+++ b/fs/ufs/Kconfig
@@ -29,7 +29,7 @@ config UFS_FS
 
 config UFS_FS_WRITE
 	bool "UFS file system write support (DANGEROUS)"
-	depends on UFS_FS && EXPERIMENTAL
+	depends on UFS_FS
 	help
 	  Say Y here if you want to try writing to UFS partitions. This is
 	  experimental, so you should back up your UFS partitions beforehand.
diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
index 6100ec0..d841fd1 100644
--- a/fs/xfs/Kconfig
+++ b/fs/xfs/Kconfig
@@ -69,8 +69,8 @@ config XFS_RT
 	  If unsure, say N.
 
 config XFS_DEBUG
-	bool "XFS Debugging support (EXPERIMENTAL)"
-	depends on XFS_FS && EXPERIMENTAL
+	bool "XFS Debugging support"
+	depends on XFS_FS
 	help
 	  Say Y here to get an XFS build with many debugging features,
 	  including ASSERT checks, function wrappers around macros,
diff --git a/init/Kconfig b/init/Kconfig
index af6c7f8..c409b7f 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -32,37 +32,6 @@ config BUILDTIME_EXTABLE_SORT
 
 menu "General setup"
 
-config EXPERIMENTAL
-	bool "Prompt for development and/or incomplete code/drivers"
-	---help---
-	  Some of the various things that Linux supports (such as network
-	  drivers, file systems, network protocols, etc.) can be in a state
-	  of development where the functionality, stability, or the level of
-	  testing is not yet high enough for general use. This is usually
-	  known as the "alpha-test" phase among developers. If a feature is
-	  currently in alpha-test, then the developers usually discourage
-	  uninformed widespread use of this feature by the general public to
-	  avoid "Why doesn't this work?" type mail messages. However, active
-	  testing and use of these systems is welcomed. Just be aware that it
-	  may not meet the normal level of reliability or it may fail to work
-	  in some special cases. Detailed bug reports from people familiar
-	  with the kernel internals are usually welcomed by the developers
-	  (before submitting bug reports, please read the documents
-	  <file:README>, <file:MAINTAINERS>, <file:REPORTING-BUGS>,
-	  <file:Documentation/BUG-HUNTING>, and
-	  <file:Documentation/oops-tracing.txt> in the kernel source).
-
-	  This option will also make obsoleted drivers available. These are
-	  drivers that have been replaced by something else, and/or are
-	  scheduled to be removed in a future kernel release.
-
-	  Unless you intend to help test and develop a feature or driver that
-	  falls into this category, or you have a situation that requires
-	  using these features, you should probably say N here, which will
-	  cause the configurator to present you with fewer choices. If
-	  you say Y here, you will be offered the choice of using features or
-	  drivers that are currently considered to be in the alpha-test phase.
-
 config BROKEN
 	bool
 
@@ -247,7 +216,7 @@ config SYSVIPC_SYSCTL
 
 config POSIX_MQUEUE
 	bool "POSIX Message Queues"
-	depends on NET && EXPERIMENTAL
+	depends on NET
 	---help---
 	  POSIX variant of message queues is a part of IPC. In POSIX message
 	  queues every message has a priority which decides about succession
@@ -305,7 +274,7 @@ config FHANDLE
 	  syscalls.
 
 config TASKSTATS
-	bool "Export task/process statistics through netlink (EXPERIMENTAL)"
+	bool "Export task/process statistics through netlink"
 	depends on NET
 	default n
 	help
@@ -318,7 +287,7 @@ config TASKSTATS
 	  Say N if unsure.
 
 config TASK_DELAY_ACCT
-	bool "Enable per-task delay accounting (EXPERIMENTAL)"
+	bool "Enable per-task delay accounting"
 	depends on TASKSTATS
 	help
 	  Collect information on time spent by a task waiting for system
@@ -329,7 +298,7 @@ config TASK_DELAY_ACCT
 	  Say N if unsure.
 
 config TASK_XACCT
-	bool "Enable extended accounting over taskstats (EXPERIMENTAL)"
+	bool "Enable extended accounting over taskstats"
 	depends on TASKSTATS
 	help
 	  Collect extended task accounting data and send the data
@@ -338,7 +307,7 @@ config TASK_XACCT
 	  Say N if unsure.
 
 config TASK_IO_ACCOUNTING
-	bool "Enable per-task storage I/O accounting (EXPERIMENTAL)"
+	bool "Enable per-task storage I/O accounting"
 	depends on TASK_XACCT
 	help
 	  Collect information on the number of bytes of storage I/O which this
@@ -740,8 +709,8 @@ config MEMCG_SWAP_ENABLED
 	  select this option (if, for some reason, they need to disable it
 	  then swapaccount=0 does the trick).
 config MEMCG_KMEM
-	bool "Memory Resource Controller Kernel Memory accounting (EXPERIMENTAL)"
-	depends on MEMCG && EXPERIMENTAL
+	bool "Memory Resource Controller Kernel Memory accounting"
+	depends on MEMCG
 	default n
 	help
 	  The Kernel Memory extension for Memory Resource Controller can limit
@@ -753,7 +722,7 @@ config MEMCG_KMEM
 
 config CGROUP_HUGETLB
 	bool "HugeTLB Resource Controller for Control Groups"
-	depends on RESOURCE_COUNTERS && HUGETLB_PAGE && EXPERIMENTAL
+	depends on RESOURCE_COUNTERS && HUGETLB_PAGE
 	default n
 	help
 	  Provides a cgroup Resource Controller for HugeTLB pages.
@@ -792,7 +761,6 @@ config FAIR_GROUP_SCHED
 
 config CFS_BANDWIDTH
 	bool "CPU bandwidth provisioning for FAIR_GROUP_SCHED"
-	depends on EXPERIMENTAL
 	depends on FAIR_GROUP_SCHED
 	default n
 	help
@@ -804,7 +772,6 @@ config CFS_BANDWIDTH
 
 config RT_GROUP_SCHED
 	bool "Group scheduling for SCHED_RR/FIFO"
-	depends on EXPERIMENTAL
 	depends on CGROUP_SCHED
 	default n
 	help
@@ -886,8 +853,7 @@ config IPC_NS
 	  different IPC objects in different namespaces.
 
 config USER_NS
-	bool "User namespace (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	bool "User namespace"
 	depends on UIDGID_CONVERTED
 	select UIDGID_STRICT_TYPE_CHECKS
 
@@ -1556,7 +1522,7 @@ config MODULE_UNLOAD
 
 config MODULE_FORCE_UNLOAD
 	bool "Forced module unloading"
-	depends on MODULE_UNLOAD && EXPERIMENTAL
+	depends on MODULE_UNLOAD
 	help
 	  This option allows you to force a module to unload, even if the
 	  kernel believes it is unsafe: the kernel will remove the module
diff --git a/kernel/gcov/Kconfig b/kernel/gcov/Kconfig
index a920281..d4da55d 100644
--- a/kernel/gcov/Kconfig
+++ b/kernel/gcov/Kconfig
@@ -35,7 +35,7 @@ config GCOV_KERNEL
 config GCOV_PROFILE_ALL
 	bool "Profile entire Kernel"
 	depends on GCOV_KERNEL
-	depends on SUPERH || S390 || X86 || (PPC && EXPERIMENTAL) || MICROBLAZE
+	depends on SUPERH || S390 || X86 || PPC || MICROBLAZE
 	default n
 	---help---
 	This options activates profiling for the entire kernel.
diff --git a/lib/Kconfig b/lib/Kconfig
index bb94c1b..822dce5 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -319,7 +319,7 @@ config CPUMASK_OFFSTACK
 
 config DISABLE_OBSOLETE_CPUMASK_FUNCTIONS
        bool "Disable obsolete cpumask functions" if DEBUG_PER_CPU_MAPS
-       depends on EXPERIMENTAL && BROKEN
+       depends on BROKEN
 
 config CPU_RMAP
 	bool
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 2403a63..a3940bf 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -451,7 +451,7 @@ config SLUB_STATS
 
 config DEBUG_KMEMLEAK
 	bool "Kernel memory leak detector"
-	depends on DEBUG_KERNEL && EXPERIMENTAL && \
+	depends on DEBUG_KERNEL && \
 		(X86 || ARM || PPC || MIPS || S390 || SPARC64 || SUPERH || MICROBLAZE || TILE)
 
 	select DEBUG_FS
diff --git a/lib/Kconfig.kgdb b/lib/Kconfig.kgdb
index 43cb93f..77439eb 100644
--- a/lib/Kconfig.kgdb
+++ b/lib/Kconfig.kgdb
@@ -5,7 +5,7 @@ config HAVE_ARCH_KGDB
 menuconfig KGDB
 	bool "KGDB: kernel debugger"
 	depends on HAVE_ARCH_KGDB
-	depends on DEBUG_KERNEL && EXPERIMENTAL
+	depends on DEBUG_KERNEL
 	help
 	  If you say Y here, it will be possible to remotely debug the
 	  kernel using gdb.  It is recommended but not required, that
diff --git a/mm/Kconfig b/mm/Kconfig
index d5c8019..1f47f33 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1,6 +1,5 @@
 config SELECT_MEMORY_MODEL
 	def_bool y
-	depends on EXPERIMENTAL || ARCH_SELECT_MEMORY_MODEL
 
 choice
 	prompt "Memory model"
diff --git a/net/9p/Kconfig b/net/9p/Kconfig
index d9ea09b..a75174a 100644
--- a/net/9p/Kconfig
+++ b/net/9p/Kconfig
@@ -23,7 +23,7 @@ config NET_9P_VIRTIO
 	  guest partitions and a host partition.
 
 config NET_9P_RDMA
-	depends on INET && INFINIBAND && INFINIBAND_ADDR_TRANS && EXPERIMENTAL
+	depends on INET && INFINIBAND && INFINIBAND_ADDR_TRANS
 	tristate "9P RDMA Transport (Experimental)"
 	help
 	  This builds support for an RDMA transport.
diff --git a/net/Kconfig b/net/Kconfig
index 245831b..74781bd 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -88,7 +88,6 @@ config NETWORK_SECMARK
 
 config NETWORK_PHY_TIMESTAMPING
 	bool "Timestamping in PHY devices"
-	depends on EXPERIMENTAL
 	help
 	  This allows timestamping of network packets by PHYs with
 	  hardware timestamping capabilities. This option adds some
@@ -276,7 +275,7 @@ config NET_PKTGEN
 
 config NET_TCPPROBE
 	tristate "TCP connection probing"
-	depends on INET && EXPERIMENTAL && PROC_FS && KPROBES
+	depends on INET && PROC_FS && KPROBES
 	---help---
 	This module allows for capturing the changes to TCP connection
 	state in response to incoming packets. It is used for debugging
@@ -293,7 +292,7 @@ config NET_TCPPROBE
 
 config NET_DROP_MONITOR
 	tristate "Network packet drop alerting service"
-	depends on INET && EXPERIMENTAL && TRACEPOINTS
+	depends on INET && TRACEPOINTS
 	---help---
 	This feature provides an alerting service to userspace in the
 	event that packets are discarded in the network stack.  Alerts
diff --git a/net/ceph/Kconfig b/net/ceph/Kconfig
index cc04dd6..97782bc 100644
--- a/net/ceph/Kconfig
+++ b/net/ceph/Kconfig
@@ -1,6 +1,6 @@
 config CEPH_LIB
-        tristate "Ceph core library (EXPERIMENTAL)"
-	depends on INET && EXPERIMENTAL
+        tristate "Ceph core library"
+	depends on INET
 	select LIBCRC32C
 	select CRYPTO_AES
 	select CRYPTO
diff --git a/net/dccp/Kconfig b/net/dccp/Kconfig
index b75968a..8c0ef71 100644
--- a/net/dccp/Kconfig
+++ b/net/dccp/Kconfig
@@ -1,6 +1,6 @@
 menuconfig IP_DCCP
-	tristate "The DCCP Protocol (EXPERIMENTAL)"
-	depends on INET && EXPERIMENTAL
+	tristate "The DCCP Protocol"
+	depends on INET
 	---help---
 	  Datagram Congestion Control Protocol (RFC 4340)
 
diff --git a/net/dccp/ccids/Kconfig b/net/dccp/ccids/Kconfig
index 0581143..8ba3fc9 100644
--- a/net/dccp/ccids/Kconfig
+++ b/net/dccp/ccids/Kconfig
@@ -1,5 +1,4 @@
-menu "DCCP CCIDs Configuration (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+menu "DCCP CCIDs Configuration"
 
 config IP_DCCP_CCID2_DEBUG
 	bool "CCID-2 debugging messages"
@@ -12,7 +11,7 @@ config IP_DCCP_CCID2_DEBUG
 	  If in doubt, say N.
 
 config IP_DCCP_CCID3
-	bool "CCID-3 (TCP-Friendly) (EXPERIMENTAL)"
+	bool "CCID-3 (TCP-Friendly)"
 	def_bool y if (IP_DCCP = y || IP_DCCP = m)
 	---help---
 	  CCID-3 denotes TCP-Friendly Rate Control (TFRC), an equation-based
diff --git a/net/decnet/Kconfig b/net/decnet/Kconfig
index 7914fd6..f3393e1 100644
--- a/net/decnet/Kconfig
+++ b/net/decnet/Kconfig
@@ -25,8 +25,8 @@ config DECNET
 	  The module is called decnet.
 
 config DECNET_ROUTER
-	bool "DECnet: router support (EXPERIMENTAL)"
-	depends on DECNET && EXPERIMENTAL
+	bool "DECnet: router support"
+	depends on DECNET
 	select FIB_RULES
 	---help---
 	  Add support for turning your DECnet Endnode into a level 1 or 2
diff --git a/net/decnet/netfilter/Kconfig b/net/decnet/netfilter/Kconfig
index 2f81de5..8d7c109 100644
--- a/net/decnet/netfilter/Kconfig
+++ b/net/decnet/netfilter/Kconfig
@@ -3,7 +3,7 @@
 #
 
 menu "DECnet: Netfilter Configuration"
-	depends on DECNET && NETFILTER && EXPERIMENTAL
+	depends on DECNET && NETFILTER
 	depends on NETFILTER_ADVANCED
 
 config DECNET_NF_GRABULATOR
diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
index 274791c..9c09f6e 100644
--- a/net/dsa/Kconfig
+++ b/net/dsa/Kconfig
@@ -1,7 +1,7 @@
 config NET_DSA
 	tristate "Distributed Switch Architecture support"
 	default n
-	depends on EXPERIMENTAL && NETDEVICES && !S390
+	depends on NETDEVICES && !S390
 	select PHYLIB
 	---help---
 	  This allows you to use hardware switch chips that use
diff --git a/net/ieee802154/Kconfig b/net/ieee802154/Kconfig
index 7dee650..b2e06df 100644
--- a/net/ieee802154/Kconfig
+++ b/net/ieee802154/Kconfig
@@ -1,6 +1,5 @@
 config IEEE802154
-	tristate "IEEE Std 802.15.4 Low-Rate Wireless Personal Area Networks support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	tristate "IEEE Std 802.15.4 Low-Rate Wireless Personal Area Networks support"
 	---help---
 	  IEEE Std 802.15.4 defines a low data rate, low power and low
 	  complexity short range wireless personal area networks. It was
diff --git a/net/ipv4/Kconfig b/net/ipv4/Kconfig
index 5a19aeb..7944df7 100644
--- a/net/ipv4/Kconfig
+++ b/net/ipv4/Kconfig
@@ -488,7 +488,6 @@ config TCP_CONG_HTCP
 
 config TCP_CONG_HSTCP
 	tristate "High Speed TCP"
-	depends on EXPERIMENTAL
 	default n
 	---help---
 	Sally Floyd's High Speed TCP (RFC 3649) congestion control.
@@ -499,7 +498,6 @@ config TCP_CONG_HSTCP
 
 config TCP_CONG_HYBLA
 	tristate "TCP-Hybla congestion control algorithm"
-	depends on EXPERIMENTAL
 	default n
 	---help---
 	TCP-Hybla is a sender-side only change that eliminates penalization of
@@ -509,7 +507,6 @@ config TCP_CONG_HYBLA
 
 config TCP_CONG_VEGAS
 	tristate "TCP Vegas"
-	depends on EXPERIMENTAL
 	default n
 	---help---
 	TCP Vegas is a sender-side only change to TCP that anticipates
@@ -520,7 +517,6 @@ config TCP_CONG_VEGAS
 
 config TCP_CONG_SCALABLE
 	tristate "Scalable TCP"
-	depends on EXPERIMENTAL
 	default n
 	---help---
 	Scalable TCP is a sender-side only change to TCP which uses a
@@ -530,7 +526,6 @@ config TCP_CONG_SCALABLE
 
 config TCP_CONG_LP
 	tristate "TCP Low Priority"
-	depends on EXPERIMENTAL
 	default n
 	---help---
 	TCP Low Priority (TCP-LP), a distributed algorithm whose goal is
@@ -540,7 +535,6 @@ config TCP_CONG_LP
 
 config TCP_CONG_VENO
 	tristate "TCP Veno"
-	depends on EXPERIMENTAL
 	default n
 	---help---
 	TCP Veno is a sender-side only enhancement of TCP to obtain better
@@ -552,7 +546,6 @@ config TCP_CONG_VENO
 
 config TCP_CONG_YEAH
 	tristate "YeAH TCP"
-	depends on EXPERIMENTAL
 	select TCP_CONG_VEGAS
 	default n
 	---help---
@@ -567,7 +560,6 @@ config TCP_CONG_YEAH
 
 config TCP_CONG_ILLINOIS
 	tristate "TCP Illinois"
-	depends on EXPERIMENTAL
 	default n
 	---help---
 	TCP-Illinois is a sender-side modification of TCP Reno for
@@ -631,8 +623,7 @@ config DEFAULT_TCP_CONG
 	default "cubic"
 
 config TCP_MD5SIG
-	bool "TCP: MD5 Signature Option support (RFC2385) (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	bool "TCP: MD5 Signature Option support (RFC2385)"
 	select CRYPTO
 	select CRYPTO_MD5
 	---help---
diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index fcc543c..0cc85b9 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -287,8 +287,8 @@ config IP_NF_MANGLE
 	  To compile it as a module, choose M here.  If unsure, say N.
 
 config IP_NF_TARGET_CLUSTERIP
-	tristate "CLUSTERIP target support (EXPERIMENTAL)"
-	depends on IP_NF_MANGLE && EXPERIMENTAL
+	tristate "CLUSTERIP target support"
+	depends on IP_NF_MANGLE
 	depends on NF_CONNTRACK_IPV4
 	depends on NETFILTER_ADVANCED
 	select NF_CONNTRACK_MARK
diff --git a/net/ipv6/Kconfig b/net/ipv6/Kconfig
index 5728695..b9b8131 100644
--- a/net/ipv6/Kconfig
+++ b/net/ipv6/Kconfig
@@ -50,16 +50,15 @@ config IPV6_ROUTER_PREF
 	  If unsure, say N.
 
 config IPV6_ROUTE_INFO
-	bool "IPv6: Route Information (RFC 4191) support (EXPERIMENTAL)"
-	depends on IPV6_ROUTER_PREF && EXPERIMENTAL
+	bool "IPv6: Route Information (RFC 4191) support"
+	depends on IPV6_ROUTER_PREF
 	---help---
 	  This is experimental support of Route Information.
 
 	  If unsure, say N.
 
 config IPV6_OPTIMISTIC_DAD
-	bool "IPv6: Enable RFC 4429 Optimistic DAD (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	bool "IPv6: Enable RFC 4429 Optimistic DAD"
 	---help---
 	  This is experimental support for optimistic Duplicate
 	  Address Detection.  It allows for autoconfigured addresses
@@ -105,8 +104,7 @@ config INET6_IPCOMP
 	  If unsure, say Y.
 
 config IPV6_MIP6
-	tristate "IPv6: Mobility (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	tristate "IPv6: Mobility"
 	select XFRM
 	---help---
 	  Support for IPv6 Mobility described in RFC 3775.
@@ -150,8 +148,7 @@ config INET6_XFRM_MODE_BEET
 	  If unsure, say Y.
 
 config INET6_XFRM_MODE_ROUTEOPTIMIZATION
-	tristate "IPv6: MIPv6 route optimization mode (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	tristate "IPv6: MIPv6 route optimization mode"
 	select XFRM
 	---help---
 	  Support for MIPv6 route optimization mode.
@@ -171,8 +168,8 @@ config IPV6_SIT
 	  Saying M here will produce a module called sit. If unsure, say Y.
 
 config IPV6_SIT_6RD
-	bool "IPv6: IPv6 Rapid Deployment (6RD) (EXPERIMENTAL)"
-	depends on IPV6_SIT && EXPERIMENTAL
+	bool "IPv6: IPv6 Rapid Deployment (6RD)"
+	depends on IPV6_SIT
 	default n
 	---help---
 	  IPv6 Rapid Deployment (6rd; draft-ietf-softwire-ipv6-6rd) builds upon
@@ -203,7 +200,6 @@ config IPV6_TUNNEL
 
 config IPV6_MULTIPLE_TABLES
 	bool "IPv6: Multiple Routing Tables"
-	depends on EXPERIMENTAL
 	select FIB_RULES
 	---help---
 	  Support multiple routing tables.
@@ -223,8 +219,8 @@ config IPV6_SUBTREES
 	  If unsure, say N.
 
 config IPV6_MROUTE
-	bool "IPv6: multicast routing (EXPERIMENTAL)"
-	depends on IPV6 && EXPERIMENTAL
+	bool "IPv6: multicast routing"
+	depends on IPV6
 	---help---
 	  Experimental support for IPv6 multicast forwarding.
 	  If unsure, say N.
@@ -244,7 +240,7 @@ config IPV6_MROUTE_MULTIPLE_TABLES
 	  If unsure, say N.
 
 config IPV6_PIMSM_V2
-	bool "IPv6: PIM-SM version 2 support (EXPERIMENTAL)"
+	bool "IPv6: PIM-SM version 2 support"
 	depends on IPV6_MROUTE
 	---help---
 	  Support for IPv6 PIM multicast routing protocol PIM-SMv2.
diff --git a/net/l2tp/Kconfig b/net/l2tp/Kconfig
index 4b1e717..68af9e6 100644
--- a/net/l2tp/Kconfig
+++ b/net/l2tp/Kconfig
@@ -45,8 +45,8 @@ config L2TP_DEBUGFS
 	  will be called l2tp_debugfs.
 
 config L2TP_V3
-	bool "L2TPv3 support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && L2TP
+	bool "L2TPv3 support"
+	depends on L2TP
 	help
 	  Layer Two Tunneling Protocol Version 3
 
diff --git a/net/lapb/Kconfig b/net/lapb/Kconfig
index f0b5efb..6481839 100644
--- a/net/lapb/Kconfig
+++ b/net/lapb/Kconfig
@@ -3,8 +3,7 @@
 #
 
 config LAPB
-	tristate "LAPB Data Link Driver (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	tristate "LAPB Data Link Driver"
 	---help---
 	  Link Access Procedure, Balanced (LAPB) is the data link layer (i.e.
 	  the lower) part of the X.25 protocol. It offers a reliable
diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
index 63af254..e15050e 100644
--- a/net/mac80211/Kconfig
+++ b/net/mac80211/Kconfig
@@ -81,7 +81,7 @@ comment "Some wireless drivers require a rate control algorithm"
 
 config MAC80211_MESH
 	bool "Enable mac80211 mesh networking (pre-802.11s) support"
-	depends on MAC80211 && EXPERIMENTAL
+	depends on MAC80211
 	---help---
 	 This options enables support of Draft 802.11s mesh networking.
 	 The implementation is based on Draft 2.08 of the Mesh Networking
diff --git a/net/mac802154/Kconfig b/net/mac802154/Kconfig
index a967dda..b33dd76 100644
--- a/net/mac802154/Kconfig
+++ b/net/mac802154/Kconfig
@@ -1,6 +1,6 @@
 config MAC802154
 	tristate "Generic IEEE 802.15.4 Soft Networking Stack (mac802154)"
-	depends on IEEE802154 && EXPERIMENTAL
+	depends on IEEE802154
 	select CRC_CCITT
 	---help---
 	  This option enables the hardware independent IEEE 802.15.4
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index c19b214..2e69aea 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -125,8 +125,7 @@ config NF_CONNTRACK_TIMESTAMP
 	  If unsure, say `N'.
 
 config NF_CT_PROTO_DCCP
-	tristate 'DCCP protocol connection tracking support (EXPERIMENTAL)'
-	depends on EXPERIMENTAL
+	tristate 'DCCP protocol connection tracking support'
 	depends on NETFILTER_ADVANCED
 	default IP_DCCP
 	help
@@ -139,8 +138,7 @@ config NF_CT_PROTO_GRE
 	tristate
 
 config NF_CT_PROTO_SCTP
-	tristate 'SCTP protocol connection tracking support (EXPERIMENTAL)'
-	depends on EXPERIMENTAL
+	tristate 'SCTP protocol connection tracking support'
 	depends on NETFILTER_ADVANCED
 	default IP_SCTP
 	help
@@ -281,8 +279,7 @@ config NF_CONNTRACK_PPTP
 	  To compile it as a module, choose M here.  If unsure, say N.
 
 config NF_CONNTRACK_SANE
-	tristate "SANE protocol support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	tristate "SANE protocol support"
 	depends on NETFILTER_ADVANCED
 	help
 	  SANE is a protocol for remote access to scanners as implemented
@@ -360,8 +357,7 @@ endif # NF_CONNTRACK
 
 # transparent proxy support
 config NETFILTER_TPROXY
-	tristate "Transparent proxying support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	tristate "Transparent proxying support"
 	depends on IP_NF_MANGLE
 	depends on NETFILTER_ADVANCED
 	help
@@ -654,8 +650,7 @@ config NETFILTER_XT_TARGET_TEE
 	this clone be rerouted to another nexthop.
 
 config NETFILTER_XT_TARGET_TPROXY
-	tristate '"TPROXY" target support (EXPERIMENTAL)'
-	depends on EXPERIMENTAL
+	tristate '"TPROXY" target support'
 	depends on NETFILTER_TPROXY
 	depends on NETFILTER_XTABLES
 	depends on NETFILTER_ADVANCED
@@ -719,8 +714,7 @@ config NETFILTER_XT_TARGET_TCPMSS
 	  To compile it as a module, choose M here.  If unsure, say N.
 
 config NETFILTER_XT_TARGET_TCPOPTSTRIP
-	tristate '"TCPOPTSTRIP" target support (EXPERIMENTAL)'
-	depends on EXPERIMENTAL
+	tristate '"TCPOPTSTRIP" target support'
 	depends on IP_NF_MANGLE || IP6_NF_MANGLE
 	depends on NETFILTER_ADVANCED
 	help
@@ -1081,8 +1075,7 @@ config NETFILTER_XT_MATCH_RECENT
 	Official Website: <http://snowman.net/projects/ipt_recent/>
 
 config NETFILTER_XT_MATCH_SCTP
-	tristate  '"sctp" protocol match support (EXPERIMENTAL)'
-	depends on EXPERIMENTAL
+	tristate  '"sctp" protocol match support'
 	depends on NETFILTER_ADVANCED
 	default IP_SCTP
 	help
@@ -1094,8 +1087,7 @@ config NETFILTER_XT_MATCH_SCTP
 	  <file:Documentation/kbuild/modules.txt>.  If unsure, say `N'.
 
 config NETFILTER_XT_MATCH_SOCKET
-	tristate '"socket" match support (EXPERIMENTAL)'
-	depends on EXPERIMENTAL
+	tristate '"socket" match support'
 	depends on NETFILTER_TPROXY
 	depends on NETFILTER_XTABLES
 	depends on NETFILTER_ADVANCED
diff --git a/net/nfc/Kconfig b/net/nfc/Kconfig
index 8d8d9bc..60c3bbb 100644
--- a/net/nfc/Kconfig
+++ b/net/nfc/Kconfig
@@ -3,8 +3,8 @@
 #
 
 menuconfig NFC
-	depends on NET && EXPERIMENTAL
-	tristate "NFC subsystem support (EXPERIMENTAL)"
+	depends on NET
+	tristate "NFC subsystem support"
 	default n
 	help
 	  Say Y here if you want to build support for NFC (Near field
diff --git a/net/nfc/llcp/Kconfig b/net/nfc/llcp/Kconfig
index fbf5e81..a1a41cd 100644
--- a/net/nfc/llcp/Kconfig
+++ b/net/nfc/llcp/Kconfig
@@ -1,6 +1,6 @@
 config NFC_LLCP
-       depends on NFC && EXPERIMENTAL
-       bool "NFC LLCP support (EXPERIMENTAL)"
+       depends on NFC
+       bool "NFC LLCP support"
        default n
        help
 	 Say Y here if you want to build support for a kernel NFC LLCP
diff --git a/net/nfc/nci/Kconfig b/net/nfc/nci/Kconfig
index decdc49..6d69b5f 100644
--- a/net/nfc/nci/Kconfig
+++ b/net/nfc/nci/Kconfig
@@ -1,6 +1,6 @@
 config NFC_NCI
-	depends on NFC && EXPERIMENTAL
-	tristate "NCI protocol support (EXPERIMENTAL)"
+	depends on NFC
+	tristate "NCI protocol support"
 	default n
 	help
 	  NCI (NFC Controller Interface) is a communication protocol between
diff --git a/net/rds/Kconfig b/net/rds/Kconfig
index ec753b3..f2c670b 100644
--- a/net/rds/Kconfig
+++ b/net/rds/Kconfig
@@ -1,7 +1,7 @@
 
 config RDS
-	tristate "The RDS Protocol (EXPERIMENTAL)"
-	depends on INET && EXPERIMENTAL
+	tristate "The RDS Protocol"
+	depends on INET
 	---help---
 	  The RDS (Reliable Datagram Sockets) protocol provides reliable,
 	  sequenced delivery of datagrams over Infiniband, iWARP,
diff --git a/net/rxrpc/Kconfig b/net/rxrpc/Kconfig
index 0d3103c..23dcef1 100644
--- a/net/rxrpc/Kconfig
+++ b/net/rxrpc/Kconfig
@@ -4,7 +4,7 @@
 
 config AF_RXRPC
 	tristate "RxRPC session sockets"
-	depends on INET && EXPERIMENTAL
+	depends on INET
 	select CRYPTO
 	select KEYS
 	help
diff --git a/net/sctp/Kconfig b/net/sctp/Kconfig
index 126b014..0e13f54 100644
--- a/net/sctp/Kconfig
+++ b/net/sctp/Kconfig
@@ -3,8 +3,8 @@
 #
 
 menuconfig IP_SCTP
-	tristate "The SCTP Protocol (EXPERIMENTAL)"
-	depends on INET && EXPERIMENTAL
+	tristate "The SCTP Protocol"
+	depends on INET
 	depends on IPV6 || IPV6=n
 	select CRYPTO
 	select CRYPTO_HMAC
diff --git a/net/sunrpc/Kconfig b/net/sunrpc/Kconfig
index 03d03e3..516fe2c 100644
--- a/net/sunrpc/Kconfig
+++ b/net/sunrpc/Kconfig
@@ -10,7 +10,7 @@ config SUNRPC_BACKCHANNEL
 
 config SUNRPC_XPRT_RDMA
 	tristate
-	depends on SUNRPC && INFINIBAND && INFINIBAND_ADDR_TRANS && EXPERIMENTAL
+	depends on SUNRPC && INFINIBAND && INFINIBAND_ADDR_TRANS
 	default SUNRPC && INFINIBAND
 	help
 	  This option allows the NFS client and server to support
diff --git a/net/tipc/Kconfig b/net/tipc/Kconfig
index 5854601..51faafc 100644
--- a/net/tipc/Kconfig
+++ b/net/tipc/Kconfig
@@ -3,8 +3,8 @@
 #
 
 menuconfig TIPC
-	tristate "The TIPC Protocol (EXPERIMENTAL)"
-	depends on INET && EXPERIMENTAL
+	tristate "The TIPC Protocol"
+	depends on INET
 	---help---
 	  The Transparent Inter Process Communication (TIPC) protocol is
 	  specially designed for intra cluster communication. This protocol
diff --git a/net/wanrouter/Kconfig b/net/wanrouter/Kconfig
index a157a2e..fc1bd40 100644
--- a/net/wanrouter/Kconfig
+++ b/net/wanrouter/Kconfig
@@ -4,7 +4,6 @@
 
 config WAN_ROUTER
 	tristate "WAN router (DEPRECATED)"
-	depends on EXPERIMENTAL
 	---help---
 	  Wide Area Networks (WANs), such as X.25, frame relay and leased
 	  lines, are used to interconnect Local Area Networks (LANs) over vast
diff --git a/net/x25/Kconfig b/net/x25/Kconfig
index e6759c9..c959312 100644
--- a/net/x25/Kconfig
+++ b/net/x25/Kconfig
@@ -3,8 +3,7 @@
 #
 
 config X25
-	tristate "CCITT X.25 Packet Layer (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	tristate "CCITT X.25 Packet Layer"
 	---help---
 	  X.25 is a set of standardized network protocols, similar in scope to
 	  frame relay; the one physical line from your box to the X.25 network
diff --git a/net/xfrm/Kconfig b/net/xfrm/Kconfig
index ce90b8d..bda1a13 100644
--- a/net/xfrm/Kconfig
+++ b/net/xfrm/Kconfig
@@ -21,8 +21,8 @@ config XFRM_USER
 	  If unsure, say Y.
 
 config XFRM_SUB_POLICY
-	bool "Transformation sub policy support (EXPERIMENTAL)"
-	depends on XFRM && EXPERIMENTAL
+	bool "Transformation sub policy support"
+	depends on XFRM
 	---help---
 	  Support sub policy for developers. By using sub policy with main
 	  one, two policies can be applied to the same packet at once.
@@ -31,8 +31,8 @@ config XFRM_SUB_POLICY
 	  If unsure, say N.
 
 config XFRM_MIGRATE
-	bool "Transformation migrate database (EXPERIMENTAL)"
-	depends on XFRM && EXPERIMENTAL
+	bool "Transformation migrate database"
+	depends on XFRM
 	---help---
 	  A feature to update locator(s) of a given IPsec security
 	  association dynamically.  This feature is required, for
@@ -42,8 +42,8 @@ config XFRM_MIGRATE
 	  If unsure, say N.
 
 config XFRM_STATISTICS
-	bool "Transformation statistics (EXPERIMENTAL)"
-	depends on INET && XFRM && PROC_FS && EXPERIMENTAL
+	bool "Transformation statistics"
+	depends on INET && XFRM && PROC_FS
 	---help---
 	  This statistics is not a SNMP/MIB specification but shows
 	  statistics about transformation error (or almost error) factor
@@ -68,8 +68,8 @@ config NET_KEY
 	  Say Y unless you know what you are doing.
 
 config NET_KEY_MIGRATE
-	bool "PF_KEY MIGRATE (EXPERIMENTAL)"
-	depends on NET_KEY && EXPERIMENTAL
+	bool "PF_KEY MIGRATE"
+	depends on NET_KEY
 	select XFRM_MIGRATE
 	---help---
 	  Add a PF_KEY MIGRATE message to PF_KEYv2 socket family.
diff --git a/sound/drivers/Kconfig b/sound/drivers/Kconfig
index fe5ae09..5e43841 100644
--- a/sound/drivers/Kconfig
+++ b/sound/drivers/Kconfig
@@ -35,7 +35,6 @@ config SND_PCSP
 	tristate "PC-Speaker support (READ HELP!)"
 	depends on PCSPKR_PLATFORM && X86 && HIGH_RES_TIMERS
 	depends on INPUT
-	depends on EXPERIMENTAL
 	select SND_PCM
 	help
 	  If you don't have a sound card in your computer, you can include a
diff --git a/sound/isa/Kconfig b/sound/isa/Kconfig
index 52064cf..7429af3 100644
--- a/sound/isa/Kconfig
+++ b/sound/isa/Kconfig
@@ -413,7 +413,7 @@ config SND_WAVEFRONT
 
 config SND_MSND_PINNACLE
 	tristate "Turtle Beach MultiSound Pinnacle/Fiji driver"
-	depends on X86 && EXPERIMENTAL
+	depends on X86
 	select FW_LOADER
 	select SND_MPU401_UART
 	select SND_PCM
@@ -426,7 +426,7 @@ config SND_MSND_PINNACLE
 
 config SND_MSND_CLASSIC
 	tristate "Support for Turtle Beach MultiSound Classic, Tahiti, Monterey"
-	depends on X86 && EXPERIMENTAL
+	depends on X86
 	select FW_LOADER
 	select SND_MPU401_UART
 	select SND_PCM
diff --git a/sound/pci/hda/Kconfig b/sound/pci/hda/Kconfig
index 194d625..0013a04 100644
--- a/sound/pci/hda/Kconfig
+++ b/sound/pci/hda/Kconfig
@@ -37,8 +37,8 @@ config SND_HDA_HWDEP
 	  with codecs for debugging purposes.
 
 config SND_HDA_RECONFIG
-	bool "Allow dynamic codec reconfiguration (EXPERIMENTAL)"
-	depends on SND_HDA_HWDEP && EXPERIMENTAL
+	bool "Allow dynamic codec reconfiguration"
+	depends on SND_HDA_HWDEP
 	help
 	  Say Y here to enable the HD-audio codec re-configuration feature.
 	  This adds the sysfs interfaces to allow user to clear the whole
@@ -72,7 +72,6 @@ config SND_HDA_INPUT_JACK
 
 config SND_HDA_PATCH_LOADER
 	bool "Support initialization patch loading for HD-audio"
-	depends on EXPERIMENTAL
 	select FW_LOADER
 	select SND_HDA_HWDEP
 	select SND_HDA_RECONFIG
diff --git a/sound/soc/fsl/Kconfig b/sound/soc/fsl/Kconfig
index d701330..0276250 100644
--- a/sound/soc/fsl/Kconfig
+++ b/sound/soc/fsl/Kconfig
@@ -112,7 +112,7 @@ config SND_SOC_IMX_AUDMUX
 
 config SND_MXC_SOC_WM1133_EV1
 	tristate "Audio on the i.MX31ADS with WM1133-EV1 fitted"
-	depends on MACH_MX31ADS_WM1133_EV1 && EXPERIMENTAL
+	depends on MACH_MX31ADS_WM1133_EV1
 	select SND_SOC_WM8350
 	select SND_SOC_IMX_PCM_FIQ
 	select SND_SOC_IMX_AUDMUX
diff --git a/sound/usb/Kconfig b/sound/usb/Kconfig
index ff77b28..225dfd7 100644
--- a/sound/usb/Kconfig
+++ b/sound/usb/Kconfig
@@ -90,7 +90,7 @@ config SND_USB_CAIAQ_INPUT
 
 config SND_USB_US122L
 	tristate "Tascam US-122L USB driver"
-	depends on X86 && EXPERIMENTAL
+	depends on X86
 	select SND_HWDEP
 	select SND_RAWMIDI
 	help
diff --git a/tools/lguest/lguest.txt b/tools/lguest/lguest.txt
index bff0c55..7203ace 100644
--- a/tools/lguest/lguest.txt
+++ b/tools/lguest/lguest.txt
@@ -29,10 +29,6 @@ Running Lguest:
 
   You will need to configure your kernel with the following options:
 
-  "General setup":
-     "Prompt for development and/or incomplete code/drivers" = Y
-        (CONFIG_EXPERIMENTAL=y)
-
   "Processor type and features":
      "Paravirtualized guest support" = Y
         "Lguest guest support" = Y
@@ -43,10 +39,10 @@ Running Lguest:
 
   "Device Drivers":
      "Block devices"
-        "Virtio block driver (EXPERIMENTAL)" = M/Y
+        "Virtio block driver" = M/Y
      "Network device support"
         "Universal TUN/TAP device driver support" = M/Y
-        "Virtio network driver (EXPERIMENTAL)" = M/Y
+        "Virtio network driver" = M/Y
            (CONFIG_VIRTIO_BLK=m, CONFIG_VIRTIO_NET=m and CONFIG_TUN=m)
 
   "Virtualization"
-- 
1.7.0.4


-- 
Kees Cook
Chrome OS Security
