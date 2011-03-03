Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772Ab1CCFrq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 00:47:46 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:37983 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753450Ab1CCFrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 00:47:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=uPoCQHaeRFuUKgDZ0O4MxFKtDQgGCzEHbEhzFIEgxaJVdZ2jLAqOidGgt6JkeXTQls
         TGVvFMWeB7bWPW4WHhxVFddgEaAqgoga4ylwyB+hEmYzeyUfdBbfGVD0igBM/xTT284d
         t+F8SNM33HgOFtU55EgbTLGWX185AMzr1+0Z4=
MIME-Version: 1.0
Date: Wed, 2 Mar 2011 21:47:43 -0800
Message-ID: <AANLkTik9To0Rkq2FRqQFB2wNu0kyJ7CzyBek2jBp36Cb@mail.gmail.com>
Subject: WARNING: at drivers/net/wireless/ath/ath9k/recv.c:536
 ath_stoprecv+0xc8/0xda [ath9k]()
From: Justin Mattock <justinmattock@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

not sure what this is..(below)


[   33.951046] CE: hpet increased min_delta_ns to 20113 nsec
[   35.567319] EXT4-fs (sda3): re-mounted. Opts:
errors=panic,user_xattr,debug,acl,commit=600
[   36.350144] wlan0: authenticate with 00:0b:86:32:f8:60 (try 1)
[   36.352284] wlan0: authenticated
[   36.352396] wlan0: associate with 00:0b:86:32:f8:60 (try 1)
[   36.356854] wlan0: RX AssocResp from 00:0b:86:32:f8:60 (capab=0x421
status=0 aid=2)
[   36.356862] wlan0: associated
[   41.370318] ath: DMA failed to stop in 10 ms AR_CR=0x00000024
AR_DIAG_SW=0x42000020
[   41.370324] ath: Could not stop RX, we could be confusing the DMA
engine when we start RX up
[   41.370328] ------------[ cut here ]------------
[   41.370345] WARNING: at drivers/net/wireless/ath/ath9k/recv.c:536
ath_stoprecv+0xc8/0xda [ath9k]()
[   41.370349] Hardware name: MacBookPro2,2
[   41.370351] Modules linked in: hidp xfrm4_mode_transport xcbc
rmd160 sha512_generic rfcomm sco bnep l2cap ipt_REJECT xt_tcpudp
ipt_LOG iptable_nat nf_nat xt_state nf_conntrack_ftp nf_conntrack_ipv4
nf_conntrack nf_defrag_ipv4 iptable_filter ip_tables x_tables btusb
bluetooth evdev psmouse thermal fan container button ac battery video
ath9k ath9k_common ath9k_hw ath ttm drm aes_x86_64 lzo zlib ipcomp
xfrm_ipcomp crypto_null sha256_generic cbc des_generic cast5 blowfish
serpent camellia twofish_generic twofish_x86_64 twofish_common ctr ah4
esp4 authenc firewire_ohci firewire_core uhci_hcd ehci_hcd coretemp
acpi_cpufreq processor mperf appletouch applesmc
[   41.370430] Pid: 766, comm: kworker/u:4 Not tainted
2.6.38-rc6-00116-g2821f46 #5
[   41.370434] Call Trace:
[   41.370444]  [<ffffffff810612c0>] ? warn_slowpath_common+0x80/0x98
[   41.370450]  [<ffffffff810612ed>] ? warn_slowpath_null+0x15/0x17
[   41.370458]  [<ffffffffa01c6438>] ? ath_stoprecv+0xc8/0xda [ath9k]
[   41.370467]  [<ffffffffa01c3a62>] ? ath_set_channel+0xb0/0x217 [ath9k]
[   41.370475]  [<ffffffffa01c3f89>] ? ath9k_config+0x3c0/0x4c3 [ath9k]
[   41.370482]  [<ffffffff8140fe8a>] ? ieee80211_hw_config+0x120/0x129
[   41.370487]  [<ffffffff81413902>] ? ieee80211_scan_work+0x2f8/0x496
[   41.370495]  [<ffffffffa01c7934>] ?
ath_tx_complete_poll_work+0xf3/0x102 [ath9k]
[   41.370501]  [<ffffffff8141360a>] ? ieee80211_scan_work+0x0/0x496
[   41.370506]  [<ffffffff810769c7>] ? process_one_work+0x266/0x3d7
[   41.370511]  [<ffffffff81076e9f>] ? worker_thread+0x1d6/0x350
[   41.370515]  [<ffffffff81076cc9>] ? worker_thread+0x0/0x350
[   41.370521]  [<ffffffff8107bdcf>] ? kthread+0x7d/0x85
[   41.370528]  [<ffffffff8102e064>] ? kernel_thread_helper+0x4/0x10
[   41.370533]  [<ffffffff8107bd52>] ? kthread+0x0/0x85
[   41.370537]  [<ffffffff8102e060>] ? kernel_thread_helper+0x0/0x10
[   41.370541] ---[ end trace 062f507148a6fa8e ]---


from what I remember I was at a local college(caltech) trying to
connect to their public wifi
in the public area. with no luck, then this popped up.
full dmesg here:

http://fpaste.org/SKU4/


-- 
Justin P. Mattock
