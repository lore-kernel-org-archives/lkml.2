Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757939Ab2EaHwt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 03:52:49 -0400
Received: from www.linutronix.de ([62.245.132.108]:55393 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757874Ab2EaHws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 03:52:48 -0400
Date: Thu, 31 May 2012 09:52:45 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dave Jones <davej@redhat.com>
cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: NOHZ: local_softirq_pending 08
In-Reply-To: <20120530214809.GA19223@redhat.com>
Message-ID: <alpine.LFD.2.02.1205310938080.3231@ionos>
References: <20120530214809.GA19223@redhat.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave,

On Wed, 30 May 2012, Dave Jones wrote:

> May 30 17:43:04 [ 1095.335659] NOHZ: local_softirq_pending 08
> 
> According to git, you ratelimited this back in 2007 with the message
> "until we found the root cause of that problem."
> 
> Is this an old problem that has returned ?

Looks like.
 
> Maybe interesting note: Both machines I see this on regularly are Atom cpus,
> and it's always '08'.

So it goes idle with NET_RX softirq pending. That really should not
happen. I fear you need to fire up the tracer :)

Thanks,

	tglx
