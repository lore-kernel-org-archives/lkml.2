Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039Ab0KIR0J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 12:26:09 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34831
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753901Ab0KIR0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 12:26:06 -0500
Date: Tue, 09 Nov 2010 09:26:30 -0800 (PST)
Message-Id: <20101109.092630.260076036.davem@davemloft.net>
To: segooon@gmail.com
Cc: kernel-janitors@vger.kernel.org, jon.maloy@ericsson.com,
        allan.stephens@windriver.com, tipc-discussion@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] net: tipc: fix information leak to userland
From: David Miller <davem@davemloft.net>
In-Reply-To: <1288545032-16481-1-git-send-email-segooon@gmail.com>
References: <1288545032-16481-1-git-send-email-segooon@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vasiliy Kulikov <segooon@gmail.com>
Date: Sun, 31 Oct 2010 20:10:32 +0300

> Structure sockaddr_tipc is copied to userland with padding bytes after
> "id" field in union field "name" unitialized.  It leads to leaking of
> contents of kernel stack memory.  We have to initialize them to zero.
> 
> Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>

Applied.

Patches #1 and #2 were given feedback which I need you to integrate
and submit new patches based upon, thanks.
