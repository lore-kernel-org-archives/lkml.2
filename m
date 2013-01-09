Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835Ab3AIOcs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 09:32:48 -0500
Received: from eu1sys200aog113.obsmtp.com ([207.126.144.135]:41830 "EHLO
	eu1sys200aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755725Ab3AIOcr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 09:32:47 -0500
From: Mathias LEBLANC <Mathias.LEBLANC@st.com>
To: Kent Yoder <key@linux.vnet.ibm.com>
Cc: =?iso-8859-1?Q?Peter_H=FCwe?= <PeterHuewe@gmx.de>,
        Jean-Luc BLANC <jean-luc.blanc@st.com>,
        "Sirrix@jasper.es" <Sirrix@jasper.es>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tpmdd-devel@lists.sourceforge.net" 
	<tpmdd-devel@lists.sourceforge.net>,
        Kent Yoder <shpedoikal@gmail.com>
Date: Wed, 9 Jan 2013 15:31:15 +0100
Subject: RE: [tpmdd-devel] [PATCH 1/1] TPM: STMicroelectronics ST33 I2C
 KERNEL 3.x.x OOPS!
Thread-Topic: [tpmdd-devel] [PATCH 1/1] TPM: STMicroelectronics ST33 I2C
 KERNEL 3.x.x OOPS!
Thread-Index: Ac3txLktUERzSNcKSbeSxB5HbTmV+QAsNEjA
Message-ID: <35286B1AE75A7C47BFF0870081A31B4B3A9E2CB82D@SAFEX1MAIL4.st.com>
References: <1353363322-2923-1-git-send-email-mathias.leblanc@st.com>
 <201212060110.32227.PeterHuewe@gmx.de>
 <20121206150645.GA27430@ennui.austin.ibm.com>
 <201212080500.27146.PeterHuewe@gmx.de>
 <20130108172053.GA11223@ennui.austin.ibm.com>
In-Reply-To: <20130108172053.GA11223@ennui.austin.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

Do you have the I2C configuration activated ?
I have this error when I add the driver in a kernel with no I2C activated

-----Original Message-----
From: Kent Yoder [mailto:key@linux.vnet.ibm.com] 
Sent: 08 January, 2013 18:21
To: Mathias LEBLANC
Cc: Peter Hüwe; Jean-Luc BLANC; Sirrix@jasper.es; linux-kernel@vger.kernel.org; tpmdd-devel@lists.sourceforge.net; Kent Yoder
Subject: Re: [tpmdd-devel] [PATCH 1/1] TPM: STMicroelectronics ST33 I2C KERNEL 3.x.x OOPS!

On Sat, Dec 08, 2012 at 05:00:26AM +0100, Peter Hüwe wrote:
> Hi,
> 
> since I don't have a tpm I simply tried out whether the handling 
> without a tpm is correct, which it unfortunately isn't as my kernel oopses.
> 
> Steps to reproduce:
> # insmod  
> /data/data-old/linux-2.6/drivers/char/tpm/tpm_i2c_stm_st33.ko
> # echo st33zp24_i2c 0x20 /sys/bus/i2c/devices/i2c-1/new_device

  Mathias, can you address this oops?  We can't merge this driver until its resolved.

Kent

> 
> BUG: unable to handle kernel NULL pointer dereference at 
> 0000000000000018
> IP: [<ffffffffa02ff4ad>] tpm_st33_i2c_probe+0x87/0x21a 
> [tpm_i2c_stm_st33] PGD 3dcbbe067 PUD 3e994b067 PMD 0
> Oops: 0002 [#1] PREEMPT SMP
> Modules linked in: tpm_i2c_stm_st33(O) tpm(O) tpm_bios(O) w83627ehf 
> hwmon_vid
> ipv6 snd_hda_codec_hdmi snd_hda_codec_realtek joydev usbhid coretemp 
> kvm_intel kvm ghash_clmulni_intel sg pcspkr snd_hda_intel 
> snd_hda_codec snd_hwdep snd_pcm snd_timer snd i2c_i801 snd_page_alloc mei [last unloaded:
> tpm_i2c_stm_st33]
> CPU 2
> Pid: 4454, comm: bash Tainted: G        W  O 3.6.9 #14 To Be Filled By O.E.M. 
> To Be Filled By O.E.M./Z77 Pro4
> RIP: 0010:[<ffffffffa02ff4ad>]  [<ffffffffa02ff4ad>] 
> tpm_st33_i2c_probe+0x87/0x21a [tpm_i2c_stm_st33]
> RSP: 0018:ffff8803dcb87c18  EFLAGS: 00010286
> RAX: ffff8803eb0d1800 RBX: ffff8803ff710400 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: ffff88041d0026d0 RDI: 0000000000000001
> RBP: ffff8803dcb87c38 R08: 000000000000000b R09: 0000000000000001
> R10: 0000000000000001 R11: ffff8803ff710400 R12: 0000000000000000
> R13: ffff8803ff710c00 R14: ffff8803ff710c28 R15: ffff8803ff710c04
> FS:  00007f520567a700(0000) GS:ffff88041f280000(0000) 
> knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000018 CR3: 00000003e48b0000 CR4: 00000000001407e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400 
> Process bash (pid: 4454, threadinfo ffff8803dcb86000, task 
> ffff8803c87226c0)
> Stack:
>  ffff8803ff710c28 ffffffffa02ffb80 ffffffffa02ff426 ffff8803ff710c00
>  ffff8803dcb87c78 ffffffff8134079a ffffffffa02ffe00 ffff8803ff710c28  
> 00000000ffffffed ffffffffa02ffe00 0000000000000000 ffff88040ebe4460 
> Call Trace:
>  [<ffffffffa02ff426>] ? request_locality+0xc2/0xc2 [tpm_i2c_stm_st33]  
> [<ffffffff8134079a>] i2c_device_probe+0xa4/0xcd  [<ffffffff812b9c24>] 
> driver_probe_device+0xa9/0x1bf  [<ffffffff812b9de9>] 
> __device_attach+0x35/0x3a  [<ffffffff812b9db4>] ? 
> __driver_attach+0x7a/0x7a  [<ffffffff812b84d7>] 
> bus_for_each_drv+0x51/0x87  [<ffffffff812b9b3f>] 
> device_attach+0x6e/0x8e  [<ffffffff812b91b0>] 
> bus_probe_device+0x2d/0x98  [<ffffffff812b7ace>] 
> device_add+0x3e1/0x548  [<ffffffff812bf2b3>] ? 
> device_pm_init+0x60/0x84  [<ffffffff812b7c4c>] 
> device_register+0x17/0x1b  [<ffffffff813410c4>] 
> i2c_new_device+0x12b/0x175  [<ffffffff813411e4>] 
> i2c_sysfs_new_device+0xd6/0x15a  [<ffffffff812b6394>] 
> dev_attr_store+0x1b/0x1d  [<ffffffff81136f39>] 
> sysfs_write_file+0xef/0x12b  [<ffffffff810e4ac3>] vfs_write+0xa9/0x119  
> [<ffffffff810e4cfa>] sys_write+0x45/0x6c  [<ffffffff814005a2>] 
> system_call_fastpath+0x16/0x1b
> Code: ff 48 c7 c6 a7 fa 2f a0 48 85 c0 48 89 c3 74 cd 48 8b 3d d7 d0 
> 2a e1 be
> d0 00 00 00 4d 8b a5 c8 00 00 00 e8 3b 32 de e0 48 85 c0 <49> 89 44 24 
> 18 0f
> 84 5a 01 00 00 48 8b 3d b1 d0 2a e1 be d0 00 RIP  [<ffffffffa02ff4ad>] 
> tpm_st33_i2c_probe+0x87/0x21a [tpm_i2c_stm_st33]  RSP 
> <ffff8803dcb87c18>
> CR2: 0000000000000018
> ---[ end trace ddc5676681e8ed72 ]---
> 
> 
> 
> 
> Thanks,
> Peter
> 
