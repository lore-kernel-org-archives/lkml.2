Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751878Ab2KDGBi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 01:01:38 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:34410 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914Ab2KDGBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 01:01:36 -0500
Date: Sun, 04 Nov 2012 01:01:35 -0500 (EST)
Message-Id: <20121104.010135.1162785749638710718.davem@davemloft.net>
To: hayeswang@realtek.com
Cc: romieu@fr.zoreil.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        agnescheng@google.com
Subject: Re: [PATCH v2 net-next] r8169: enable internal ASPM and clock
 request settings
From: David Miller <davem@davemloft.net>
In-Reply-To: <1351824388-1225-1-git-send-email-hayeswang@realtek.com>
References: <1351780651-1271-1-git-send-email-hayeswang@realtek.com>
	<1351824388-1225-1-git-send-email-hayeswang@realtek.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Fri, 2 Nov 2012 10:46:28 +0800

> The following chips need to enable internal settings to let ASPM
> and clock request work.
> 
> RTL8111E-VL, RTL8111F, RTL8411, RTL8111G
> RTL8105, RTL8402, RTL8106
> 
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>

Francois?
