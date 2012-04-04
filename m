Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757147Ab2DDVo6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 17:44:58 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:50134 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753635Ab2DDVo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 17:44:57 -0400
Date: Wed, 04 Apr 2012 17:44:51 -0400 (EDT)
Message-Id: <20120404.174451.1247414877210242753.davem@davemloft.net>
To: cmetcalf@tilera.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tilepro ethernet driver: fix a few minor issues
From: David Miller <davem@davemloft.net>
In-Reply-To: <4F7C3C00.5020105@tilera.com>
References: <201203302325.q2UNPm8j012403@farm-0012.internal.tilera.com>
	<20120403.182335.782073108961783777.davem@davemloft.net>
	<4F7C3C00.5020105@tilera.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 04 Apr 2012 14:44:55 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Metcalf <cmetcalf@tilera.com>
Date: Wed, 4 Apr 2012 08:18:08 -0400

> It didn't occur to me that you would push it through the net tree; I
> assumed I would push it through the tile tree.

If it's purely changes inside the networking driver, best to push
it through the networking tree(s).

