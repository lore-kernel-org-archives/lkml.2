Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932409Ab1GEMt0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 08:49:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:34309 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932294Ab1GEMtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 08:49:24 -0400
X-Authority-Analysis: v=1.1 cv=IOX921YOuPvYFce5aSLzPVIStpiCPR9M8R83dyHW74w= c=1 sm=0 a=29GGvLjOf54A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=jbeWiZRsRFcSzwvrLL4A:9 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [patch 05/11] microblaze/irqs: Do not trace
 arch_local_{*,irq_*} functions
From: Steven Rostedt <rostedt@goodmis.org>
To: monstr@monstr.eu
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <4E12EAE9.2090305@monstr.eu>
References: <20110702030435.308336775@goodmis.org>
	 <20110702033853.617637031@goodmis.org>  <4E12EAE9.2090305@monstr.eu>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 05 Jul 2011 08:49:22 -0400
Message-ID: <1309870162.26417.169.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-07-05 at 12:43 +0200, Michal Simek wrote:
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
> > Cc: Michal Simek <monstr@monstr.eu>
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> Applied.
> 

Thanks!

-- Steve


