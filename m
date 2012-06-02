Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965845Ab2FBVJW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2012 17:09:22 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:50753 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965421Ab2FBVJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2012 17:09:21 -0400
Date: Sat, 02 Jun 2012 17:09:19 -0400 (EDT)
Message-Id: <20120602.170919.987778525333188042.davem@davemloft.net>
To: linux@rainbow-software.org
Cc: andi@lisas.de, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mcs7830: Implement link state detection
From: David Miller <davem@davemloft.net>
In-Reply-To: <201206012229.11530.linux@rainbow-software.org>
References: <201206012229.11530.linux@rainbow-software.org>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ondrej Zary <linux@rainbow-software.org>
Date: Fri, 1 Jun 2012 22:29:08 +0200

> Add .status callback that detects link state changes.
> Tested with MCS7832CV-AA chip (9710:7830, identified as rev.C by the driver).
> Fixes https://bugzilla.kernel.org/show_bug.cgi?id=28532
> 
> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

Applied.
