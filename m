Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374Ab2LRVYX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 16:24:23 -0500
Received: from mailout02.t-online.de ([194.25.134.17]:42147 "EHLO
	mailout02.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755303Ab2LRVYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 16:24:14 -0500
Message-ID: <50D0DEF3.3060501@t-online.de>
Date: Tue, 18 Dec 2012 22:24:03 +0100
From: Knut Petersen <Knut_Petersen@t-online.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [BUG v3.7.0] soft lockup - CPU#0 stuck for 23s
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ID: TvZLwiZQwhfzGxRyKXLWFKfgU5xZGKDajzk-fzLnbrYofwmu0L4kNpMd8EOT542gG8
X-TOI-MSGID: 7046cda9-7c9b-4182-b1dc-8ab64c77c37e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Someone might be interested ...

A kernel build in parallel to a dvb-s recording resulted in the following log entry:

[117284.040009] BUG: soft lockup - CPU#0 stuck for 23s! [cc1:2657]
[117284.040009] Modules linked in: ipt_MASQUERADE xt_pkttype xt_TCPMSS xt_tcpudp xt_LOG xt_limit iptable_nat nf_nat_ipv4 nf_nat pppoe pppox af_packet ppp_generic slhc ir_kbd_i2c binfmt_misc snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_raw 
ipt_REJECT iptable_raw iptable_filter ip6table_mangle nf_conntrack_netbios_ns nf_conntrack_broadcast nf_conntrack_ipv4 nf_defrag_ipv4 ip_tables xt_conntrack nf_conntrack ip6table_filter ip6_tables x_tables ipv6 isl6421 cx24116 cx88_dvb videobuf_dvb ir_lirc_codec dvb_core lirc_dev ir_rc5_decoder 
rc_hauppauge snd_hda_codec_realtek tuner snd_hda_intel snd_hda_codec cx8800 cx8802 snd_hwdep cx88xx snd_rme96 snd_pcm rc_core snd_timer snd tveeprom v4l2_common soundcore snd_page_alloc videodev videobuf_dma_sg videobuf_core btcx_risc
[117284.040009] irq event stamp: 0
[117284.040009] hardirqs last  enabled at (0): [<  (null)>] (null)
[117284.040009] hardirqs last disabled at (0): [<c012412c>] copy_process+0x482/0x103d
[117284.040009] softirqs last  enabled at (0): [<c012412c>] copy_process+0x482/0x103d
[117284.040009] softirqs last disabled at (0): [<  (null)>] (null)
[117284.040009] Pid: 2657, comm: cc1 Not tainted 3.7.0-main #18 /i915GMm-HFS
[117284.040009] EIP: 0073:[<406ffb37>] EFLAGS: 00000246 CPU: 0
[117284.040009] EIP is at 0x406ffb37
[117284.040009] EAX: 00000000 EBX: 407f7ff4 ECX: 407f93c0 EDX: 407f93c0
[117284.040009] ESI: 08afc380 EDI: 000004e0 EBP: 00000001 ESP: bf897834
[117284.040009]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b
[117284.040009] Process cc1 (pid: 2657, ti=f3224000 task=d11ec060 task.ti=f3224000)
[117284.040009]

system: Pentium-M Dothan, 2GHz, 2GB, kernel 3.7.0, openSuSE 12.1, Xorg fresh git.

cu,
  Knut
