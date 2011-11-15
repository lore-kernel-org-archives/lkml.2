Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932649Ab1KOVmJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 16:42:09 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:46820 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932504Ab1KOVmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 16:42:07 -0500
Date: Tue, 15 Nov 2011 16:42:02 -0500 (EST)
Message-Id: <20111115.164202.810749392412257566.davem@davemloft.net>
To: grundler@chromium.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, allan@asix.com.tw,
        freddy@asix.com.tw, grundler@google.com
Subject: Re: [PATCH 4/5] net-next:asix: V2 more fixes for ax88178 phy init
 sequence
From: David Miller <davem@davemloft.net>
In-Reply-To: <1321377163-26308-4-git-send-email-grundler@chromium.org>
References: <1321377163-26308-1-git-send-email-grundler@chromium.org>
	<1321377163-26308-4-git-send-email-grundler@chromium.org>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 15 Nov 2011 13:42:04 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Grundler <grundler@chromium.org>
Date: Tue, 15 Nov 2011 09:12:42 -0800

> From: Grant Grundler <grundler@google.com>
> 
> Now works on Samsung Series 5 (chromebook)
> 
> Two fixes here:
> o use 0x7F mask for phymode
> o read phyid *AFTER* phy is powered up (via GPIOs)
> 
> Signed-off-by: Allan Chou <allan@asix.com.tw>
> Signed-off-by: Grant Grundler <grundler@chromium.org>

Applied.
