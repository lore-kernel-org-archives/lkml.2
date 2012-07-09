Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463Ab2GIHb5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 03:31:57 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:53723 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684Ab2GIHbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 03:31:55 -0400
Date: Mon, 09 Jul 2012 00:31:55 -0700 (PDT)
Message-Id: <20120709.003155.284089706826738623.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2012-07-06
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120706192034.GA1879@tuxdriver.com>
References: <20120706192034.GA1879@tuxdriver.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.97 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Fri, 6 Jul 2012 15:20:35 -0400

> Please let me know if there are problems!

This indentation is not correct:

commit 01f9cb073c827c60c43f769763b49a2026f1a897
Author: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
Date:   Thu Jun 28 14:39:51 2012 -0700

    mwl8k: fix possible race condition in info->control.sta use
 ...
+			sta = ieee80211_find_sta_by_ifaddr(hw, wh->addr1,
+								wh->addr2);
