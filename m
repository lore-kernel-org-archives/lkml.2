Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750891Ab1GOLXQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 07:23:16 -0400
Received: from anchor-post-3.mail.demon.net ([195.173.77.134]:51467 "EHLO
	anchor-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750745Ab1GOLXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 07:23:15 -0400
Subject: Re: [PATCH] sched: reorder root_domain to remove 64 bit alignment
 padding
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Date: Fri, 15 Jul 2011 12:23:14 +0100
In-Reply-To: <1310726660.2586.313.camel@twins>
References: <1310726492.1977.5.camel@castor.rsk>
	 <1310726660.2586.313.camel@twins>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1310728994.1977.15.camel@castor.rsk>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-15 at 12:44 +0200, Peter Zijlstra wrote:
> On Fri, 2011-07-15 at 11:41 +0100, Richard Kennedy wrote:
> > Reorder root_domain to remove 8 bytes of alignment padding on 64 bit
> > builds, this shrinks the size from 1736 to 1728 bytes, therefore using
> > one fewer cachelines.
> 
> depends a bit on how insane struct cpupri is, but yeah, good compaction.
> Thanks!

Thanks Peter,

argh -- I hadn't spotted that cpupri used NR_CPUS and was so variable in
size. I guess there won't be much benefit then, as the distros seem to
always set NR_CPUS to some insanely huge value ;)

regards
Richard 


