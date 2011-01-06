Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247Ab1AFShE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 13:37:04 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44990
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752883Ab1AFShD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 13:37:03 -0500
Date: Thu, 06 Jan 2011 10:37:34 -0800 (PST)
Message-Id: <20110106.103734.226774476.davem@davemloft.net>
To: fweisbec@gmail.com
Cc: mathieu.desnoyers@efficios.com, rostedt@goodmis.org, nhorman@tuxdriver.com,
        zhaolei@cn.fujitsu.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
        tglx@linutronix.de
Subject: Re: [PATCH] trace event skb remove duplicate null-pointer check
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110106181726.GF2308@nowhere>
References: <20110106175319.GA30610@Krystal>
	<20110106.101544.193712005.davem@davemloft.net>
	<20110106181726.GF2308@nowhere>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>
Date: Thu, 6 Jan 2011 19:17:29 +0100

> On Thu, Jan 06, 2011 at 10:15:44AM -0800, David Miller wrote:
>> From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
>> Date: Thu, 6 Jan 2011 12:53:19 -0500
>> 
>> > The check for NULL skb in the kfree_skb trace event is a duplicate from the
>> > check already done in its only caller, kfree_skb(). Remove this duplicate check.
>> > 
>> > Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
>> > Acked-by: Neil Horman <nhorman@tuxdriver.com>
>> 
>> Acked-by: David S. Miller <davem@davemloft.net>
> 
> May be you want to take that on the net tree? Looks like more appropriate.
> Of course this can go through the tracing tree as well.

You guys can take it in the tracing tree, this actually makes things
easier for me.
