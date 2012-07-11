Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756997Ab2GKLAN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 07:00:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:57469 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112Ab2GKLAL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 07:00:11 -0400
Message-ID: <1342004396.3462.140.camel@twins>
Subject: Re: [PATCH 0/6] Fix for leapsecond caused hrtimer/futex issue
 (updated)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: John Stultz <johnstul@us.ibm.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org
Date: Wed, 11 Jul 2012 12:59:56 +0200
In-Reply-To: <1341960205-56738-1-git-send-email-johnstul@us.ibm.com>
References: <1341960205-56738-1-git-send-email-johnstul@us.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-07-10 at 18:43 -0400, John Stultz wrote:
> Over the weekend, Thomas got a chance to review the leap second fix
> in more detail and had a few additional changes he wanted to make
> to improve performance as well as style.
> 
> So this iteration includes his modifications.
> 
> Once merged, I'll be working to get the backports finished as quickly
> as I can and sent to -stable. 

I think we all dislike 1/6, but I can't come up with anything saner
either. The rest looks good.

The only thing I found (and already mentioned to Thomas) is that the
Changelog of 1/6 could be improved by mentioning why we're in hardirq
context to begin with.

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
