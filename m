Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758166Ab2JKIBU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 04:01:20 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:50133 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757827Ab2JKIBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 04:01:17 -0400
Date: Thu, 11 Oct 2012 09:01:08 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: vaibhav shinde <v.bhav.shinde@gmail.com>
Cc: trisha yad <trisha1march@gmail.com>, linux-kernel@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>
Subject: Re: DEBUG_STACKOVERFLOW issue on ARM
Message-ID: <20121011080108.GL4625@n2100.arm.linux.org.uk>
References: <CAGr+u+yxC3nPrsW+EU9qwh0ggjqrg9K=1ftQXfds8unMiDMZsA@mail.gmail.com> <20121005083113.GG4625@n2100.arm.linux.org.uk> <CAB5gotsV-yOU6F2n_-HhVmheMKFX1miyw6yZMogV7+kKe4Jggw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAB5gotsV-yOU6F2n_-HhVmheMKFX1miyw6yZMogV7+kKe4Jggw@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 11, 2012 at 01:09:46PM +0530, vaibhav shinde wrote:
> Hi Russel,
> 
> On Fri, Oct 5, 2012 at 2:01 PM, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
> >
> > On Wed, Oct 03, 2012 at 05:18:56PM +0530, trisha yad wrote:
> > > I wish to know how can I support this function in 3.0 ?
> >
> > If your description is correct, then all you need to do is to ensure
> > that you route interrupts to other CPUs.
> >
> > You can do that by running the userspace irqbalance daemon.
> >
> 
> I also tried with the irqbalance daemon, on ARM quad core architecture,
> and as per my understanding, the daemon sets the
> /proc/irq/<irq.no.>/smp_affinity
> file according to the irq frequency on a particular processor.
> 
>           However, the daemon doesn't work as expected, I also tried
> accessing the
> proc file mentioned above to set the cpu mask for particular irq, but this
> just block the processing of the irq, as I see the count of that irq
> doesnt increase
> in /proc/interrupts.
> 
>             My conclusion is that the irqbalancing is not supported on
> ARM arch or there is
> something  more required for this to work. Kindly provide some
> pointers over this.

Sounds like something has been broken, no idea what.  It needs investigation.
