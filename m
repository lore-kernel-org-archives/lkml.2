Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934622Ab1JEMdx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 08:33:53 -0400
Received: from lucidpixels.com ([72.73.18.11]:60097 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934243Ab1JEMdw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 08:33:52 -0400
Date: Wed, 5 Oct 2011 08:33:52 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org
cc: linux-wireless@vger.kernel.org
Subject: 3.1-rc8: carl open src driver bug
Message-ID: <alpine.DEB.2.02.1110050832340.17961@p34.internal.lan>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

3.1-rc8:

[420204.241294] ieee80211 phy0: invalid plcp cck rate (0).
[420204.723179] ------------[ cut here ]------------
[420204.723205] WARNING: at drivers/net/wireless/ath/carl9170/tx.c:351 carl9170_tx_status+0x431/0x440 [carl9170]()
[420204.723211] Hardware name: X7SPA-HF
[420204.723214] Modules linked in: aes_generic rt2800usb rt2800lib rt2x00usb rt2x00lib carl9170 mac80211 ath cfg80211 uvcvideo videodev i2c_i801
[420204.723239] Pid: 0, comm: kworker/0:1 Not tainted 3.1.0-rc8 #1
[420204.723244] Call Trace:
[420204.723248]  <IRQ>  [<ffffffff8103036c>] ? warn_slowpath_common+0x7c/0xc0
[420204.723271]  [<ffffffffa0148fd1>] ? carl9170_tx_status+0x431/0x440 [carl9170]
[420204.723281]  [<ffffffffa0149359>] ? __carl9170_tx_process_status+0x109/0x220 [carl9170]
[420204.723292]  [<ffffffff8109f16d>] ? dma_pool_free+0x1d/0xf0
[420204.723302]  [<ffffffffa01496ee>] ? carl9170_tx_process_status+0x3e/0x80 [carl9170]
[420204.723311]  [<ffffffffa014a922>] ? carl9170_handle_command_response+0x382/0x500 [carl9170]
[420204.723321]  [<ffffffffa014acfd>] ? __carl9170_rx+0x25d/0x820 [carl9170]
[420204.723330]  [<ffffffff813bceb8>] ? ehci_work+0x448/0xa80
[420204.723340]  [<ffffffffa014b343>] ? carl9170_rx_stream+0x83/0x3b0 [carl9170]
[420204.723349]  [<ffffffffa0143248>] ? carl9170_usb_tasklet+0x98/0xc0 [carl9170]
[420204.723358]  [<ffffffff810352ca>] ? tasklet_hi_action+0x5a/0xc0
[420204.723366]  [<ffffffff810359c0>] ? __do_softirq+0x90/0x120
[420204.723375]  [<ffffffff814df66c>] ? call_softirq+0x1c/0x26
[420204.723383]  [<ffffffff81003a5d>] ? do_softirq+0x4d/0x80
[420204.723390]  [<ffffffff8100391d>] ? do_IRQ+0x5d/0xd0
[420204.723397]  [<ffffffff814dddab>] ? common_interrupt+0x6b/0x6b
[420204.723401]  <EOI>  [<ffffffff81008fe1>] ? mwait_idle+0x51/0x70
[420204.723414]  [<ffffffff81000776>] ? cpu_idle+0x96/0xb0
[420204.723420] ---[ end trace ca84150962b52c2e ]---
[420227.442291] ieee80211 phy0: invalid plcp cck rate (0).
[420899.453559] ieee80211 phy0: invalid plcp cck rate (0).

Justin.

