Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906Ab0DAH0a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 03:26:30 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45025
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753878Ab0DAH0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 03:26:22 -0400
Date: Thu, 01 Apr 2010 00:26:22 -0700 (PDT)
Message-Id: <20100401.002622.179174704.davem@davemloft.net>
To: w@1wt.eu
Cc: gregkh@suse.de, david@fromorbit.com, linux-kernel@vger.kernel.org,
       stable@kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, stable-review@kernel.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [Stable-review] 4 stable kernel review cycles starting
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100401044048.GD16238@1wt.eu>
References: <20100331215332.GH7671@dastard>
	<20100331224755.GA23284@suse.de>
	<20100401044048.GD16238@1wt.eu>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Willy Tarreau <w@1wt.eu>
Date: Thu, 1 Apr 2010 06:40:48 +0200

> For this reason, IMHO it helps when submitters can indicate in each
> patch the mainline equivalent ID, or alternatively that it's pointless
> to look for it because the fix is much different.

I put this at the top of every networking/ide/sparc commit message
for -stable submissions I make.

In fact I thought that was a requirement for -stable submissions?
