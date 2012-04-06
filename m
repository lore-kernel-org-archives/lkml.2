Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757608Ab2DFRnS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 13:43:18 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:48303 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753954Ab2DFRnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 13:43:17 -0400
Subject: Re: [PATCH] net/core: Fix seeking in /proc/net/dev
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: john@keeping.me.uk, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        mihai.maruseac@gmail.com
In-Reply-To: <20120406.131800.651812823796333479.davem@davemloft.net>
References: <1333731944-15808-1-git-send-email-john@keeping.me.uk>
	 <20120406.131800.651812823796333479.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 06 Apr 2012 19:43:12 +0200
Message-ID: <1333734192.3007.5.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-04-06 at 13:18 -0400, David Miller wrote:
> Eric Dumazet already fixed this the other day.
> --

John, take a look at 

http://git.kernel.org/?p=linux/kernel/git/davem/net.git;a=commit;h=2def16ae6b0c77571200f18ba4be049b03d75579

Thanks


