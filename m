Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075Ab1BAWRt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 17:17:49 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38906
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752434Ab1BAWRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 17:17:48 -0500
Date: Tue, 01 Feb 2011 14:18:23 -0800 (PST)
Message-Id: <20110201.141823.59678888.davem@davemloft.net>
To: weil@mail.berlios.de
Cc: isdn@linux-pingi.de, tj@kernel.org, rostedt@goodmis.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] isdn: icn: Fix potentially wrong string handling
From: David Miller <davem@davemloft.net>
In-Reply-To: <1296419486-5482-1-git-send-email-weil@mail.berlios.de>
References: <1296419486-5482-1-git-send-email-weil@mail.berlios.de>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Weil <weil@mail.berlios.de>
Date: Sun, 30 Jan 2011 21:31:26 +0100

> This warning was reported by cppcheck:
> drivers/isdn/icn/icn.c:1641: error: Dangerous usage of 'rev' (strncpy doesn't always 0-terminate it)
> 
> If strncpy copied 20 bytes, the destination string rev was not terminated.
> The patch adds one more byte to rev and makes sure that this byte is
> always 0.
> 
> Cc: Karsten Keil <isdn@linux-pingi.de>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: netdev@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Stefan Weil <weil@mail.berlios.de>

Applied, thanks.
