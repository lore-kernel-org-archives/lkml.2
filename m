Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932432Ab1GEMtq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 08:49:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:34583 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932305Ab1GEMto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 08:49:44 -0400
X-Authority-Analysis: v=1.1 cv=IOX921YOuPvYFce5aSLzPVIStpiCPR9M8R83dyHW74w= c=1 sm=0 a=xI8xauJYd-MA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=20KFwNOVAAAA:8 a=VnNF1IyMAAAA:8 a=jbeWiZRsRFcSzwvrLL4A:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=jEp0ucaQiEUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [patch 09/11] s390/irqs: Do not trace arch_local_{*,irq_*}
 functions
From: Steven Rostedt <rostedt@goodmis.org>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
In-Reply-To: <20110704101053.38717f0b@mschwide>
References: <20110702030435.308336775@goodmis.org>
	 <20110702033854.283591061@goodmis.org>  <20110704101053.38717f0b@mschwide>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 05 Jul 2011 08:49:43 -0400
Message-ID: <1309870183.26417.170.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-07-04 at 10:10 +0200, Martin Schwidefsky wrote:
> On Fri, 01 Jul 2011 23:04:44 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
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
> > Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> > Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> Applied to git390, thanks Steven.
> 

Thanks Martin,

-- Steve


