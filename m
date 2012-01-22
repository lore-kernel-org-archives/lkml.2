Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481Ab2AVWoO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 17:44:14 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:47836 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752234Ab2AVWoN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 17:44:13 -0500
From: Richard Weinberger <richard@nod.at>
To: netfilter-devel@vger.kernel.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        eric.dumazet@gmail.com, jengelh@medozas.de
Subject: [PATCH v2] Merge ipt_LOG and ip6t_LOG, add ring bufffer support
Date: Sun, 22 Jan 2012 22:56:15 +0100
Message-Id: <1327269381-20748-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

This patch set merges ipt_LOG and ip6t_LOG and adds ring buffer support
to xt_LOG.

Using "--ring" a user can create LOG rules which log messages into
one or more ring buffers.
Each ring buffer is represented as pipe-like file in
/proc/net/netfilter/xt_LOG_ring/.

Ring buffer support can be enabled/disabled using
CONFIG_NETFILTER_XT_TARGET_LOG_RING.

Changes since v1:
 - Merged ipt_LOG and ip6t_LOG
 - Implemented ring buffer support as part of xt_LOG.

[PATCH 1/6] Netfilter: Merge ipt_LOG and ip6_LOG into xt_LOG
[PATCH 2/6] ring_buffer: Export for_each_buffer_cpu()
[PATCH 3/6] xt_log: Make printk() in sb_close() optional
[PATCH 4/6] Netfilter: xt_LOG: Implement ring buffer support
[PATCH 5/6] iptables: Merge libip6t_LOG and libipt_LOG into
[PATCH 6/6] iptables: xt_LOG: Add ring buffer support

Any feedback is welcome!

Thanks,
//richard
