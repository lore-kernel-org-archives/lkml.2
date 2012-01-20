Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756738Ab2AUAgH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 19:36:07 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:47836 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753178Ab2AUAf0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 19:35:26 -0500
From: Richard Weinberger <richard@nod.at>
To: netfilter-devel@vger.kernel.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        eric.dumazet@gmail.com, jengelh@medozas.de
Subject: Merge ipt_LOG and ip6t_LOG
Date: Sat, 21 Jan 2012 00:47:26 +0100
Message-Id: <1327103248-18918-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

These two patches merge ipt_LOG and ip6t_LOG.

I'm not really happy with the iptables patch.
As it depends on xt_log.h iptables will not compile with old 
kernel headers.
Any idea how to deal with this?

[PATCH] Netfilter: Merge ipt_LOG and ip6_LOG into xt_LOG
[PATCH] iptables: Merge libip6t_LOG and libipt_LOG into libxt_LOG

Thanks,
//richard
