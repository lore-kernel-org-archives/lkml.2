Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756702Ab0E1PWi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 11:22:38 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58188 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920Ab0E1PWh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 11:22:37 -0400
Subject: Re: [RFC] oom-kill: give the dying task a higher priority
From: Peter Zijlstra <peterz@infradead.org>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       balbir@linux.vnet.ibm.com, Oleg Nesterov <oleg@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Thomas Gleixner <tglx@linutronix.de>,
       David Rientjes <rientjes@google.com>, Mel Gorman <mel@csn.ul.ie>,
       williams@redhat.com
In-Reply-To: <20100528151249.GB12035@barrios-desktop>
References: <20100528143605.7E2A.A69D9226@jp.fujitsu.com>
	 <AANLkTikB-8Qu03VrA5Z0LMXM_alSV7SLqzl-MmiLmFGv@mail.gmail.com>
	 <20100528145329.7E2D.A69D9226@jp.fujitsu.com>
	 <20100528125305.GE11364@uudg.org> <20100528140623.GA11041@barrios-desktop>
	 <20100528143617.GF11364@uudg.org>  <20100528151249.GB12035@barrios-desktop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 28 May 2010 17:21:43 +0200
Message-ID: <1275060103.27810.9651.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-05-29 at 00:12 +0900, Minchan Kim wrote:
> I think highest RT proirity ins't good solution.
> As I mentiond, Some RT functions don't want to be preempted by other processes
> which cause memory pressure. It makes RT task broken.

All the patches I've seen use MAX_RT_PRIO-1, which is actually FIFO-1,
which is the lowest RT priority.


