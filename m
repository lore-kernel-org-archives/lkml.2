Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855Ab0K2QJZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 11:09:25 -0500
Received: from one.firstfloor.org ([213.235.205.2]:55792 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754833Ab0K2QJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 11:09:23 -0500
Date: Mon, 29 Nov 2010 17:09:19 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-arch@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>, Tejun Heo <tj@kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: Re: [PATCH v2 0/4] kthread: NUMA aware kthread_create_on_cpu()
Message-ID: <20101129160919.GB15763@basil.fritz.box>
References: <1290972833.29196.90.camel@edumazet-laptop>
 <20101128224024.GA12300@basil.fritz.box>
 <1290984712.29196.100.camel@edumazet-laptop>
 <20101128230146.GB12300@basil.fritz.box>
 <1290987424.29196.128.camel@edumazet-laptop>
 <20101129090510.GA15763@basil.fritz.box>
 <1291023532.3435.29.camel@edumazet-laptop>
 <1291043604.3435.969.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291043604.3435.969.camel@edumazet-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 29, 2010 at 04:13:23PM +0100, Eric Dumazet wrote:
> Note : compiled and tested on x86_32 and x86_64 only, but these patches
> take care of other arches as well.
> 
> Cc: linux-arch@vger.kernel.org 
> 
> Thanks for your feedback Andi !

Looks good to me now. You can add

Reviewed-by: Andi Kleen <ak@linux.intel.com>

to the four patches.
-Andi
