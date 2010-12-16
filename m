Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756952Ab0LPUfa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 15:35:30 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40231
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756186Ab0LPUf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 15:35:29 -0500
Date: Thu, 16 Dec 2010 12:35:57 -0800 (PST)
Message-Id: <20101216.123557.28816578.davem@davemloft.net>
To: davidel@xmailserver.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [patch] make pipes use event aware wakeups
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.DEB.2.00.1012161228530.25094@davide-lnx1>
References: <alpine.DEB.2.00.1012161228530.25094@davide-lnx1>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davide Libenzi <davidel@xmailserver.org>
Date: Thu, 16 Dec 2010 12:32:42 -0800 (PST)

> I thought this was alreay merged, but this thread brought to my attention 
> it wasn't:
> 
> https://lkml.org/lkml/2010/12/15/234
> 
> This patch sends the events the wakeup refers to, so that epoll, and even 
> the new poll code in fs/select.c can avoid wakeups in events are not 
> matching the requested set.
> 
> 
> Signed-off-by: Davide Libenzi <davidel@xmailserver.org>

Acked-by: David S. Miller <davem@davemloft.net>
