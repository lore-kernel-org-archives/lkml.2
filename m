Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757520Ab1GMBhE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 21:37:04 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:53986 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755008Ab1GMBhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 21:37:01 -0400
X-Authority-Analysis: v=1.1 cv=PfPQ8rIoTcZsncbPZjVSZ7K0hy8Zc4hmL68r4VPNpKE= c=1 sm=0 a=WrRwyXlJCEoA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=9IeuSSz_9l2xTLTEHZAA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [patch 10/11] sh/unicore32/irqs: Do not trace
 arch_local_{*,irq_*} functions
From: Steven Rostedt <rostedt@goodmis.org>
To: Paul Mundt <lethal@linux-sh.org>
Cc: gxt@mprc.pku.edu.cn, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20110711033418.GF24169@linux-sh.org>
References: <20110702030435.308336775@goodmis.org>
	 <20110702033854.432833160@goodmis.org>
	 <1309744599.2291.1.camel@epip-laptop>
	 <1309870230.26417.171.camel@gandalf.stny.rr.com>
	 <20110711033418.GF24169@linux-sh.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 12 Jul 2011 21:36:57 -0400
Message-ID: <1310521017.3931.19.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-07-11 at 12:34 +0900, Paul Mundt wrote:
> On Tue, Jul 05, 2011 at 08:50:30AM -0400, Steven Rostedt wrote:
> > 
> > Are you or Paul going to pull it into the sh tree?
> > 
> I don't mind pulling it in, but it's probably easier to simply have it
> lumped with the rest of the changes.

Hi Paul,

This "patch series" was just a email to all arch maintainers to the code
I modified. I'm not pulling this into any branch nor have I asked for
this series to go anywhere. This change is not dependent on any other
change nor is any other change dependent on this one. So I figured that
each maintainer could pull it in at their own free will.

Thanks!

-- Steve


