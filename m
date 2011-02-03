Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148Ab1BCAsn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 19:48:43 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49056
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756127Ab1BCAsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 19:48:41 -0500
Date: Wed, 02 Feb 2011 16:49:17 -0800 (PST)
Message-Id: <20110202.164917.232759278.davem@davemloft.net>
To: rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, akpm@linux-foundation.org,
        fweisbec@gmail.com, mathieu.desnoyers@efficios.com
Subject: Re: [PATCH 1/2] tracing: Replace trace_event struct array with
 pointer array
From: David Miller <davem@davemloft.net>
In-Reply-To: <1296694018.10797.78.camel@gandalf.stny.rr.com>
References: <20110202180938.106599012@goodmis.org>
	<20110202.145023.183036454.davem@davemloft.net>
	<1296694018.10797.78.camel@gandalf.stny.rr.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>
Date: Wed, 02 Feb 2011 19:46:58 -0500

> Did you want to test this patch too. I'm still running it through my
> tests, but here's a heads up on it.

I'll do some testing when you repost the series.  And you can toss
my ACK onto this one right now if you like:

Acked-by: David S. Miller <davem@davemloft.net>

Thanks Steven.
