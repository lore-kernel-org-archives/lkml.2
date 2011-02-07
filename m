Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368Ab1BGRPd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 12:15:33 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36367 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753333Ab1BGRPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 12:15:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=kT5L+QLobnAIL7B/TzP7l+QgIEA/dSLyv4SZ92DB4htIhygk994F88GDuvGd9ViT/l
         oT4kaKoyDBl2zinCj5jJPAqo9OuQp4SI5j5DGIyBGsDsh3YNDPQyJ9HPMgFXIx69/IYA
         /yZ3Aousql+ZvIjiNPk2FvGl0/luTeuiOyqDI=
Date: Tue, 8 Feb 2011 01:15:28 +0800
From: Harry Wei <jiaweiwei.xiyou@gmail.com>
To: linux-kernel@vger.kernel.org, greg@kroah.com
Subject: [PATCH]Translated linux-2.6/Documentation/magic-number.txt into
 Chinese
Message-ID: <20110207171526.GB5223@gmail.com>
References: <20110207075809.GA16214@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110207075809.GA16214@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 07, 2011 at 03:58:15PM +0800, Harry Wei wrote:
> Hi us,
>    I have translated linux-2.6/Documentation/magic-number.txt into Chinese.
> When i paste the patch into my mutt, something wrong happened, which i can not close this mail. The mutt shows something wrong about /tmp/...
>    So i have to add an accessory including my patcher. If you don't want to download it, you can also click the URL: http://harrywei.org/blog/?p=46
> for it.
> 
> Thanks.
> Best Regards.
> Harry Wei.
> Home Page: www.harrywei.org
> 

> Signed-off-by: Harry Wei <harryxiyou@gmail.com>
> ---
>  Documentation/zh_CN/magic-number.txt |  167 ++++++++++++++++++++++++++++++++++
>  1 files changed, 167 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/zh_CN/magic-number.txt
> 
> diff --git a/Documentation/zh_CN/magic-number.txt b/Documentation/zh_CN/magic-number.txt
> new file mode 100644
> index 0000000..703dba9
> --- /dev/null
> +++ b/Documentation/zh_CN/magic-number.txt
> @@ -0,0 +1,167 @@
> +Chinese translated version of Documentation/magic-number.txt
> +
> +If you have any comment or update to the content, please post to LKML directly.
> +However, if you have problem communicating in English you can also ask the
> +Chinese maintainer for help.  Contact the Chinese maintainer, if this
> +translation is outdated or there is problem with translation.
> +
> +Chinese maintainer: Jia Wei Wei <harryxiyou@gmail.com>
> +---------------------------------------------------------------------
> +Documentation/magic-number.txt的中文翻译
> +
> +如果想评论或更新本文的内容，请直接发信到LKML。如果你使用英文交流有困难的话，也可
> +以向中文版维护者求助。如果本翻译更新不及时或者翻译存在问题，请联系中文版维护者。
> +
> +中文版维护者： 贾威威 Jia Wei Wei <harryxiyou@gmail.com>
> +中文版翻译者： 贾威威 Jia Wei Wei <harryxiyou@gmail.com>
> +中文版校译者： 贾威威 Jia Wei Wei <harryxiyou@gmail.com>
> +
> +以下为正文
> +---------------------------------------------------------------------
> +这个文件是有关当前使用的魔术值注册表。当你给一个结构添加了一个魔术值，你也应该把这个魔术值添加到这个文件，因为我们最好把用于各种结构的魔术值统一起来。
> +
> +使用魔术值来保护内核数据结构是一个非常好的主意。这就允许你在运行期检查(a)一个结构是否已经被攻击，或者(b)你已经给一个例行程序通过了一个错误的结构。后一种情况特别地有用---特别是当你通过一个空指针指向结构体的时候。tty源码，例如，经常通过特定驱动使用这种方法并且反复地排列特定方面的结构。
We should use "例如tty的代码中就经常使用这种方法来传递一些驱动相关或者线路特性相关的数据结构。" instead of "tty源码，例如，经常通过特定驱动使用这种方法并且反复地排列特定方面的结构。" so that it is better for understanding.
> +
> +使用魔术值的方法是在结构的开始处声明的，如下：
> +
> +struct tty_ldisc {
> +	int	magic;
> +	...
> +};
> +
> +当你以后给内核添加增强功能的时候，请遵守这条规则！这样就会节省数不清的调试时间，特别是一些古怪的情况，例如，数组超出范围并且重新写了超出部分。遵守这个规则，‪这些情况可以被快速地，安全地避免。
> +
> +		Theodore Ts'o
> +		  31 Mar 94
> +
> +给当前的Linux 2.1.55添加魔术表。
> +
> +		Michael Chastain
> +		<mailto:mec@shout.net>
> +		22 Sep 1997
> +
> +现在应该最新的Linux 2.1.112.因为在特性冻结期间，不能在2.2.x前改变任何东西。这些条目被数域所排序。
> +
> +		Krzysztof G.Baranowski
> +	        <mailto: kgb@knm.org.pl>
> +		29 Jul 1998
> +
> +更新魔术表到Linux 2.5.45。刚好越过特性冻结，但是有可能还会有一些新的魔术值在2.6.x之前融入到内核中。
> +
> +		Petr Baudis
> +		<pasky@ucw.cz>
> +		03 Nov 2002
> +
> +更新魔术表到Linux 2.5.74。
> +
> +		Fabian Frederick
> +                <ffrederick@users.sourceforge.net>
> +		09 Jul 2003
> +
> +魔术名                 地址         结构               所在文件
> +===========================================================================
> +PG_MAGIC              'P'         pg_{read,write}_hdr include/linux/pg.h
> +CMAGIC                0x0111      user              include/linux/a.out.h
> +MKISS_DRIVER_MAGIC    0x04bf      mkiss_channel     drivers/net/mkiss.h
> +RISCOM8_MAGIC         0x0907      riscom_port       drivers/char/riscom8.h
> +SPECIALIX_MAGIC       0x0907      specialix_port    drivers/char/specialix_io8.h
> +HDLC_MAGIC            0x239e      n_hdlc            drivers/char/n_hdlc.c
> +APM_BIOS_MAGIC        0x4101      apm_user          arch/i386/kernel/apm.c
> +CYCLADES_MAGIC        0x4359      cyclades_port     include/linux/cyclades.h
> +DB_MAGIC              0x4442      fc_info           drivers/net/iph5526_novram.c
> +DL_MAGIC              0x444d      fc_info           drivers/net/iph5526_novram.c
> +FASYNC_MAGIC          0x4601      fasync_struct     include/linux/fs.h
> +FF_MAGIC              0x4646      fc_info           drivers/net/iph5526_novram.c
> +ISICOM_MAGIC          0x4d54      isi_port          include/linux/isicom.h
> +PTY_MAGIC             0x5001                        drivers/char/pty.c
> +PPP_MAGIC             0x5002      ppp               include/linux/if_pppvar.h
> +SERIAL_MAGIC          0x5301      async_struct      include/linux/serial.h
> +SSTATE_MAGIC          0x5302      serial_state      include/linux/serial.h
> +SLIP_MAGIC            0x5302      slip              drivers/net/slip.h
> +STRIP_MAGIC           0x5303      strip             drivers/net/strip.c
> +X25_ASY_MAGIC         0x5303      x25_asy           drivers/net/x25_asy.h
> +SIXPACK_MAGIC         0x5304      sixpack           drivers/net/hamradio/6pack.h
> +AX25_MAGIC            0x5316      ax_disp           drivers/net/mkiss.h
> +ESP_MAGIC             0x53ee      esp_struct        drivers/char/esp.h
> +TTY_MAGIC             0x5401      tty_struct        include/linux/tty.h
> +MGSL_MAGIC            0x5401      mgsl_info         drivers/char/synclink.c
> +TTY_DRIVER_MAGIC      0x5402      tty_driver        include/linux/tty_driver.h
> +MGSLPC_MAGIC          0x5402      mgslpc_info       drivers/char/pcmcia/synclink_cs.c
> +TTY_LDISC_MAGIC       0x5403      tty_ldisc         include/linux/tty_ldisc.h
> +USB_SERIAL_MAGIC      0x6702      usb_serial        drivers/usb/serial/usb-serial.h
> +FULL_DUPLEX_MAGIC     0x6969                        drivers/net/tulip/de2104x.c
> +USB_BLUETOOTH_MAGIC   0x6d02      usb_bluetooth     drivers/usb/class/bluetty.c
> +RFCOMM_TTY_MAGIC      0x6d02                        net/bluetooth/rfcomm/tty.c
> +USB_SERIAL_PORT_MAGIC 0x7301      usb_serial_port   drivers/usb/serial/usb-serial.h
> +CG_MAGIC              0x00090255  ufs_cylinder_group include/linux/ufs_fs.h
> +A2232_MAGIC           0x000a2232  gs_port           drivers/char/ser_a2232.h
> +RPORT_MAGIC           0x00525001  r_port            drivers/char/rocket_int.h
> +LSEMAGIC              0x05091998  lse               drivers/fc4/fc.c
> +GDTIOCTL_MAGIC        0x06030f07  gdth_iowr_str     drivers/scsi/gdth_ioctl.h
> +RIEBL_MAGIC           0x09051990                    drivers/net/atarilance.c
> +RIO_MAGIC             0x12345678  gs_port           drivers/char/rio/rio_linux.c
> +SX_MAGIC              0x12345678  gs_port           drivers/char/sx.h
> +NBD_REQUEST_MAGIC     0x12560953  nbd_request       include/linux/nbd.h
> +RED_MAGIC2            0x170fc2a5  (any)             mm/slab.c
> +BAYCOM_MAGIC          0x19730510  baycom_state      drivers/net/baycom_epp.c
> +ISDN_X25IFACE_MAGIC   0x1e75a2b9  isdn_x25iface_proto_data
> +                                                    drivers/isdn/isdn_x25iface.h
> +ECP_MAGIC             0x21504345  cdkecpsig         include/linux/cdk.h
> +LSOMAGIC              0x27091997  lso               drivers/fc4/fc.c
> +LSMAGIC               0x2a3b4d2a  ls                drivers/fc4/fc.c
> +WANPIPE_MAGIC         0x414C4453  sdla_{dump,exec}  include/linux/wanpipe.h
> +CS_CARD_MAGIC         0x43525553  cs_card           sound/oss/cs46xx.c
> +LABELCL_MAGIC         0x4857434c  labelcl_info_s    include/asm/ia64/sn/labelcl.h
> +ISDN_ASYNC_MAGIC      0x49344C01  modem_info        include/linux/isdn.h
> +CTC_ASYNC_MAGIC       0x49344C01  ctc_tty_info      drivers/s390/net/ctctty.c
> +ISDN_NET_MAGIC        0x49344C02  isdn_net_local_s  drivers/isdn/i4l/isdn_net_lib.h
> +SAVEKMSG_MAGIC2       0x4B4D5347  savekmsg          arch/*/amiga/config.c
> +STLI_BOARDMAGIC       0x4bc6c825  stlibrd           include/linux/istallion.h
> +CS_STATE_MAGIC        0x4c4f4749  cs_state          sound/oss/cs46xx.c
> +SLAB_C_MAGIC          0x4f17a36d  kmem_cache        mm/slab.c
> +COW_MAGIC             0x4f4f4f4d  cow_header_v1     arch/um/drivers/ubd_user.c
> +I810_CARD_MAGIC       0x5072696E  i810_card         sound/oss/i810_audio.c
> +TRIDENT_CARD_MAGIC    0x5072696E  trident_card      sound/oss/trident.c
> +ROUTER_MAGIC          0x524d4157  wan_device        include/linux/wanrouter.h
> +SCC_MAGIC             0x52696368  gs_port           drivers/char/scc.h
> +SAVEKMSG_MAGIC1       0x53415645  savekmsg          arch/*/amiga/config.c
> +GDA_MAGIC             0x58464552  gda               arch/mips/include/asm/sn/gda.h
> +RED_MAGIC1            0x5a2cf071  (any)             mm/slab.c
> +STL_PORTMAGIC         0x5a7182c9  stlport           include/linux/stallion.h
> +EEPROM_MAGIC_VALUE    0x5ab478d2  lanai_dev         drivers/atm/lanai.c
> +HDLCDRV_MAGIC         0x5ac6e778  hdlcdrv_state     include/linux/hdlcdrv.h
> +EPCA_MAGIC            0x5c6df104  channel           include/linux/epca.h
> +PCXX_MAGIC            0x5c6df104  channel           drivers/char/pcxx.h
> +KV_MAGIC              0x5f4b565f  kernel_vars_s     arch/mips/include/asm/sn/klkernvars.h
> +I810_STATE_MAGIC      0x63657373  i810_state        sound/oss/i810_audio.c
> +TRIDENT_STATE_MAGIC   0x63657373  trient_state      sound/oss/trident.c
> +M3_CARD_MAGIC         0x646e6f50  m3_card           sound/oss/maestro3.c
> +FW_HEADER_MAGIC       0x65726F66  fw_header         drivers/atm/fore200e.h
> +SLOT_MAGIC            0x67267321  slot              drivers/hotplug/cpqphp.h
> +SLOT_MAGIC            0x67267322  slot              drivers/hotplug/acpiphp.h
> +LO_MAGIC              0x68797548  nbd_device        include/linux/nbd.h
> +OPROFILE_MAGIC        0x6f70726f  super_block       drivers/oprofile/oprofilefs.h
> +M3_STATE_MAGIC        0x734d724d  m3_state          sound/oss/maestro3.c
> +STL_PANELMAGIC        0x7ef621a1  stlpanel          include/linux/stallion.h
> +VMALLOC_MAGIC         0x87654320  snd_alloc_track   sound/core/memory.c
> +KMALLOC_MAGIC         0x87654321  snd_alloc_track   sound/core/memory.c
> +PWC_MAGIC             0x89DC10AB  pwc_device        drivers/usb/media/pwc.h
> +NBD_REPLY_MAGIC       0x96744668  nbd_reply         include/linux/nbd.h
> +STL_BOARDMAGIC        0xa2267f52  stlbrd            include/linux/stallion.h
> +ENI155_MAGIC          0xa54b872d  midway_eprom	    drivers/atm/eni.h
> +SCI_MAGIC             0xbabeface  gs_port           drivers/char/sh-sci.h
> +CODA_MAGIC            0xC0DAC0DA  coda_file_info    include/linux/coda_fs_i.h
> +DPMEM_MAGIC           0xc0ffee11  gdt_pci_sram      drivers/scsi/gdth.h
> +STLI_PORTMAGIC        0xe671c7a1  stliport          include/linux/istallion.h
> +YAM_MAGIC             0xF10A7654  yam_port          drivers/net/hamradio/yam.c
> +CCB_MAGIC             0xf2691ad2  ccb               drivers/scsi/ncr53c8xx.c
> +QUEUE_MAGIC_FREE      0xf7e1c9a3  queue_entry       drivers/scsi/arm/queue.c
> +QUEUE_MAGIC_USED      0xf7e1cc33  queue_entry       drivers/scsi/arm/queue.c
> +HTB_CMAGIC            0xFEFAFEF1  htb_class         net/sched/sch_htb.c
> +NMI_MAGIC             0x48414d4d455201 nmi_s        arch/mips/include/asm/sn/nmi.h
> +
> +请注意，在声音记忆管理中仍然有每一些被定义的驱动魔术值。查看include/sound/sndmagic.h来获取他们完整的列表信息。很多OSS声音驱动拥有自己从声卡PCI ID构建的魔术值-他们也没有被列在这里。
> +
> +IrDA子系统也使用了大量的自己的魔术值，查看include/net/irda/irda.h来获取他们完整的信息。
> +
> +HFS是另外一个比较大的使用魔术值的文件系统-你可以在fs/hfs/hfs.h中找到他们。
> -- 
> 1.7.0.4
> 

