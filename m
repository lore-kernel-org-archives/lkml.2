Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752038Ab1CJPzn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 10:55:43 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:38382 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958Ab1CJPzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 10:55:42 -0500
X-Authority-Analysis: v=1.1 cv=UQuFHoD2CPQ248x8AXEbKhr4z9AaDqApxmEl3BhfZ64= c=1 sm=0 a=T5FwMGfWojYA:10 a=kj9zAlcOel0A:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=hOe2yjtxAAAA:8 a=20KFwNOVAAAA:8 a=8K3J5TjlYTY8Y11SnpoA:9 a=MK8PVzDHJtcm-QHJunt58Ib38JIA:4 a=CjuIK1q_8ugA:10 a=jEp0ucaQiEUA:10 a=tYyAPF7e_P831acl:21 a=bUuI-wUtGtYQNJNl:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Date: Thu, 10 Mar 2011 10:55:39 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Roland McGrath <roland@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        jan.kratochvil@redhat.com, Denys Vlasenko <vda.linux@googlemail.com>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Subject: Re: [RFC] Proposal for ptrace improvements
Message-ID: <20110310155539.GC12521@home.goodmis.org>
References: <20110301152457.GE26074@htj.dyndns.org>
 <20110307204346.19557183C29@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110307204346.19557183C29@magilla.sf.frob.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 07, 2011 at 12:43:46PM -0800, Roland McGrath wrote:
> I've only skimmed through this whole thread, and I'm not going to try to
> respond to all the details.  I've lost interest in working in this area
> and I don't plan to keep up with all the details any more.  If you want
> to reach me about kernel subjects after March 11, you'll need to use the
> address <roland@hack.frob.com> as I won't be getting @redhat.com any more.

Sorry to hear this. I guess working on ptrace make anyone want to leave.

I guess your last patch to this matter should then be:

diff --git a/MAINTAINERS b/MAINTAINERS
index 560ecce..62859ca 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5022,7 +5022,6 @@ S:        Maintained
 F:     drivers/block/ps3vram.c
 
 PTRACE SUPPORT
-M:     Roland McGrath <roland@redhat.com>
 M:     Oleg Nesterov <oleg@redhat.com>
 S:     Maintained
 F:     include/asm-generic/syscall.h


I hope you will still be involved in the community for other aspects of the
kernel.

-- Steve

