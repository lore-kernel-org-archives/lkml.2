Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752533Ab0KGSeb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 13:34:31 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:37963 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374Ab0KGSea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 13:34:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:subject:message-id:user-agent:x-archive
         :mime-version:content-type;
        b=STWuO44Y/cKjGW62sSK7QYCeKBIhCM2eB9uEOr+0kcvPluzlhd1YSWTW46qFsLBx3r
         HYHRDlqcYtS7bMjEG/PrO9dVmr5pH+MuowTAw3ftNNfXpzU8Xnq5CbdC6ucjK7GiOR8I
         RtrtxYqOfLHVg5DpmJGB/jNlETNKtx0JkqhEA=
Date: Sun, 7 Nov 2010 16:34:23 -0200 (BRST)
From: =?ISO-8859-15?Q?Fr=E9d=E9ric_L=2E_W=2E_Meunier?= <2@pervalidus.net>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Kernel crash with 2.6.36
Message-ID: <alpine.LNX.2.00.1011071631550.2636@dyndns.pervalidus.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
X-Archive: encrypt
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is this supposed to be a bug in 2.6.36 ? Firefox was running, but I 
wasn't browsing with it. The computer just locked up, first killing X. 
SysRq didn't work.

Nov  7 16:21:23 pervalidus kernel: BUG: unable to handle kernel NULL pointer dereference at (null)
Nov  7 16:21:23 pervalidus kernel: IP: [<c118cc76>] skb_dequeue+0x38/0x4a
Nov  7 16:21:23 pervalidus kernel: *pde = 00000000 
Nov  7 16:21:23 pervalidus kernel: Oops: 0002 [#1] PREEMPT SMP 
Nov  7 16:21:23 pervalidus kernel: last sysfs file: /sys/devices/platform/it87.552/in4_input
Nov  7 16:21:23 pervalidus kernel: Modules linked in: pppoe pppox ppp_generic slhc af_packet snd_seq_oss snd_seq_midi_event snd_seq snd_pcm_oss snd_mixer_oss powernow_k8 freq_table mperf it87 hwmon_vid ipt_LOG xt_tcpudp iptable_filter ip_tables x_tables fuse joydev tuner_simple tuner_types radeon ati_agp usbhid hid ttm drm_kms_helper tuner tvaudio drm tda7432 snd_emu10k1 snd_rawmidi snd_ac97_codec ac97_bus bttv snd_pcm v4l2_common snd_seq_device videodev snd_timer v4l1_compat videobuf_dma_sg snd_page_alloc videobuf_core snd_util_mem ir_lirc_codec rtc_cmos rtc_core rtc_lib lirc_dev btcx_risc ir_common agpgart ir_core thermal tveeprom i2c_piix4 i2c_algo_bit sr_mod 8250_pnp processor ohci_hcd parport_pc snd_hwdep k8temp i2c_core cdrom 8250 cfbcopyarea ehci_hcd snd usbcore soundcore emu10k1_gp gameport nls_base evdev sg cfbimgblt parport serial_core r8169 cfbfillrect thermal_sys hwmon mii pcspkr floppy psmouse button
Nov  7 16:21:23 pervalidus kernel: 
Nov  7 16:21:23 pervalidus kernel: Pid: 10468, comm: firefox-bin Not tainted 2.6.36 #1 GA-MA69VM-S2/GA-MA69VM-S2
Nov  7 16:21:23 pervalidus kernel: EIP: 0060:[<c118cc76>] EFLAGS: 00210096 CPU: 0
Nov  7 16:21:23 pervalidus kernel: EIP is at skb_dequeue+0x38/0x4a
Nov  7 16:21:23 pervalidus kernel: EAX: 00200246 EBX: f6b1de40 ECX: 00000000 EDX: 00009e9e
Nov  7 16:21:23 pervalidus kernel: ESI: f6715680 EDI: f6b1d180 EBP: ed911dec ESP: ed911de0
Nov  7 16:21:23 pervalidus kernel: DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Nov  7 16:21:23 pervalidus kernel: Process firefox-bin (pid: 10468, ti=ed911000 task=f673acb0 task.ti=ed911000)
Nov  7 16:21:23 pervalidus kernel: Stack:
Nov  7 16:21:23 pervalidus kernel: f6715600 00000001 ed911e50 ed911e70 c11da7e0 f673acb0 f673acb0 00000000
Nov  7 16:21:23 pervalidus kernel: <0> f44b7680 f673acb0 f67156d8 f671576c 00000001 f6715674 00000000 00000000
Nov  7 16:21:23 pervalidus kernel: <0> ed911eb0 ed911e90 ffffffa1 f6715794 00000020 f6b1de40 f6987580 f6622f80
Nov  7 16:21:23 pervalidus kernel: Call Trace:
Nov  7 16:21:23 pervalidus kernel: [<c11da7e0>] ? unix_stream_recvmsg+0x103/0x424
Nov  7 16:21:23 pervalidus kernel: [<c11ea637>] ? _raw_spin_unlock_irqrestore+0x16/0x21
Nov  7 16:21:23 pervalidus kernel: [<c1188f69>] ? sock_aio_read+0xe8/0xf2
Nov  7 16:21:23 pervalidus kernel: [<c1079cb0>] ? do_sync_read+0x8a/0xc5
Nov  7 16:21:23 pervalidus kernel: [<c107a205>] ? vfs_read+0x83/0xa8
Nov  7 16:21:23 pervalidus kernel: [<c107a2be>] ? sys_read+0x3b/0x5d
Nov  7 16:21:23 pervalidus kernel: [<c1002690>] ? sysenter_do_call+0x12/0x26
Nov  7 16:21:23 pervalidus kernel: Code: e8 3c d7 05 00 8b 1f 39 fb 75 04 31 db eb 1e 85 db 74 1a ff 4f 08 8b 3b 8b 4b 04 c7 03 00 00 00 00 c7 43 04 00 00 00 00 89 4f 04 <89> 39 89 c2 89 f0 e8 a0 d9 05 00 89 d8 5b 5e 5f c9 c3 55 89 e5 
Nov  7 16:21:23 pervalidus kernel: EIP: [<c118cc76>] skb_dequeue+0x38/0x4a SS:ESP 0068:ed911de0
Nov  7 16:21:23 pervalidus kernel: CR2: 0000000000000000
Nov  7 16:21:23 pervalidus kernel: ---[ end trace 4cd73789c5986bc8 ]---
Nov  7 16:21:23 pervalidus kernel: note: firefox-bin[10468] exited with preempt_count 2
