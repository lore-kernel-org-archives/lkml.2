Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756092Ab0J0TYQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 15:24:16 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42121
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755753Ab0J0TYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 15:24:14 -0400
Date: Wed, 27 Oct 2010 12:24:38 -0700 (PDT)
Message-Id: <20101027.122438.191405610.davem@davemloft.net>
To: julia@diku.dk
Cc: wharms@bfs.de, isdn@linux-pingi.de, kernel-janitors@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/14] drivers/isdn: delete double assignment
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.1010261419510.25281@ask.diku.dk>
References: <1288088743-3725-11-git-send-email-julia@diku.dk>
	<4CC6C1C0.8020005@bfs.de>
	<Pine.LNX.4.64.1010261419510.25281@ask.diku.dk>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>
Date: Tue, 26 Oct 2010 14:20:56 +0200 (CEST)

> From: Julia Lawall <julia@diku.dk>
> 
> Delete successive assignments to the same location.  In the first case, the
> hscx array has two elements, so change the assignment to initialize the
> second one.  In the second case, the two assignments are simply identical.
> Furthermore, neither is necessary, because the effect of the assignment is
> only visible in the next line, in the assignment in the if test.  The patch
> inlines the right hand side value in the latter assignment and pulls that
> assignment out of the if test.
> 
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
 ...
> Signed-off-by: Julia Lawall <julia@diku.dk>

Applied.
