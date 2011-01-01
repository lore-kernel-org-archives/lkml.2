Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752444Ab1AAK2U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jan 2011 05:28:20 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:53703 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057Ab1AAK2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jan 2011 05:28:19 -0500
Date: Sat, 1 Jan 2011 11:28:17 +0100
From: Heinz Diehl <htd@fancy-poultry.org>
To: Stephen Boyd <bebarino@gmail.com>
Cc: users@rt2x00.serialmonkey.com, Ivo van Doorn <IvDoorn@gmail.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: BUG in rt2x00lib_txdone() with 2.6.37-rc8
Message-ID: <20110101102817.GC6981@fancy-poultry.org>
References: <4D1DAF0A.40000@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D1DAF0A.40000@gmail.com>
Organization: private site
X-OpenPGP-KeyID: 0xE9002778
X-OpenPGP-Fingerprint: C661 CE20 7105 B0DB 49B5  CDB2 298C 801B E900 2778
X-OpenPGP-URL: http://www.fritha.org/htd.asc
User-Agent: Mutt/1.5.21+20101028 (GNU/Linux)
X-Provags-ID: V02:K0:EV+cYfmMDEKc18mIQUrKY9Zd4D6vvuOW1FsvCpYzYzu
 CYDXtF2n7FiPoqYWLUsODBH1FKLok7Vd5hGFRxdmzXrQoI5t5Z
 see+Erj4OH5po471FC1c/Ak9OLEzwquVJGlrJ6Teg0SXDHs9vT
 0bXxJyvTgGGsItp0JTAgkvGXdCt47E4yqUF6xwJMc9cIPrxBjk
 A7mtQNwPa4r7k5maZkKyw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31.12.2010, Stephen Boyd wrote: 

> [ 9085.714105] BUG: unable to handle kernel NULL pointer dereference at
> 00000000000000a4
> [ 9085.714816] IP: [<ffffffffa0025458>] rt2x00lib_txdone+0x36/0x249
> [rt2x00lib]
> [ 9085.715017] PGD 215fd067 PUD 292f4067 PMD 0
> [ 9085.715017] Oops: 0000 [#1] SMP
> [ 9085.715017] last sysfs file:
> /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq
> [ 9085.715017] CPU 1
> [ 9085.715017] Modules linked in: usb_storage thermal snd_seq_oss
> snd_seq_midi snd_seq_dummy snd_pcm_oss snd_mixer_oss snd_hrtimer
> snd_emu10k1_synth snd_emux_synth snd_seq_virmidi snd_seq_midi_event
> snd_seq_midi_emul snd_seq scsi_wait_scan powernow_k8 mperf i2c_i801 fuse
> fan snd_emu10k1 snd_rawmidi snd_ac97_codec ac97_bus snd_pcm
> snd_seq_device snd_timer snd_page_alloc snd_util_mem rt73usb crc_itu_t
> rt2x00usb snd_hwdep snd processor r8169 via82cxxx rt2x00lib soundcore
> mii button k8temp
> [ 9085.715017]
> [ 9085.715017] Pid: 11513, comm: kworker/1:0 Not tainted 2.6.37-rc7+ #27
> MS-7094/MS-7094
[....]

I'm not quite shure on this, but it reminds me on this bug here:
https://bugzilla.kernel.org/show_bug.cgi?id=24892

