Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988Ab1GFGn0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 02:43:26 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:36944 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775Ab1GFGnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 02:43:25 -0400
Date: Tue, 05 Jul 2011 23:43:16 -0700 (PDT)
Message-Id: <20110705.234316.743417165606294878.davem@davemloft.net>
To: rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [patch 11/11] sparc/irqs: Do not trace arch_local_{*,irq_*}
 functions
From: David Miller <davem@davemloft.net>
In-Reply-To: <1309870146.26417.168.camel@gandalf.stny.rr.com>
References: <20110702033854.600969289@goodmis.org>
	<20110701.211125.1336236217021544514.davem@davemloft.net>
	<1309870146.26417.168.camel@gandalf.stny.rr.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 05 Jul 2011 23:43:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>
Date: Tue, 05 Jul 2011 08:49:06 -0400

> Could you pull the patch into your tree. It's not dependent on any other
> patch, so I feel more comfortable that it goes through yours than the
> tracing tree.

Will do.
