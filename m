Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758646Ab1FKPKz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jun 2011 11:10:55 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:10760 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758552Ab1FKPKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jun 2011 11:10:53 -0400
Date: Sat, 11 Jun 2011 17:02:30 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: platform-driver-x86@vger.kernel.org, Frank Seidel <frank@f-seidel.de>,
        linux-input@vger.kernel.org
Subject: Re: Reproducible general protection fault: 0000 - hdapsd exited with
 preempt_count 1 - kernel 2.6.38.8
In-Reply-To: <alpine.LNX.2.00.1106101001360.19998@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1106111701240.23835@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1106101001360.19998@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Jun 2011, Jesper Juhl wrote:

> Hi
> 
> I just noticed a GPF during bootup of my laptop :
> 
> [   18.944171] general protection fault: 0000 [#1] PREEMPT SMP 
> [   18.944243] last sysfs file: /sys/devices/virtual/input/input13/event13/uevent
> [   18.944295] CPU 0 
> [   18.944307] Modules linked in: joydev hdaps uvcvideo btusb bluetooth usbhid hid videodev v4l2_compat_ioctl32 snd_hda_codec_hdmi snd_hda_codec_conexant vboxnetadp vboxnetflt vboxdrv snd_hda_intel snd_hda_codec cpufreq_ondemand snd_hwdep arc4 sg ecb iwlagn msr acpi_cpufreq freq_table mperf i915 tp_smapi thinkpad_ec ehci_hcd thinkpad_acpi drm_kms_helper i2c_i801 snd_pcm iwlcore snd_timer mac80211 e1000e snd_page_alloc drm cfg80211 firewire_ohci i2c_algo_bit snd i2c_core usbcore rfkill pcspkr firewire_core serio_raw sdhci_pci evdev iTCO_wdt sdhci tpm_tis soundcore tpm mmc_core wmi intel_ips intel_agp nvram crc_itu_t iTCO_vendor_support battery intel_gtt tpm_bios ac video psmouse thermal processor button ext4 mbcache jbd2 crc16 sr_mod cdrom sd_mod ahci libahci libata scsi_mod
> [   18.944928] 
> [   18.946142] Pid: 978, comm: hdapsd Not tainted 2.6.38-ARCH #1 LENOVO 4384GJG/4384GJG
<...>

Just tested 2.6.39.1 and I cannot reproduce the GPF with that kernel, so 
it seems this has been fixed already.

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

