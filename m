Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064Ab2JOLil (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 07:38:41 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:54781 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616Ab2JOLhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 07:37:47 -0400
MIME-Version: 1.0
In-Reply-To: <CALF0-+Xg2GMCK3c7qpgH5pZq=EdcGf=zHJdS5SGSqLpOSRhbQA@mail.gmail.com>
References: <CABjyUiLyfHFE6ew5JPaH4YSz5k1sm4HnZFm4e12v=_Pcp6jGNw@mail.gmail.com>
	<CALF0-+WP8_uLqFjSJ5YJ4_Hrpk2Y1+U_mx=baeGWSTpw+kTw2Q@mail.gmail.com>
	<CALF0-+Xg2GMCK3c7qpgH5pZq=EdcGf=zHJdS5SGSqLpOSRhbQA@mail.gmail.com>
Date: Mon, 15 Oct 2012 08:37:47 -0300
Message-ID: <CALF0-+X1VBfCi--=Dcc5163BCGCUQMPc=cADKg26T+j=jAwfSg@mail.gmail.com>
Subject: Re: PROBLEM: Ali m5602 won't compile (3.4.9-gentoo)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Yuriy Davygora <davygora@googlemail.com>
Cc: linux-media <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yuri,

On Mon, Oct 15, 2012 at 7:55 AM, Ezequiel Garcia <elezegarcia@gmail.com> wrote:
> On Sun, Oct 14, 2012 at 11:39 AM, Yuriy Davygora
> <davygora@googlemail.com> wrote:
>>   Hello,
>>
>>   I have trouble compiling the 3.4.9 kernel with genkernel (gentoo)
>> having enabled the Ali Corp webcam (m5602) driver.
>>
>>   Here's the output of the ver_linux script:
>>
>> =================================
>>
>> yuriy-newlaptop linux # sh scripts/ver_linux
>> If some fields are empty or look unusual you may have an old version.
>> Compare to the current minimal requirements in Documentation/Changes.
>>
>> Linux yuriy-newlaptop 3.4.9-gentoo #1 SMP Sat Oct 13 10:01:59 CEST
>> 2012 x86_64 Intel(R) Core(TM) i3 CPU M 380 @ 2.53GHz GenuineIntel
>> GNU/Linux
>>
>> Gnu C                  4.5.4
>> Gnu make               3.82
>> binutils               2.22
>> util-linux             2.21.2
>> mount                  support
>> module-init-tools      3.16
>> e2fsprogs              1.42
>> Linux C Library        2.15
>> Dynamic linker (ldd)   2.15
>> Procps                 3.2.8
>> Net-tools              1.60_p20110409135728
>> Kbd                    1.15.3wip
>> Sh-utils               8.16
>> wireless-tools         29
>> Modules Loaded         ipv6 acpi_cpufreq i2c_i801 coretemp joydev
>> freq_table battery ac pcspkr microcode mperf processor thermal
>> sha256_generic libiscsi scsi_transport_iscsi tg3 libphy e1000 fuse nfs
>> lockd sunrpc jfs raid10 raid456 async_raid6_recov async_memcpy
>> async_pq async_xor xor async_tx raid6_pq raid1 raid0 dm_snapshot
>> dm_crypt dm_mirror dm_region_hash dm_log dm_mod scsi_wait_scan
>> hid_sunplus hid_sony hid_samsung hid_pl hid_petalynx hid_monterey
>> hid_microsoft hid_logitech hid_gyration hid_ezkey hid_cypress
>> hid_chicony hid_cherry hid_belkin hid_apple hid_a4tech sl811_hcd
>> usbhid ohci_hcd ssb uhci_hcd usb_storage ehci_hcd usbcore usb_common
>> aic94xx libsas qla2xxx megaraid_sas megaraid_mbox megaraid_mm megaraid
>> aacraid sx8 DAC960 cciss 3w_9xxx 3w_xxxx mptsas scsi_transport_sas
>> mptfc scsi_transport_fc scsi_tgt mptspi mptscsih mptbase atp870u
>> dc395x qla1280 imm parport dmx3191d sym53c8xx gdth advansys initio
>> BusLogic arcmsr aic7xxx aic79xx scsi_transport_spi sg pdc_adma
>> sata_inic162x sata_mv ata_piix ahci libahci sata_qstor sata_vsc
>> sata_uli sata_sis sata_sx4 sata_nv sata_via sata_svw sata_sil24
>> sata_sil sata_promise pata_sl82c105 pata_cs5530 pata_cs5520 pata_via
>> pata_jmicron pata_marvell pata_sis pata_netcell pata_sc1200
>> pata_pdc202xx_old pata_triflex pata_atiixp pata_opti pata_amd pata_ali
>> pata_it8213 pata_pcmcia pcmcia pcmcia_core pata_ns87415 pata_ns87410
>> pata_serverworks pata_artop pata_it821x pata_optidma pata_hpt3x2n
>> pata_hpt3x3 pata_hpt37x pata_hpt366 pata_cmd64x pata_efar pata_rz1000
>> pata_sil680 pata_radisys pata_pdc2027x pata_mpiix libata
>>
>> =================================
>>
>>   My current kernel configuration is attached to this mail. What I
>> tried to do, was to enable the Ali Corp webcam (m5602) driver using
>> menuconfig as follows:
>>
>>   Device Drivers --->
>>     <*> Multimedia Support --->
>>       <*> Video For Linux (NEW)
>>       [*] Video capture adapters (NEW) --->
>>         [*] V4L USB devices (NEW) --->
>>           <*> GSPCA based webcams (NEW) --->
>>             <*> Ali USB m5602 Camera Driver
>>
>

The problem is not the compilation, but the linking step.

$ make
make[1]: Nothing to be done for `all'.
make[1]: Nothing to be done for `relocs'.
  CHK     include/linux/version.h
  CHK     include/generated/utsrelease.h
  CALL    scripts/checksyscalls.sh
  CHK     include/generated/compile.h
  CHK     kernel/config_data.h
  CC      drivers/media/video/gspca/gspca.o
  LD      drivers/media/video/gspca/gspca_main.o
  CC      drivers/media/video/gspca/m5602/m5602_core.o
  CC      drivers/media/video/gspca/m5602/m5602_ov9650.o
  CC      drivers/media/video/gspca/m5602/m5602_ov7660.o
  CC      drivers/media/video/gspca/m5602/m5602_mt9m111.o
  CC      drivers/media/video/gspca/m5602/m5602_po1030.o
  CC      drivers/media/video/gspca/m5602/m5602_s5k83a.o
  CC      drivers/media/video/gspca/m5602/m5602_s5k4aa.o
  LD      drivers/media/video/gspca/m5602/gspca_m5602.o
  LD      drivers/media/video/gspca/m5602/built-in.o
  LD      drivers/media/video/gspca/built-in.o
  LD      drivers/media/video/built-in.o
  LD      drivers/media/built-in.o
  LD      drivers/built-in.o
  LD      vmlinux.o
  MODPOST vmlinux.o
  GEN     .version
  CHK     include/generated/compile.h
  UPD     include/generated/compile.h
  CC      init/version.o
  LD      init/built-in.o
  LD      .tmp_vmlinux1
drivers/built-in.o: In function `isoc_irq':
gspca.c:(.text+0x12ff4b): undefined reference to `usb_submit_urb'
drivers/built-in.o: In function `gspca_input_create_urb':
gspca.c:(.text+0x12ff91): undefined reference to `usb_ifnum_to_if'
gspca.c:(.text+0x12ffe1): undefined reference to `usb_alloc_urb'
gspca.c:(.text+0x130003): undefined reference to `usb_alloc_coherent'
gspca.c:(.text+0x13007d): undefined reference to `usb_submit_urb'
gspca.c:(.text+0x13009a): undefined reference to `usb_free_coherent'
gspca.c:(.text+0x1300a2): undefined reference to `usb_free_urb'
[snip]
---

The reason is you are choosing gspca as built-in, but usb as module.
Just choose gspca + m5602 as module and it will be solved.

However, I'm not sure how to fix this (if it's at all fixable).

    Ezequiel
