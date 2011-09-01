Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757735Ab1IAOyh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 10:54:37 -0400
Received: from www.linutronix.de ([62.245.132.108]:51919 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757628Ab1IAOyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 10:54:36 -0400
Date: Thu, 1 Sep 2011 16:54:31 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: process time < thread time?
In-Reply-To: <1314874459.7945.22.camel@twins>
Message-ID: <alpine.LFD.2.02.1109011653450.2723@ionos>
References: <20110831.230718.2029810906806382170.davem@davemloft.net>   <alpine.LFD.2.02.1109011148060.2723@ionos>  <1314871884.7945.20.camel@twins> <alpine.LFD.2.02.1109011226160.2723@ionos> <1314874459.7945.22.camel@twins>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Sep 2011, Peter Zijlstra wrote:
> On Thu, 2011-09-01 at 12:39 +0200, Thomas Gleixner wrote:
> > > I think we just deadlocked:
> > 
> > That's why I said untested :) 
> 
> Reported-by: David Miller <davem@davemloft.net>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Link: http://lkml.kernel.org/n/tip-nk5489zjtxsln3ixjonjs3h3@git.kernel.org

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
