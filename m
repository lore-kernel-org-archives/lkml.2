Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757471Ab2DFRSK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 13:18:10 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:40273 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152Ab2DFRSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 13:18:08 -0400
Date: Fri, 06 Apr 2012 13:18:00 -0400 (EDT)
Message-Id: <20120406.131800.651812823796333479.davem@davemloft.net>
To: john@keeping.me.uk
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        mihai.maruseac@gmail.com
Subject: Re: [PATCH] net/core: Fix seeking in /proc/net/dev
From: David Miller <davem@davemloft.net>
In-Reply-To: <1333731944-15808-1-git-send-email-john@keeping.me.uk>
References: <1333731944-15808-1-git-send-email-john@keeping.me.uk>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 06 Apr 2012 10:18:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Eric Dumazet already fixed this the other day.
