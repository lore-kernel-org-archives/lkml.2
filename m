Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752147Ab0KJFty (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 00:49:54 -0500
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:49143 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858Ab0KJFtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 00:49:50 -0500
Date: Wed, 10 Nov 2010 14:49:48 +0900
From: Norbert Preining <preining@logic.at>
To: linux-kernel@vger.kernel.org
Subject: warnings in 2.6.37-rc1+
Message-ID: <20101110054948.GA16612@gamma.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all

(please keep in Cc, thanks)

[ 1592.320059] ------------[ cut here ]------------
[ 1592.320077] WARNING: at net/ipv4/devinet.c:137 in_dev_finish_destroy+0x3d/0x6e()
[ 1592.320083] Hardware name: VGN-Z11VN_B
[ 1592.320088] Modules linked in: vboxnetadp vboxnetflt sco bnep rfcomm l2cap crc16 binfmt_misc dm_crypt dm_mod isofs btrfs zlib_deflate crc32c libcrc32c vfat fat hso fuse vboxdrv loop uinput snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi arc4 snd_rawmidi snd_seq_midi_event snd_seq iwlagn iwlcore mac80211 snd_timer btusb firewire_ohci firewire_core bluetooth snd_seq_device tpm_infineon sony_laptop snd soundcore crc_itu_t cfg80211 rfkill joydev snd_page_alloc
[ 1592.320207] Pid: 0, comm: kworker/0:0 Tainted: P        W   2.6.37-rc1+ #3
[ 1592.320213] Call Trace:
[ 1592.320218]  <IRQ>  [<ffffffff81035075>] warn_slowpath_common+0x80/0x98
[ 1592.320236]  [<ffffffff810350a2>] warn_slowpath_null+0x15/0x17
[ 1592.320245]  [<ffffffff81352ede>] in_dev_finish_destroy+0x3d/0x6e
[ 1592.320257]  [<ffffffff8132b5f7>] ipv4_dst_destroy+0x53/0x58
[ 1592.320266]  [<ffffffff81314c26>] dst_destroy+0x78/0xd6
[ 1592.320275]  [<ffffffff8132b340>] dst_free+0x1a/0x29
[ 1592.320283]  [<ffffffff8132b358>] dst_rcu_free+0x9/0xb
[ 1592.320292]  [<ffffffff8107b5fd>] __rcu_process_callbacks+0x173/0x265
[ 1592.320301]  [<ffffffff8107b72e>] rcu_process_callbacks+0x3f/0x60
[ 1592.320310]  [<ffffffff81039e1c>] __do_softirq+0x8f/0x140
[ 1592.320322]  [<ffffffff810563fa>] ? tick_program_event+0x21/0x23
[ 1592.320331]  [<ffffffff8100304c>] call_softirq+0x1c/0x28
[ 1592.320339]  [<ffffffff81004c23>] do_softirq+0x33/0x68
[ 1592.320347]  [<ffffffff8103a036>] irq_exit+0x36/0x8b
[ 1592.320358]  [<ffffffff81019699>] smp_apic_timer_interrupt+0x88/0x96
[ 1592.320366]  [<ffffffff81002b13>] apic_timer_interrupt+0x13/0x20
[ 1592.320371]  <EOI>  [<ffffffff811ae0ef>] ? acpi_idle_enter_simple+0xc8/0xfa
[ 1592.320389]  [<ffffffff811ae0ea>] ? acpi_idle_enter_simple+0xc3/0xfa
[ 1592.320401]  [<ffffffff812e053c>] cpuidle_idle_call+0x9e/0xd6
[ 1592.320408]  [<ffffffff81001484>] cpu_idle+0x56/0x9c
[ 1592.320418]  [<ffffffff813816c8>] start_secondary+0x199/0x19d
[ 1592.320426] ---[ end trace 5f7d0c35de1972f1 ]---

followed by a strange message:
[ 1592.320431] Freeing alive in_device ffff88013e49b200

happened several times, starting after a wake up from suspend to ram.

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
AITH (n.)
The single bristle that sticks out sideways on a cheap paintbrush.
			--- Douglas Adams, The Meaning of Liff
