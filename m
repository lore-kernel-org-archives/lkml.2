Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757176Ab1CRQgK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 12:36:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43921 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757074Ab1CRQgI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 12:36:08 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <alpine.LFD.2.00.1101311446570.31804@localhost6.localdomain6>
References: <alpine.LFD.2.00.1101311446570.31804@localhost6.localdomain6> <20110127145741.23248.68098.stgit@localhost> <20110127150011.23248.62040.stgit@localhost>
To: Torben Hohn <torbenh@gmx.de>, Thomas Gleixner <tglx@linutronix.de>
Cc: dhowells@redhat.com, LKML <linux-kernel@vger.kernel.org>,
        hch@infradead.org, Peter Zijlstra <peterz@infradead.org>,
        johnstul@us.ibm.com, yong.zhang0@gmail.com,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Subject: Re: [PATCH v2 16/20] mn10300: switch do_timer() to xtimer_update()
Date: Fri, 18 Mar 2011 16:35:41 +0000
Message-ID: <19895.1300466141@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner <tglx@linutronix.de> wrote:

> > xtimer_update() properly takes the xtime_lock.
> > mn10300_last_tsc is only accessed from this function.
> 
> This patch can be dropped as that code is dead. I sent a cleanup patch
> to the mn10300 folks.

This patch seems to have gone in anyway and Thomas's cleanup patch no longer
applies; should I revert it and apply Thomas's cleanup patch?

David
