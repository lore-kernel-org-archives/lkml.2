Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754Ab0JJSjj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 14:39:39 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56746 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473Ab0JJSjh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 14:39:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=thBbe1e5TfsD6WQGMIrxsXMwnkCw4h7OcOaSgFXnuhWBvtOxIctEbfn2+6F+Z6kHRh
         qk9xBOfGMYo/dVP1rWfglPzrtY/7I0sZr/LryPq+jr7cY8azVphKhJHjB2424r0O+va8
         nGKM1+DMuI8f0EDTJMOO5gWdRWuKb/p2bE6yQ=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: piotr@hosowicz.com
Subject: Re: What is this? Should I worry?
Date: Sun, 10 Oct 2010 20:39:31 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc7; KDE/4.4.5; i686; ; )
Cc: LKML <linux-kernel@vger.kernel.org>
References: <4CAFEFF1.8010202@example.com>
In-Reply-To: <4CAFEFF1.8010202@example.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201010102039.31706.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On sobota, 9 października 2010 o 06:30:41 Piotr Hosowicz wrote:
> # uname -a
> Linux aapi205 2.6.36-rc7-git1 #1 SMP PREEMPT Fri Oct 8 10:49:47 CEST
> 2010 x86_64 GNU/Linux
> 
> This is what I have in syslog:
> 
> Oct  9 03:09:34 aapi205 kernel: [57001.468028] INFO: rcu_bh_state
> detected stall on CPU 1 (t=0 jiffies)
> Oct  9 03:09:34 aapi205 kernel: [57001.468035] sending NMI to all CPUs:
> Oct  9 03:09:34 aapi205 kernel: [57001.468050] NMI backtrace for cpu 3
> Oct  9 03:09:34 aapi205 kernel: [57001.468053] CPU 3
> Oct  9 03:09:34 aapi205 kernel: [57001.468055] Modules linked in:
> nvidia(P) binfmt_misc sco bnep rfcomm l2cap bluetooth rfkill ppdev lp
> fuse ext3 jbd coretemp it87 hwmon_vid sbp2 loop snd_hda_codec_realtek
> snd_hda_intel snd_hda_codec snd_pcm_oss snd_mixer_oss snd_pcm
> snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event
> snd_seq snd_timer snd_seq_device snd parport_pc soundcore i2c_i801
> shpchp parport evdev pci_hotplug pcspkr snd_page_alloc psmouse serio_raw
> i2c_core button intel_agp processor ext4 mbcache jbd2 crc16 sg sd_mod
> sr_mod cdrom ata_piix ata_generic ahci libahci ide_pci_generic libata
> ohci1394 ieee1394 jmicron thermal ide_core floppy scsi_mod uhci_hcd
> r8169 mii thermal_sys ehci_hcd [last unloaded: nvidia]
> Oct  9 03:09:34 aapi205 kernel: [57001.468114]
> Oct  9 03:09:34 aapi205 kernel: [57001.468117] Pid: 0, comm: kworker/0:1
> Tainted: P        W   2.6.36-rc7-git1 #1 EP45-UD3/EP45-UD3

Can you check clean kernel (without any proprietary module)? That. 2.6.35 
works fine (it's a regression)?

Regards
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
