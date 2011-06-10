Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932181Ab1FJNKi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 09:10:38 -0400
Received: from www.linutronix.de ([62.245.132.108]:37095 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932167Ab1FJNKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 09:10:34 -0400
Date: Fri, 10 Jun 2011 15:10:32 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
cc: LKML <linux-kernel@vger.kernel.org>, Alan Piszcz <ap@solarrain.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: 2.6.39: crash w/threadirqs option enabled
In-Reply-To: <alpine.DEB.2.02.1106100854250.23139@p34.internal.lan>
Message-ID: <alpine.LFD.2.02.1106101510110.11814@ionos>
References: <alpine.DEB.2.02.1105200405210.24033@p34.internal.lan> <alpine.LFD.2.02.1105201445300.3078@ionos> <alpine.DEB.2.02.1105200850080.19553@p34.internal.lan> <alpine.LFD.2.02.1105201528500.3078@ionos> <alpine.DEB.2.02.1105200945300.19553@p34.internal.lan>
 <alpine.LFD.2.02.1105201712501.3078@ionos> <alpine.DEB.2.02.1105201210030.19553@p34.internal.lan> <alpine.LFD.2.02.1105201819310.3078@ionos> <alpine.DEB.2.02.1106100414550.32450@p34.internal.lan> <alpine.LFD.2.02.1106101450030.11814@ionos>
 <alpine.DEB.2.02.1106100854250.23139@p34.internal.lan>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Jun 2011, Justin Piszcz wrote:
> On Fri, 10 Jun 2011, Thomas Gleixner wrote:
> > If you remove the threadirqs option from the commandline it does not
> > happen, right?
> Yes, most often anyhow (still using that option)

-ENOPARSE
