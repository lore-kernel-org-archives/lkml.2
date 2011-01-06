Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751856Ab1AFSPO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 13:15:14 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52527
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751362Ab1AFSPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 13:15:13 -0500
Date: Thu, 06 Jan 2011 10:15:44 -0800 (PST)
Message-Id: <20110106.101544.193712005.davem@davemloft.net>
To: mathieu.desnoyers@efficios.com
Cc: rostedt@goodmis.org, nhorman@tuxdriver.com, fweisbec@gmail.com,
        zhaolei@cn.fujitsu.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
        tglx@linutronix.de
Subject: Re: [PATCH] trace event skb remove duplicate null-pointer check
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110106175319.GA30610@Krystal>
References: <20110106175319.GA30610@Krystal>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Date: Thu, 6 Jan 2011 12:53:19 -0500

> The check for NULL skb in the kfree_skb trace event is a duplicate from the
> check already done in its only caller, kfree_skb(). Remove this duplicate check.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Acked-by: Neil Horman <nhorman@tuxdriver.com>

Acked-by: David S. Miller <davem@davemloft.net>
