Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679Ab1KVMoL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 07:44:11 -0500
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:41706 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851Ab1KVMoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 07:44:09 -0500
Date: Tue, 22 Nov 2011 21:43:57 +0900
From: Norbert Preining <preining@logic.at>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
        David Rientjes <rientjes@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: iwlagn is getting very shaky
Message-ID: <20111122124357.GA32440@gamma.logic.tuwien.ac.at>
References: <CANUX_P2Yz9bWP_EmU1Acs7Mu2w78CXxO-njhiMt97b0TJHFYiQ@mail.gmail.com> <20111121030640.GI32505@gamma.logic.tuwien.ac.at> <CANUX_P2AA5stHwjegKdFhFGg7jxwdVU2Xr8OUtXUdEOKz_6E5A@mail.gmail.com> <20111122051310.GA23705@gamma.logic.tuwien.ac.at> <CANUX_P1RjcRD2tW1A6YYSEV9+aUZyTEro7tZXJWRoxk6gx-2jA@mail.gmail.com> <CANUX_P2aFn84uSqgZA2gTBN7E4+0jGmJQTkx4eug4Ls0hK0==Q@mail.gmail.com> <20111122072730.GA32225@gamma.logic.tuwien.ac.at> <CANUX_P15En9bHVx4bhq6=XKPZnC2u+QyVJ+jnm4ns=39DrOBtg@mail.gmail.com> <2D0C7905-AEB2-4DE4-89B1-945D89F2B5D6@logic.at> <CANUX_P21PDdyo4u-x_1A0Lcqf-33yHgzUxddAoc3juGRNnrcDg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANUX_P21PDdyo4u-x_1A0Lcqf-33yHgzUxddAoc3juGRNnrcDg@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Di, 22 Nov 2011, Emmanuel Grumbach wrote:
> Sorry, please try again with that one.

Here we go:

[   48.355300] iwlwifi 0000:06:00.0: L1 Enabled; Disabling L0S
[   48.360704] iwlwifi 0000:06:00.0: Radio type=0x1-0x2-0x0
[   48.402330] iwlwifi 0000:06:00.0: U iwl_trans_tx_queue_set_status Activate AC/CMD Queue 0 on FIFO 3
[   48.403914] iwlwifi 0000:06:00.0: U iwl_trans_tx_queue_set_status Activate AC/CMD Queue 1 on FIFO 2
[   48.404020] iwlwifi 0000:06:00.0: U iwl_trans_tx_queue_set_status Activate AC/CMD Queue 2 on FIFO 1
[   48.404020] iwlwifi 0000:06:00.0: U iwl_trans_tx_queue_set_status Activate AC/CMD Queue 3 on FIFO 0
[   48.404020] iwlwifi 0000:06:00.0: U iwl_trans_tx_queue_set_status Activate AC/CMD Queue 4 on FIFO 7
[   48.484466] iwlwifi 0000:06:00.0: L1 Enabled; Disabling L0S
[   48.488913] iwlwifi 0000:06:00.0: Radio type=0x1-0x2-0x0
[   48.534317] iwlwifi 0000:06:00.0: U iwl_trans_tx_queue_set_status Activate AC/CMD Queue 0 on FIFO 3
[   48.535806] iwlwifi 0000:06:00.0: U iwl_trans_tx_queue_set_status Activate AC/CMD Queue 1 on FIFO 2
[   48.536024] iwlwifi 0000:06:00.0: U iwl_trans_tx_queue_set_status Activate AC/CMD Queue 2 on FIFO 1
[   48.536024] iwlwifi 0000:06:00.0: U iwl_trans_tx_queue_set_status Activate AC/CMD Queue 3 on FIFO 0
[   48.536024] iwlwifi 0000:06:00.0: U iwl_trans_tx_queue_set_status Activate AC/CMD Queue 4 on FIFO 7
[   56.273961] wlan0: authenticate with 00:0a:79:eb:56:10 (try 1)
[   56.276374] wlan0: authenticated
[   56.281516] wlan0: associate with 00:0a:79:eb:56:10 (try 1)
[   56.288627] wlan0: RX AssocResp from 00:0a:79:eb:56:10 (capab=0x411 status=0 aid=1)
[   56.288633] wlan0: associated
[   74.164324] iwlwifi 0000:06:00.0: U iwl_trans_pcie_tx_agg_alloc HW queue is empty
[   75.164059] iwlwifi 0000:06:00.0: U iwl_trans_pcie_tx_agg_disable HW queue is empty
[   75.165912] iwlwifi 0000:06:00.0: U iwl_trans_tx_queue_set_status Deactivate AC/CMD Queue 11 on FIFO 0
[   76.481181] iwlwifi 0000:06:00.0: U iwl_trans_tx_queue_set_status Deactivate BA Queue 11 on FIFO 1
[   76.482944] iwlwifi 0000:06:00.0: Tx aggregation enabled on ra = 00:0a:79:eb:56:10 tid = 0
[   76.484769] ------------[ cut here ]------------
[   76.486566] WARNING: at drivers/net/wireless/iwlwifi/iwl-trans-pcie.c:1106 iwl_trans_pcie_tx+0x180/0x668 [iwlwifi]()
[   76.488353] Hardware name: VGN-Z11VN_B
[   76.488718] Modules linked in: usb_storage rfcomm bnep bluetooth crc16 snd_hrtimer vboxpci(O) vboxnetadp(O) vboxnetflt(O) vboxdrv(O) binfmt_misc dm_crypt dm_mod btrfs zlib_deflate crc32c libcrc32c vfat fat fuse loop(+) uinput snd_hda_codec_realtek arc4 snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm mxm_wmi snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq firewire_ohci firewire_core crc_itu_t iwlwifi joydev snd_timer snd_seq_device mac80211 cfg80211 snd sony_laptop(O) rfkill tpm_infineon soundcore snd_page_alloc
[   76.488718] Pid: 721, comm: kworker/u:5 Tainted: G      D    O 3.2.0-rc2+ #47
[   76.488718] Call Trace:
[   76.488718]  <IRQ>  [<ffffffff810384c5>] warn_slowpath_common+0x83/0x9b
[   76.488718]  [<ffffffff810384f7>] warn_slowpath_null+0x1a/0x1c
[   76.488718]  [<ffffffffa00e6d96>] iwl_trans_pcie_tx+0x180/0x668 [iwlwifi]
[   76.488718]  [<ffffffff810d38e5>] ? kmem_cache_alloc+0x44/0xb9
[   76.488718]  [<ffffffffa00cea1d>] iwlagn_tx_skb+0x87b/0x91b [iwlwifi]
[   76.488718]  [<ffffffffa00c4f8c>] iwlagn_mac_tx+0x131/0x1a2 [iwlwifi]
[   76.488718]  [<ffffffffa008fc56>] ? ieee80211_tx_h_fragment+0x16/0x22c [mac80211]
[   76.488718]  [<ffffffffa0083f94>] __ieee80211_tx+0x176/0x1cf [mac80211]
[   76.488718]  [<ffffffffa008fbc8>] ? ieee80211_tx_h_calculate_duration+0x4c/0x65 [mac80211]
[   76.488718]  [<ffffffffa0084d5a>] ieee80211_tx+0x97/0xaf [mac80211]
[   76.488718]  [<ffffffffa0085c56>] ieee80211_tx_pending+0xf0/0x1c3 [mac80211]
[   76.488718]  [<ffffffff8103d055>] ? __local_bh_enable+0x4a/0x83
[   76.488718]  [<ffffffff8103de1e>] ? __do_softirq+0x15b/0x1a5
[   76.488718]  [<ffffffff8103dc3e>] tasklet_action+0x77/0xc2
[   76.488718]  [<ffffffff8103dd7f>] __do_softirq+0xbc/0x1a5
[   76.488718]  [<ffffffff8140b00c>] call_softirq+0x1c/0x30
[   76.488718]  <EOI>  [<ffffffff8100359e>] do_softirq+0x38/0x6e
[   76.488718]  [<ffffffff8103da45>] _local_bh_enable_ip.isra.12+0x7d/0xa0
[   76.488718]  [<ffffffff8103da76>] local_bh_enable_ip+0xe/0x10
[   76.488718]  [<ffffffff8140921a>] _raw_spin_unlock_bh+0x23/0x25
[   76.488718]  [<ffffffffa0073c64>] ieee80211_agg_tx_operational+0x99/0xa4 [mac80211]
[   76.488718]  [<ffffffffa00747b2>] ieee80211_process_addba_resp+0xb8/0xf2 [mac80211]
[   76.488718]  [<ffffffff81064840>] ? do_raw_spin_lock+0x16/0x22
[   76.488718]  [<ffffffffa007ba82>] ieee80211_iface_work+0x130/0x2b5 [mac80211]
[   76.488718]  [<ffffffffa007b952>] ? ieee80211_teardown_sdata+0xcc/0xcc [mac80211]
[   76.488718]  [<ffffffff8104de7c>] process_one_work+0x17b/0x2bd
[   76.488718]  [<ffffffff8104c4c1>] ? need_to_create_worker+0x12/0x26
[   76.488718]  [<ffffffff8104ef77>] worker_thread+0xdb/0x15f
[   76.488718]  [<ffffffff8104ee9c>] ? manage_workers.isra.24+0x171/0x171
[   76.488718]  [<ffffffff8105265d>] kthread+0x84/0x8c
[   76.488718]  [<ffffffff8140af14>] kernel_thread_helper+0x4/0x10
[   76.488718]  [<ffffffff810525d9>] ? kthread_worker_fn+0x148/0x148
[   76.488718]  [<ffffffff8140af10>] ? gs_change+0xb/0xb
[   76.488718] ---[ end trace e59796b1a2564630 ]---
[   81.272320] iwlwifi 0000:06:00.0: U iwl_trans_pcie_tx_agg_alloc HW queue is NOT empty: 5 packets in HW queue
[   86.104091] iwlwifi 0000:06:00.0: Queue 11 stuck for 10000 ms.
[   86.105749] iwlwifi 0000:06:00.0: Current SW read_ptr 76 write_ptr 81
[   86.107435] iwlwifi 0000:06:00.0: Current HW read_ptr 76 write_ptr 81
[   86.109073] iwlwifi 0000:06:00.0: On demand firmware reload
[   86.111055] ieee80211 phy0: Hardware restart was requested
[   86.112741] iwlwifi 0000:06:00.0: L1 Enabled; Disabling L0S
[   86.117893] iwlwifi 0000:06:00.0: Radio type=0x1-0x2-0x0
[   86.158367] iwlwifi 0000:06:00.0: U iwl_trans_tx_queue_set_status Activate AC/CMD Queue 0 on FIFO 3
[   86.159884] iwlwifi 0000:06:00.0: U iwl_trans_tx_queue_set_status Activate AC/CMD Queue 1 on FIFO 2
[   86.160081] iwlwifi 0000:06:00.0: U iwl_trans_tx_queue_set_status Activate AC/CMD Queue 2 on FIFO 1
[   86.160081] iwlwifi 0000:06:00.0: U iwl_trans_tx_queue_set_status Activate AC/CMD Queue 3 on FIFO 0
[   86.160081] iwlwifi 0000:06:00.0: U iwl_trans_tx_queue_set_status Activate AC/CMD Queue 4 on FIFO 7
[   86.205374] iwlwifi 0000:06:00.0: U iwl_trans_tx_queue_set_status Deactivate AC/CMD Queue 11 on FIFO 0
[  114.816331] iwlwifi 0000:06:00.0: U iwl_trans_pcie_tx_agg_alloc HW queue is empty
[  115.816030] iwlwifi 0000:06:00.0: U iwl_trans_pcie_tx_agg_disable HW queue is empty
[  115.817499] iwlwifi 0000:06:00.0: U iwl_trans_tx_queue_set_status Deactivate AC/CMD Queue 11 on FIFO 0
[  116.522124] iwlwifi 0000:06:00.0: U iwl_trans_tx_queue_set_status Deactivate BA Queue 11 on FIFO 3
[  116.523518] iwlwifi 0000:06:00.0: Tx aggregation enabled on ra = 00:0a:79:eb:56:10 tid = 6
[  118.532313] iwlwifi 0000:06:00.0: U iwl_trans_pcie_tx_agg_alloc HW queue is NOT empty: 4 packets in HW queue


BTW; I went back now to something 3.1.0-rc10+++ (a few commits before 3.1.0)
and no warnings/erros/stuck queue.

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
SCETHROG (n.)
One of those peculiar beards-without-moustaches worn by religious
Belgians and American scientists which help them look like trolls.
			--- Douglas Adams, The Meaning of Liff
