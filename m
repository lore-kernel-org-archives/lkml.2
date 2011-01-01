Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332Ab1AAVfY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jan 2011 16:35:24 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:47610 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568Ab1AAVfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jan 2011 16:35:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=VvNl2NVB9pNhyO0PR+cTeLAFoAyoBNO2+YrCRYnct0PnyT+PUQltLE4MZRfsR4pdx8
         hc+Aw+jHdVPTuAmQMtdYXSpUw+/8za7xWWcdcZJKDzYuFVwNSq5X7HAzAWYpU+o/FW1V
         VRQhUaddLAwJ+ZPrXRpzOOYL5AeytpOv1Diw4=
Message-ID: <4D1F9E12.2060006@gmail.com>
Date: Sat, 01 Jan 2011 13:35:14 -0800
From: Stephen Boyd <bebarino@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101230 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Heinz Diehl <htd@fancy-poultry.org>
CC: users@rt2x00.serialmonkey.com, Ivo van Doorn <IvDoorn@gmail.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: BUG in rt2x00lib_txdone() with 2.6.37-rc8
References: <4D1DAF0A.40000@gmail.com> <20110101102817.GC6981@fancy-poultry.org>
In-Reply-To: <20110101102817.GC6981@fancy-poultry.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/01/11 02:28, Heinz Diehl wrote:
> On 31.12.2010, Stephen Boyd wrote: 
> 
>> [ 9085.714105] BUG: unable to handle kernel NULL pointer dereference at
>> 00000000000000a4
>> [ 9085.714816] IP: [<ffffffffa0025458>] rt2x00lib_txdone+0x36/0x249
>> [rt2x00lib]
>> [ 9085.715017] PGD 215fd067 PUD 292f4067 PMD 0
>> [ 9085.715017] Oops: 0000 [#1] SMP
>> [ 9085.715017] last sysfs file:
>> /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq
>> [ 9085.715017] CPU 1
>> [ 9085.715017] Modules linked in: usb_storage thermal snd_seq_oss
>> snd_seq_midi snd_seq_dummy snd_pcm_oss snd_mixer_oss snd_hrtimer
>> snd_emu10k1_synth snd_emux_synth snd_seq_virmidi snd_seq_midi_event
>> snd_seq_midi_emul snd_seq scsi_wait_scan powernow_k8 mperf i2c_i801 fuse
>> fan snd_emu10k1 snd_rawmidi snd_ac97_codec ac97_bus snd_pcm
>> snd_seq_device snd_timer snd_page_alloc snd_util_mem rt73usb crc_itu_t
>> rt2x00usb snd_hwdep snd processor r8169 via82cxxx rt2x00lib soundcore
>> mii button k8temp
>> [ 9085.715017]
>> [ 9085.715017] Pid: 11513, comm: kworker/1:0 Not tainted 2.6.37-rc7+ #27
>> MS-7094/MS-7094
> [....]
> 
> I'm not quite shure on this, but it reminds me on this bug here:
> https://bugzilla.kernel.org/show_bug.cgi?id=24892
> 

I believe I had the latest net tree merged into 2.6.37-rc7 in which case
the patch mentioned in that bugzilla would already be applied.
