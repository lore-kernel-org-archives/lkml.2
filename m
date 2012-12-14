Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756879Ab2LNSQN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 13:16:13 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:48882 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756648Ab2LNSQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 13:16:10 -0500
Date: Fri, 14 Dec 2012 13:16:09 -0500 (EST)
Message-Id: <20121214.131609.2271247275899669616.davem@davemloft.net>
To: khlebnikov@openvz.org
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, isdn@linux-pingi.de
Subject: Re: [PATCH 03/12] mISDN: fix race in timer canceling on module
 unloading
From: David Miller <davem@davemloft.net>
In-Reply-To: <20121214110236.11019.98301.stgit@zurg>
References: <20121214110229.11019.63713.stgit@zurg>
	<20121214110236.11019.98301.stgit@zurg>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Date: Fri, 14 Dec 2012 15:02:36 +0400

> Using timer_pending() without additional syncronization is racy,
> del_timer_sync() must be used here for waiting in-flight handler.
> Bug caught with help from "debug-objects" during random insmod/rmmod.
> 
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>

Applied.
