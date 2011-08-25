Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755606Ab1HYWFD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 18:05:03 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60251 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755525Ab1HYWFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 18:05:01 -0400
Date: Thu, 25 Aug 2011 15:04:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Eric Dumazet <eric.dumazet@gmail.com>,
        netdev <netdev@vger.kernel.org>
Subject: Re: RFC: Remove unnecessary / duplicate OOM printks
Message-Id: <20110825150456.fc8720c4.akpm@linux-foundation.org>
In-Reply-To: <1314305243.4637.10.camel@Joe-Laptop>
References: <1314305243.4637.10.camel@Joe-Laptop>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Aug 2011 13:47:23 -0700
Joe Perches <joe@perches.com> wrote:

> There are many thousands of printks for OOM conditions
> in kernel sources.
> 
> These are almost always a duplication of a generic
> OOM message from the mm subsystem.
> 
> The biggest difference between the generic OOM and
> the specific OOM uses is that most of the specific
> messages are emitted at KERN_ERR but the generic
> message is at KERN_WARNING.
> 
> Many KB of code/text could be removed from the kernel.
> 
> Removal can be gradual and done by subsystem.
> 
> Some kmalloc's that are followed on failure by vmalloc
> may need to add GFP_NOWARN.
> 
> Does anyone really believe the per site failure
> messages are useful or really want them to keep them?
> 

Kill 'em.
