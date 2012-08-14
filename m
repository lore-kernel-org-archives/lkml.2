Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756505Ab2HNPRL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 11:17:11 -0400
Received: from www.linutronix.de ([62.245.132.108]:59707 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167Ab2HNPRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 11:17:09 -0400
Date: Tue, 14 Aug 2012 17:17:07 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: LKML <linux-kernel@vger.kernel.org>, Ben Hutchings <ben@decadent.org.uk>,
        RT <linux-rt-users@vger.kernel.org>
Subject: Re: Using random in interrupts for RT
In-Reply-To: <1344954649.6724.13.camel@gandalf.stny.rr.com>
Message-ID: <alpine.LFD.2.02.1208141716170.32033@ionos>
References: <1344954649.6724.13.camel@gandalf.stny.rr.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Aug 2012, Steven Rostedt wrote:
> Ben Hutchings asked me if we still need "genirq: Disable random call on
> preempt-rt" for -rt? With commit 902c098a366 "random: use lockless
> techniques in the interrupt path" there is no more locks used. But does
> it still produce high latencies?

Haven't tested it. Will put it on my ever growing todo list....
