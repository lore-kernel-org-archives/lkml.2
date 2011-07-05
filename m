Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756221Ab1GEMtJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 08:49:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:40168 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755887Ab1GEMtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 08:49:08 -0400
X-Authority-Analysis: v=1.1 cv=PfPQ8rIoTcZsncbPZjVSZ7K0hy8Zc4hmL68r4VPNpKE= c=1 sm=0 a=p8tmD1xM9-MA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=20KFwNOVAAAA:8 a=J1Y8HTJGAAAA:8 a=jbeWiZRsRFcSzwvrLL4A:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=jEp0ucaQiEUA:10 a=4N9Db7Z2_RYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [patch 11/11] sparc/irqs: Do not trace arch_local_{*,irq_*}
 functions
From: Steven Rostedt <rostedt@goodmis.org>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <20110701.211125.1336236217021544514.davem@davemloft.net>
References: <20110702030435.308336775@goodmis.org>
	 <20110702033854.600969289@goodmis.org>
	 <20110701.211125.1336236217021544514.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 05 Jul 2011 08:49:06 -0400
Message-ID: <1309870146.26417.168.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-01 at 21:11 -0700, David Miller wrote:
> From: Steven Rostedt <rostedt@goodmis.org>
> Date: Fri, 01 Jul 2011 23:04:46 -0400
> 
> > From: Steven Rostedt <srostedt@redhat.com>
> > 
> > Do not trace arch_local_save_flags(), arch_local_irq_*() and friends.
> > Although they are marked inline, gcc may still make a function out of
> > them and add it to the pool of functions that are traced by the function
> > tracer. This can cause undesirable results (kernel panic, triple faults,
> > etc).
> > 
> > Add the notrace notation to prevent them from ever being traced.
> > 
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> Acked-by: David S. Miller <davem@davemloft.net>

Thanks David!

Could you pull the patch into your tree. It's not dependent on any other
patch, so I feel more comfortable that it goes through yours than the
tracing tree.

Thanks,

-- Steve


