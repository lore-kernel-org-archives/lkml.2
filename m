Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345Ab1ECXPE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 19:15:04 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:60605 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754063Ab1ECXO7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 19:14:59 -0400
Message-Id: <20110503231428.076396001@efficios.com>
User-Agent: quilt/0.48-1
Date: Tue, 03 May 2011 19:10:47 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Zhu Yi <yi.zhu@intel.com>, Johannes Berg <johannes@sipsolutions.net>,
        Reinette Chatre <reinette.chatre@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [RFC patch 24/32] trace event wireless remove semicolons
References: <20110503231023.968960757@efficios.com>
Content-Disposition: inline; filename=trace-event-wireless-remove-semicolons.patch
X-Poly-FromMTA: (test.dorsal.polymtl.ca [132.207.72.60]) at Tue,  3 May 2011 23:14:28 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Part of the gradual TRACE_EVENT() semicolon removal. Enables creation of array
of events, thus saving space for trace event probes.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Zhu Yi <yi.zhu@intel.com>
CC: Johannes Berg <johannes@sipsolutions.net>
CC: Reinette Chatre <reinette.chatre@intel.com>
CC: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/iwlwifi/iwl-devtrace.h |   20 ++--
 drivers/net/wireless/iwmc3200wifi/trace.h   |   14 +--
 net/mac80211/driver-trace.h                 |  118 ++++++++++++++--------------
 3 files changed, 76 insertions(+), 76 deletions(-)

Index: linux-2.6-lttng/drivers/net/wireless/iwlwifi/iwl-devtrace.h
===================================================================
--- linux-2.6-lttng.orig/drivers/net/wireless/iwlwifi/iwl-devtrace.h
+++ linux-2.6-lttng/drivers/net/wireless/iwlwifi/iwl-devtrace.h
@@ -55,7 +55,7 @@ TRACE_EVENT(iwlwifi_dev_ioread32,
 		__entry->val = val;
 	),
 	TP_printk("[%p] read io[%#x] = %#x", __entry->priv, __entry->offs, __entry->val)
-);
+)
 
 TRACE_EVENT(iwlwifi_dev_iowrite8,
 	TP_PROTO(struct iwl_priv *priv, u32 offs, u8 val),
@@ -71,7 +71,7 @@ TRACE_EVENT(iwlwifi_dev_iowrite8,
 		__entry->val = val;
 	),
 	TP_printk("[%p] write io[%#x] = %#x)", __entry->priv, __entry->offs, __entry->val)
-);
+)
 
 TRACE_EVENT(iwlwifi_dev_iowrite32,
 	TP_PROTO(struct iwl_priv *priv, u32 offs, u32 val),
@@ -87,7 +87,7 @@ TRACE_EVENT(iwlwifi_dev_iowrite32,
 		__entry->val = val;
 	),
 	TP_printk("[%p] write io[%#x] = %#x)", __entry->priv, __entry->offs, __entry->val)
-);
+)
 
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM iwlwifi_ucode
@@ -110,7 +110,7 @@ TRACE_EVENT(iwlwifi_dev_ucode_cont_event
 	),
 	TP_printk("[%p] EVT_LOGT:%010u:0x%08x:%04u",
 		  __entry->priv, __entry->time, __entry->data, __entry->ev)
-);
+)
 
 TRACE_EVENT(iwlwifi_dev_ucode_wrap_event,
 	TP_PROTO(struct iwl_priv *priv, u32 wraps, u32 n_entry, u32 p_entry),
@@ -131,7 +131,7 @@ TRACE_EVENT(iwlwifi_dev_ucode_wrap_event
 	TP_printk("[%p] wraps=#%02d n=0x%X p=0x%X",
 		  __entry->priv, __entry->wraps, __entry->n_entry,
 		  __entry->p_entry)
-);
+)
 
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM iwlwifi
@@ -152,7 +152,7 @@ TRACE_EVENT(iwlwifi_dev_hcmd,
 	TP_printk("[%p] hcmd %#.2x (%ssync)",
 		  __entry->priv, ((u8 *)__get_dynamic_array(hcmd))[0],
 		  __entry->flags & CMD_ASYNC ? "a" : "")
-);
+)
 
 TRACE_EVENT(iwlwifi_dev_rx,
 	TP_PROTO(struct iwl_priv *priv, void *rxbuf, size_t len),
@@ -167,7 +167,7 @@ TRACE_EVENT(iwlwifi_dev_rx,
 	),
 	TP_printk("[%p] RX cmd %#.2x",
 		  __entry->priv, ((u8 *)__get_dynamic_array(rxbuf))[4])
-);
+)
 
 TRACE_EVENT(iwlwifi_dev_tx,
 	TP_PROTO(struct iwl_priv *priv, void *tfd, size_t tfdlen,
@@ -199,7 +199,7 @@ TRACE_EVENT(iwlwifi_dev_tx,
 		  __entry->priv,
 		  ((u8 *)__get_dynamic_array(buf0))[0],
 		  __entry->framelen)
-);
+)
 
 TRACE_EVENT(iwlwifi_dev_ucode_error,
 	TP_PROTO(struct iwl_priv *priv, u32 desc, u32 time,
@@ -236,7 +236,7 @@ TRACE_EVENT(iwlwifi_dev_ucode_error,
 		  __entry->priv, __entry->desc, __entry->time, __entry->data1,
 		  __entry->data2, __entry->line, __entry->blink1,
 		  __entry->blink2, __entry->ilink1, __entry->ilink2)
-);
+)
 
 TRACE_EVENT(iwlwifi_dev_ucode_event,
 	TP_PROTO(struct iwl_priv *priv, u32 time, u32 data, u32 ev),
@@ -256,7 +256,7 @@ TRACE_EVENT(iwlwifi_dev_ucode_event,
 	),
 	TP_printk("[%p] EVT_LOGT:%010u:0x%08x:%04u",
 		  __entry->priv, __entry->time, __entry->data, __entry->ev)
-);
+)
 #endif /* __IWLWIFI_DEVICE_TRACE */
 
 #undef TRACE_INCLUDE_PATH
Index: linux-2.6-lttng/drivers/net/wireless/iwmc3200wifi/trace.h
===================================================================
--- linux-2.6-lttng.orig/drivers/net/wireless/iwmc3200wifi/trace.h
+++ linux-2.6-lttng/drivers/net/wireless/iwmc3200wifi/trace.h
@@ -53,7 +53,7 @@ TRACE_EVENT(iwm_tx_nonwifi_cmd,
 		__entry->hw, __entry->seq, __entry->addr, __entry->op1,
 		__entry->op2
 	)
-);
+)
 
 TRACE_EVENT(iwm_tx_wifi_cmd,
 	TP_PROTO(struct iwm_priv *iwm, struct iwm_umac_wifi_out_hdr *hdr),
@@ -96,7 +96,7 @@ TRACE_EVENT(iwm_tx_wifi_cmd,
 		__entry->resp, __entry->eot, __entry->seq, __entry->color,
 		__entry->ra_tid, __entry->credit_group
 	)
-);
+)
 
 TRACE_EVENT(iwm_tx_packets,
 	TP_PROTO(struct iwm_priv *iwm, u8 *buf, int len),
@@ -149,7 +149,7 @@ TRACE_EVENT(iwm_tx_packets,
 		__entry->eot, __entry->seq, __entry->color, __entry->ra_tid,
 		__entry->credit_group, __entry->npkt, __entry->bytes
 	)
-);
+)
 
 TRACE_EVENT(iwm_rx_nonwifi_cmd,
 	TP_PROTO(struct iwm_priv *iwm, void *buf, int len),
@@ -176,7 +176,7 @@ TRACE_EVENT(iwm_rx_nonwifi_cmd,
 		IWM_PR_FMT " Rx TARGET RESP: opcode 0x%x, seq 0x%x, len 0x%x",
 		IWM_PR_ARG, __entry->opcode, __entry->seq, __entry->len
 	)
-);
+)
 
 TRACE_EVENT(iwm_rx_wifi_cmd,
 	TP_PROTO(struct iwm_priv *iwm, struct iwm_umac_wifi_in_hdr *hdr),
@@ -205,7 +205,7 @@ TRACE_EVENT(iwm_rx_wifi_cmd,
 		__entry->source == UMAC_HDI_IN_SOURCE_FW ? "UMAC" : "UDMA",
 		__entry->cmd, __entry->seq, __entry->count
 	)
-);
+)
 
 #define iwm_ticket_action_symbol		\
 	{ IWM_RX_TICKET_DROP, "DROP" },		\
@@ -245,7 +245,7 @@ TRACE_EVENT(iwm_rx_ticket,
 		__entry->reason ? __entry->reason : __entry->flags,
 		__entry->flags & IWM_RX_TICKET_AMSDU_MSK ? ", AMSDU frame" : ""
 	)
-);
+)
 
 TRACE_EVENT(iwm_rx_packet,
 	TP_PROTO(struct iwm_priv *iwm, void *buf, int len),
@@ -273,7 +273,7 @@ TRACE_EVENT(iwm_rx_packet,
 		IWM_PR_ARG, __entry->source == UMAC_HDI_IN_SOURCE_FHRX ?
 		"LMAC" : "UMAC", __entry->id, __entry->len
 	)
-);
+)
 #endif
 
 #undef TRACE_INCLUDE_PATH
Index: linux-2.6-lttng/net/mac80211/driver-trace.h
===================================================================
--- linux-2.6-lttng.orig/net/mac80211/driver-trace.h
+++ linux-2.6-lttng/net/mac80211/driver-trace.h
@@ -53,12 +53,12 @@ DECLARE_EVENT_CLASS(local_only_evt,
 		LOCAL_ASSIGN;
 	),
 	TP_printk(LOCAL_PR_FMT, LOCAL_PR_ARG)
-);
+)
 
 DEFINE_EVENT(local_only_evt, drv_return_void,
 	TP_PROTO(struct ieee80211_local *local),
 	TP_ARGS(local)
-);
+)
 
 TRACE_EVENT(drv_return_int,
 	TP_PROTO(struct ieee80211_local *local, int ret),
@@ -72,7 +72,7 @@ TRACE_EVENT(drv_return_int,
 		__entry->ret = ret;
 	),
 	TP_printk(LOCAL_PR_FMT " - %d", LOCAL_PR_ARG, __entry->ret)
-);
+)
 
 TRACE_EVENT(drv_return_u64,
 	TP_PROTO(struct ieee80211_local *local, u64 ret),
@@ -86,17 +86,17 @@ TRACE_EVENT(drv_return_u64,
 		__entry->ret = ret;
 	),
 	TP_printk(LOCAL_PR_FMT " - %llu", LOCAL_PR_ARG, __entry->ret)
-);
+)
 
 DEFINE_EVENT(local_only_evt, drv_start,
 	TP_PROTO(struct ieee80211_local *local),
 	TP_ARGS(local)
-);
+)
 
 DEFINE_EVENT(local_only_evt, drv_stop,
 	TP_PROTO(struct ieee80211_local *local),
 	TP_ARGS(local)
-);
+)
 
 TRACE_EVENT(drv_add_interface,
 	TP_PROTO(struct ieee80211_local *local,
@@ -120,7 +120,7 @@ TRACE_EVENT(drv_add_interface,
 		LOCAL_PR_FMT  VIF_PR_FMT " addr:%pM",
 		LOCAL_PR_ARG, VIF_PR_ARG, __entry->addr
 	)
-);
+)
 
 TRACE_EVENT(drv_change_interface,
 	TP_PROTO(struct ieee80211_local *local,
@@ -148,7 +148,7 @@ TRACE_EVENT(drv_change_interface,
 		LOCAL_PR_ARG, VIF_PR_ARG, __entry->new_type,
 		__entry->new_p2p ? "/p2p" : ""
 	)
-);
+)
 
 TRACE_EVENT(drv_remove_interface,
 	TP_PROTO(struct ieee80211_local *local, struct ieee80211_sub_if_data *sdata),
@@ -171,7 +171,7 @@ TRACE_EVENT(drv_remove_interface,
 		LOCAL_PR_FMT  VIF_PR_FMT " addr:%pM",
 		LOCAL_PR_ARG, VIF_PR_ARG, __entry->addr
 	)
-);
+)
 
 TRACE_EVENT(drv_config,
 	TP_PROTO(struct ieee80211_local *local,
@@ -213,7 +213,7 @@ TRACE_EVENT(drv_config,
 		LOCAL_PR_FMT " ch:%#x freq:%d",
 		LOCAL_PR_ARG, __entry->changed, __entry->center_freq
 	)
-);
+)
 
 TRACE_EVENT(drv_bss_info_changed,
 	TP_PROTO(struct ieee80211_local *local,
@@ -263,7 +263,7 @@ TRACE_EVENT(drv_bss_info_changed,
 		LOCAL_PR_FMT  VIF_PR_FMT " changed:%#x",
 		LOCAL_PR_ARG, VIF_PR_ARG, __entry->changed
 	)
-);
+)
 
 TRACE_EVENT(drv_prepare_multicast,
 	TP_PROTO(struct ieee80211_local *local, int mc_count),
@@ -284,7 +284,7 @@ TRACE_EVENT(drv_prepare_multicast,
 		LOCAL_PR_FMT " prepare mc (%d)",
 		LOCAL_PR_ARG, __entry->mc_count
 	)
-);
+)
 
 TRACE_EVENT(drv_configure_filter,
 	TP_PROTO(struct ieee80211_local *local,
@@ -312,7 +312,7 @@ TRACE_EVENT(drv_configure_filter,
 		LOCAL_PR_FMT " changed:%#x total:%#x",
 		LOCAL_PR_ARG, __entry->changed, __entry->total
 	)
-);
+)
 
 TRACE_EVENT(drv_set_tim,
 	TP_PROTO(struct ieee80211_local *local,
@@ -336,7 +336,7 @@ TRACE_EVENT(drv_set_tim,
 		LOCAL_PR_FMT STA_PR_FMT " set:%d",
 		LOCAL_PR_ARG, STA_PR_FMT, __entry->set
 	)
-);
+)
 
 TRACE_EVENT(drv_set_key,
 	TP_PROTO(struct ieee80211_local *local,
@@ -370,7 +370,7 @@ TRACE_EVENT(drv_set_key,
 		LOCAL_PR_FMT  VIF_PR_FMT  STA_PR_FMT,
 		LOCAL_PR_ARG, VIF_PR_ARG, STA_PR_ARG
 	)
-);
+)
 
 TRACE_EVENT(drv_update_tkip_key,
 	TP_PROTO(struct ieee80211_local *local,
@@ -398,7 +398,7 @@ TRACE_EVENT(drv_update_tkip_key,
 		LOCAL_PR_FMT VIF_PR_FMT STA_PR_FMT " iv32:%#x",
 		LOCAL_PR_ARG,VIF_PR_ARG,STA_PR_ARG, __entry->iv32
 	)
-);
+)
 
 TRACE_EVENT(drv_hw_scan,
 	TP_PROTO(struct ieee80211_local *local,
@@ -421,17 +421,17 @@ TRACE_EVENT(drv_hw_scan,
 		LOCAL_PR_FMT VIF_PR_FMT,
 		LOCAL_PR_ARG,VIF_PR_ARG
 	)
-);
+)
 
 DEFINE_EVENT(local_only_evt, drv_sw_scan_start,
 	TP_PROTO(struct ieee80211_local *local),
 	TP_ARGS(local)
-);
+)
 
 DEFINE_EVENT(local_only_evt, drv_sw_scan_complete,
 	TP_PROTO(struct ieee80211_local *local),
 	TP_ARGS(local)
-);
+)
 
 TRACE_EVENT(drv_get_stats,
 	TP_PROTO(struct ieee80211_local *local,
@@ -462,7 +462,7 @@ TRACE_EVENT(drv_get_stats,
 		LOCAL_PR_FMT " ret:%d",
 		LOCAL_PR_ARG, __entry->ret
 	)
-);
+)
 
 TRACE_EVENT(drv_get_tkip_seq,
 	TP_PROTO(struct ieee80211_local *local,
@@ -487,7 +487,7 @@ TRACE_EVENT(drv_get_tkip_seq,
 	TP_printk(
 		LOCAL_PR_FMT, LOCAL_PR_ARG
 	)
-);
+)
 
 TRACE_EVENT(drv_set_frag_threshold,
 	TP_PROTO(struct ieee80211_local *local, u32 value),
@@ -508,7 +508,7 @@ TRACE_EVENT(drv_set_frag_threshold,
 		LOCAL_PR_FMT " value:%d",
 		LOCAL_PR_ARG, __entry->value
 	)
-);
+)
 
 TRACE_EVENT(drv_set_rts_threshold,
 	TP_PROTO(struct ieee80211_local *local, u32 value),
@@ -529,7 +529,7 @@ TRACE_EVENT(drv_set_rts_threshold,
 		LOCAL_PR_FMT " value:%d",
 		LOCAL_PR_ARG, __entry->value
 	)
-);
+)
 
 TRACE_EVENT(drv_set_coverage_class,
 	TP_PROTO(struct ieee80211_local *local, u8 value),
@@ -550,7 +550,7 @@ TRACE_EVENT(drv_set_coverage_class,
 		LOCAL_PR_FMT " value:%d",
 		LOCAL_PR_ARG, __entry->value
 	)
-);
+)
 
 TRACE_EVENT(drv_sta_notify,
 	TP_PROTO(struct ieee80211_local *local,
@@ -578,7 +578,7 @@ TRACE_EVENT(drv_sta_notify,
 		LOCAL_PR_FMT  VIF_PR_FMT  STA_PR_FMT " cmd:%d",
 		LOCAL_PR_ARG, VIF_PR_ARG, STA_PR_ARG, __entry->cmd
 	)
-);
+)
 
 TRACE_EVENT(drv_sta_add,
 	TP_PROTO(struct ieee80211_local *local,
@@ -603,7 +603,7 @@ TRACE_EVENT(drv_sta_add,
 		LOCAL_PR_FMT  VIF_PR_FMT  STA_PR_FMT,
 		LOCAL_PR_ARG, VIF_PR_ARG, STA_PR_ARG
 	)
-);
+)
 
 TRACE_EVENT(drv_sta_remove,
 	TP_PROTO(struct ieee80211_local *local,
@@ -628,7 +628,7 @@ TRACE_EVENT(drv_sta_remove,
 		LOCAL_PR_FMT  VIF_PR_FMT  STA_PR_FMT,
 		LOCAL_PR_ARG, VIF_PR_ARG, STA_PR_ARG
 	)
-);
+)
 
 TRACE_EVENT(drv_conf_tx,
 	TP_PROTO(struct ieee80211_local *local, u16 queue,
@@ -658,12 +658,12 @@ TRACE_EVENT(drv_conf_tx,
 		LOCAL_PR_FMT " queue:%d",
 		LOCAL_PR_ARG, __entry->queue
 	)
-);
+)
 
 DEFINE_EVENT(local_only_evt, drv_get_tsf,
 	TP_PROTO(struct ieee80211_local *local),
 	TP_ARGS(local)
-);
+)
 
 TRACE_EVENT(drv_set_tsf,
 	TP_PROTO(struct ieee80211_local *local, u64 tsf),
@@ -684,17 +684,17 @@ TRACE_EVENT(drv_set_tsf,
 		LOCAL_PR_FMT " tsf:%llu",
 		LOCAL_PR_ARG, (unsigned long long)__entry->tsf
 	)
-);
+)
 
 DEFINE_EVENT(local_only_evt, drv_reset_tsf,
 	TP_PROTO(struct ieee80211_local *local),
 	TP_ARGS(local)
-);
+)
 
 DEFINE_EVENT(local_only_evt, drv_tx_last_beacon,
 	TP_PROTO(struct ieee80211_local *local),
 	TP_ARGS(local)
-);
+)
 
 TRACE_EVENT(drv_ampdu_action,
 	TP_PROTO(struct ieee80211_local *local,
@@ -730,7 +730,7 @@ TRACE_EVENT(drv_ampdu_action,
 		LOCAL_PR_ARG, VIF_PR_ARG, STA_PR_ARG, __entry->action,
 		__entry->tid, __entry->buf_size
 	)
-);
+)
 
 TRACE_EVENT(drv_get_survey,
 	TP_PROTO(struct ieee80211_local *local, int idx,
@@ -752,7 +752,7 @@ TRACE_EVENT(drv_get_survey,
 		LOCAL_PR_FMT " idx:%d",
 		LOCAL_PR_ARG, __entry->idx
 	)
-);
+)
 
 TRACE_EVENT(drv_flush,
 	TP_PROTO(struct ieee80211_local *local, bool drop),
@@ -773,7 +773,7 @@ TRACE_EVENT(drv_flush,
 		LOCAL_PR_FMT " drop:%d",
 		LOCAL_PR_ARG, __entry->drop
 	)
-);
+)
 
 TRACE_EVENT(drv_channel_switch,
 	TP_PROTO(struct ieee80211_local *local,
@@ -801,7 +801,7 @@ TRACE_EVENT(drv_channel_switch,
 		LOCAL_PR_FMT " new freq:%u count:%d",
 		LOCAL_PR_ARG, __entry->freq, __entry->count
 	)
-);
+)
 
 TRACE_EVENT(drv_set_antenna,
 	TP_PROTO(struct ieee80211_local *local, u32 tx_ant, u32 rx_ant, int ret),
@@ -826,7 +826,7 @@ TRACE_EVENT(drv_set_antenna,
 		LOCAL_PR_FMT " tx_ant:%d rx_ant:%d ret:%d",
 		LOCAL_PR_ARG, __entry->tx_ant, __entry->rx_ant, __entry->ret
 	)
-);
+)
 
 TRACE_EVENT(drv_get_antenna,
 	TP_PROTO(struct ieee80211_local *local, u32 tx_ant, u32 rx_ant, int ret),
@@ -851,7 +851,7 @@ TRACE_EVENT(drv_get_antenna,
 		LOCAL_PR_FMT " tx_ant:%d rx_ant:%d ret:%d",
 		LOCAL_PR_ARG, __entry->tx_ant, __entry->rx_ant, __entry->ret
 	)
-);
+)
 
 TRACE_EVENT(drv_remain_on_channel,
 	TP_PROTO(struct ieee80211_local *local, struct ieee80211_channel *chan,
@@ -877,12 +877,12 @@ TRACE_EVENT(drv_remain_on_channel,
 		LOCAL_PR_FMT " freq:%dMHz duration:%dms",
 		LOCAL_PR_ARG, __entry->center_freq, __entry->duration
 	)
-);
+)
 
 DEFINE_EVENT(local_only_evt, drv_cancel_remain_on_channel,
 	TP_PROTO(struct ieee80211_local *local),
 	TP_ARGS(local)
-);
+)
 
 TRACE_EVENT(drv_offchannel_tx,
 	TP_PROTO(struct ieee80211_local *local, struct sk_buff *skb,
@@ -910,7 +910,7 @@ TRACE_EVENT(drv_offchannel_tx,
 		LOCAL_PR_FMT " freq:%dMHz, wait:%dms",
 		LOCAL_PR_ARG, __entry->center_freq, __entry->wait
 	)
-);
+)
 
 TRACE_EVENT(drv_set_ringparam,
 	TP_PROTO(struct ieee80211_local *local, u32 tx, u32 rx),
@@ -933,7 +933,7 @@ TRACE_EVENT(drv_set_ringparam,
 		LOCAL_PR_FMT " tx:%d rx %d",
 		LOCAL_PR_ARG, __entry->tx, __entry->rx
 	)
-);
+)
 
 TRACE_EVENT(drv_get_ringparam,
 	TP_PROTO(struct ieee80211_local *local, u32 *tx, u32 *tx_max,
@@ -962,12 +962,12 @@ TRACE_EVENT(drv_get_ringparam,
 		LOCAL_PR_ARG,
 		__entry->tx, __entry->tx_max, __entry->rx, __entry->rx_max
 	)
-);
+)
 
 DEFINE_EVENT(local_only_evt, drv_offchannel_tx_cancel_wait,
 	TP_PROTO(struct ieee80211_local *local),
 	TP_ARGS(local)
-);
+)
 
 /*
  * Tracing for API calls that drivers call.
@@ -992,7 +992,7 @@ TRACE_EVENT(api_start_tx_ba_session,
 		STA_PR_FMT " tid:%d",
 		STA_PR_ARG, __entry->tid
 	)
-);
+)
 
 TRACE_EVENT(api_start_tx_ba_cb,
 	TP_PROTO(struct ieee80211_sub_if_data *sdata, const u8 *ra, u16 tid),
@@ -1015,7 +1015,7 @@ TRACE_EVENT(api_start_tx_ba_cb,
 		VIF_PR_FMT " ra:%pM tid:%d",
 		VIF_PR_ARG, __entry->ra, __entry->tid
 	)
-);
+)
 
 TRACE_EVENT(api_stop_tx_ba_session,
 	TP_PROTO(struct ieee80211_sta *sta, u16 tid),
@@ -1036,7 +1036,7 @@ TRACE_EVENT(api_stop_tx_ba_session,
 		STA_PR_FMT " tid:%d",
 		STA_PR_ARG, __entry->tid
 	)
-);
+)
 
 TRACE_EVENT(api_stop_tx_ba_cb,
 	TP_PROTO(struct ieee80211_sub_if_data *sdata, const u8 *ra, u16 tid),
@@ -1059,12 +1059,12 @@ TRACE_EVENT(api_stop_tx_ba_cb,
 		VIF_PR_FMT " ra:%pM tid:%d",
 		VIF_PR_ARG, __entry->ra, __entry->tid
 	)
-);
+)
 
 DEFINE_EVENT(local_only_evt, api_restart_hw,
 	TP_PROTO(struct ieee80211_local *local),
 	TP_ARGS(local)
-);
+)
 
 TRACE_EVENT(api_beacon_loss,
 	TP_PROTO(struct ieee80211_sub_if_data *sdata),
@@ -1083,7 +1083,7 @@ TRACE_EVENT(api_beacon_loss,
 		VIF_PR_FMT,
 		VIF_PR_ARG
 	)
-);
+)
 
 TRACE_EVENT(api_connection_loss,
 	TP_PROTO(struct ieee80211_sub_if_data *sdata),
@@ -1102,7 +1102,7 @@ TRACE_EVENT(api_connection_loss,
 		VIF_PR_FMT,
 		VIF_PR_ARG
 	)
-);
+)
 
 TRACE_EVENT(api_cqm_rssi_notify,
 	TP_PROTO(struct ieee80211_sub_if_data *sdata,
@@ -1124,7 +1124,7 @@ TRACE_EVENT(api_cqm_rssi_notify,
 		VIF_PR_FMT " event:%d",
 		VIF_PR_ARG, __entry->rssi_event
 	)
-);
+)
 
 TRACE_EVENT(api_scan_completed,
 	TP_PROTO(struct ieee80211_local *local, bool aborted),
@@ -1145,7 +1145,7 @@ TRACE_EVENT(api_scan_completed,
 		LOCAL_PR_FMT " aborted:%d",
 		LOCAL_PR_ARG, __entry->aborted
 	)
-);
+)
 
 TRACE_EVENT(api_sta_block_awake,
 	TP_PROTO(struct ieee80211_local *local,
@@ -1169,7 +1169,7 @@ TRACE_EVENT(api_sta_block_awake,
 		LOCAL_PR_FMT STA_PR_FMT " block:%d",
 		LOCAL_PR_ARG, STA_PR_FMT, __entry->block
 	)
-);
+)
 
 TRACE_EVENT(api_chswitch_done,
 	TP_PROTO(struct ieee80211_sub_if_data *sdata, bool success),
@@ -1190,17 +1190,17 @@ TRACE_EVENT(api_chswitch_done,
 		VIF_PR_FMT " success=%d",
 		VIF_PR_ARG, __entry->success
 	)
-);
+)
 
 DEFINE_EVENT(local_only_evt, api_ready_on_channel,
 	TP_PROTO(struct ieee80211_local *local),
 	TP_ARGS(local)
-);
+)
 
 DEFINE_EVENT(local_only_evt, api_remain_on_channel_expired,
 	TP_PROTO(struct ieee80211_local *local),
 	TP_ARGS(local)
-);
+)
 
 /*
  * Tracing for internal functions
@@ -1229,7 +1229,7 @@ TRACE_EVENT(wake_queue,
 		LOCAL_PR_FMT " queue:%d, reason:%d",
 		LOCAL_PR_ARG, __entry->queue, __entry->reason
 	)
-);
+)
 
 TRACE_EVENT(stop_queue,
 	TP_PROTO(struct ieee80211_local *local, u16 queue,
@@ -1253,7 +1253,7 @@ TRACE_EVENT(stop_queue,
 		LOCAL_PR_FMT " queue:%d, reason:%d",
 		LOCAL_PR_ARG, __entry->queue, __entry->reason
 	)
-);
+)
 #endif /* !__MAC80211_DRIVER_TRACE || TRACE_HEADER_MULTI_READ */
 
 #undef TRACE_INCLUDE_PATH

