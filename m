Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757032Ab1I2QiK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 12:38:10 -0400
Received: from mga09.intel.com ([134.134.136.24]:15594 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754065Ab1I2QiI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 12:38:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="57996579"
From: "Allan, Bruce W" <bruce.w.allan@intel.com>
To: joeyli <jlee@suse.com>, Dave Young <dyoung@redhat.com>
CC: "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 29 Sep 2011 09:38:05 -0700
Subject: RE: [E1000-devel] [BUG?] e1000e Detected Hardware Unit Hang
Thread-Topic: [E1000-devel] [BUG?] e1000e Detected Hardware Unit Hang
Thread-Index: Acx+agWVpYzKftPZR6upjK2tZ1KP3AAW1WbQ
Message-ID: <E0862362F1FF584BBCF7C4EA592A20C40D580615@orsmsx509.amr.corp.intel.com>
References: <4E83DAEA.6010505@redhat.com>
	<1317274129.6218.483.camel@linux-s257.site>	<4E840417.4010705@redhat.com>
 <1317274382.6218.484.camel@linux-s257.site>
In-Reply-To: <1317274382.6218.484.camel@linux-s257.site>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id p8TGcSZT007595

>-----Original Message-----
>From: joeyli [mailto:jlee@suse.com]
>Sent: Wednesday, September 28, 2011 10:33 PM
>To: Dave Young
>Cc: e1000-devel@lists.sourceforge.net; linux-kernel@vger.kernel.org
>Subject: Re: [E1000-devel] [BUG?] e1000e Detected Hardware Unit Hang
>
>æ–¼ å››ï¼Œ2011-09-29 æ–¼ 13:37 +0800ï¼ŒDave Young æåˆ°ï¼š
>> On 09/29/2011 01:28 PM, joeyli wrote:
>>
>> > Hi Dave,
>> >
>> > æ–¼ å››ï¼Œ2011-09-29 æ–¼ 10:41 +0800ï¼ŒDave Young æåˆ°ï¼š
>> >> Hi,
>> >>
>> >> suspend to ram, after resume, I got below info: (attached the full dmesg)
>> >>
>> >> [106900.343520] e1000e 0000:00:19.0: eth0: Detected Hardware Unit Hang:
>> >> [106900.343521]   TDH                  <1>
>> >> [106900.343522]   TDT                  <2>
>> >> [106900.343523]   next_to_use          <2>
>> >> [106900.343523]   next_to_clean        <1>
>> >> [106900.343524] buffer_info[next_to_clean]:
>> >> [106900.343525]   time_stamp           <101e7f773>
>> >> [106900.343526]   next_to_watch        <1>
>> >> [106900.343526]   jiffies              <101e7fa4a>
>> >> [106900.343527]   next_to_watch.status <0>
>> >> [106900.343528] MAC Status             <80683>
>> >> [106900.343529] PHY Status             <796d>
>> >> [106900.343529] PHY 1000BASE-T Status  <3800>
>> >> [106900.343530] PHY Extended Status    <3000>
>> >> [106900.343531] PCI Status             <10>
>> >> [106902.342904] e1000e 0000:00:19.0: eth0: Detected Hardware Unit Hang:
>> >> [106902.342905]   TDH                  <1>
>> >> [106902.342906]   TDT                  <2>
>> >> [106902.342907]   next_to_use          <2>
>> >> [106902.342907]   next_to_clean        <1>
>> >> [106902.342908] buffer_info[next_to_clean]:
>> >> [106902.342909]   time_stamp           <101e7f773>
>> >> [106902.342909]   next_to_watch        <1>
>> >> [106902.342910]   jiffies              <101e7fca2>
>> >> [106902.342911]   next_to_watch.status <0>
>> >> [106902.342912] MAC Status             <80683>
>> >> [106902.342912] PHY Status             <796d>
>> >> [106902.342913] PHY 1000BASE-T Status  <3800>
>> >> [106902.342914] PHY Extended Status    <3000>
>> >> [106902.342915] PCI Status             <10>
>> >> [106903.349326] ------------[ cut here ]------------
>> >> [106903.349336] WARNING: at net/sched/sch_generic.c:255
>> >> dev_watchdog+0xeb/0x14b()
>> >> [106903.349339] Hardware name: OptiPlex 760
>> >> [106903.349342] NETDEV WATCHDOG: eth0 (e1000e): transmit queue 0 timed out
>> >> [106903.349344] Modules linked in: cdc_ether usbnet mii tun kvm_intel
>> >> kvm snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device
>> >> snd_pcm_oss snd_mixer_oss fuse snd_hda_codec_analog snd_hda_intel
>> >> snd_hda_codec snd_hwdep snd_pcm radeon snd_timer snd_page_alloc ttm
>> >> dell_wmi sparse_keymap wmi
>> >> [106903.349379] Pid: 0, comm: swapper Not tainted 3.1.0-rc6+ #202
>> >> [106903.349382] Call Trace:
>> >> [106903.349384]  <IRQ>  [<ffffffff8103c5a7>] warn_slowpath_common+0x80/0x98
>> >> [106903.349394]  [<ffffffff8103c653>] warn_slowpath_fmt+0x41/0x43
>> >> [106903.349399]  [<ffffffff81560149>] dev_watchdog+0xeb/0x14b
>> >> [106903.349404]  [<ffffffff810497c6>] run_timer_softirq+0x217/0x300
>> >> [106903.349408]  [<ffffffff81049733>] ? run_timer_softirq+0x184/0x300
>> >> [106903.349413]  [<ffffffff8156005e>] ? netif_tx_unlock+0x51/0x51
>> >> [106903.349419]  [<ffffffff810423c6>] __do_softirq+0xe2/0x1bc
>> >> [106903.349424]  [<ffffffff81007a81>] ? paravirt_read_tsc+0x9/0xd
>> >> [106903.349428]  [<ffffffff81007fc8>] ? sched_clock+0x9/0xd
>> >> [106903.349434]  [<ffffffff8160063c>] call_softirq+0x1c/0x30
>> >> [106903.349438]  [<ffffffff81003ba2>] do_softirq+0x46/0x9c
>> >> [106903.349442]  [<ffffffff81042696>] irq_exit+0x5b/0xbe
>> >> [106903.349446]  [<ffffffff8100384a>] do_IRQ+0x89/0xa0
>> >> [106903.349452]  [<ffffffff815f8e33>] common_interrupt+0x73/0x73
>> >> [106903.349454]  <EOI>  [<ffffffff81008d81>] ? mwait_idle+0x8a/0xc1
>> >> [106903.349462]  [<ffffffff81008d78>] ? mwait_idle+0x81/0xc1
>> >> [106903.349467]  [<ffffffff810012ab>] cpu_idle+0xb3/0xd5
>> >> [106903.349473]  [<ffffffff815d8dbe>] rest_init+0xb2/0xb9
>> >> [106903.349477]  [<ffffffff815d8d0c>] ?
>> >> csum_partial_copy_generic+0x16c/0x16c
>> >> [106903.349483]  [<ffffffff81a22b49>] start_kernel+0x390/0x39b
>> >> [106903.349487]  [<ffffffff81a222af>] x86_64_start_reservations+0xb6/0xba
>> >> [106903.349491]  [<ffffffff81a223b4>] x86_64_start_kernel+0x101/0x110
>> >> [106903.349495] ---[ end trace 1d36d9ed335e092c ]---
>> >> [106903.349722] e1000e 0000:00:19.0: eth0: Reset adapter
>> >>
>> >
>> > What's your kernel version?
>>
>>
>> My info:
>>
>> bash-4.1$ uname -a
>> Linux darkstar 3.1.0-rc6+ #202 SMP Tue Sep 20 12:55:02 HKT 2011 x86_64
>> Intel(R) Core(TM)2 Quad CPU    Q9400  @ 2.66GHz GenuineIntel GNU/Linux
>>
>> bash-4.1$ lspci|grep Ethernet
>> 00:19.0 Ethernet controller: Intel Corporation 82567LM-3 Gigabit Network
>> Connection (rev 02)
>>
>
>My pci info:
>06:00.0 Ethernet controller: Intel Corporation 80003ES2LAN Gigabit
>Ethernet Controller (Copper) (rev 01)
>
>> >
>> > On my machine also have the same problem, but don't need suspend/resume,
>> > just need BOOT and WAIT!!
>> > Sometimes just need wait 35 - 45 minutes, but sometimes just need wait 3
>> > minutes.
>> >
>> > My kernel version is v3.0.
>> >
>> >
>
>
>Thank's
>Joey Lee

These sound like two different issues.  Please file separate bug trackers
for each issue at http://sourceforge.net/tracker/?group_id=42302&atid=447449
and include kernel version, driver version, lspci -vvv output and system
log message including the Hardware Unit Hang message and stack trace.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
