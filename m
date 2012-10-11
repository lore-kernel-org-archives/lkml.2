Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757656Ab2JKHju (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 03:39:50 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:55581 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754963Ab2JKHjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 03:39:47 -0400
MIME-Version: 1.0
In-Reply-To: <20121005083113.GG4625@n2100.arm.linux.org.uk>
References: <CAGr+u+yxC3nPrsW+EU9qwh0ggjqrg9K=1ftQXfds8unMiDMZsA@mail.gmail.com>
	<20121005083113.GG4625@n2100.arm.linux.org.uk>
Date: Thu, 11 Oct 2012 13:09:46 +0530
Message-ID: <CAB5gotsV-yOU6F2n_-HhVmheMKFX1miyw6yZMogV7+kKe4Jggw@mail.gmail.com>
Subject: Re: DEBUG_STACKOVERFLOW issue on ARM
From: vaibhav shinde <v.bhav.shinde@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: trisha yad <trisha1march@gmail.com>, linux-kernel@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russel,

On Fri, Oct 5, 2012 at 2:01 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
>
> On Wed, Oct 03, 2012 at 05:18:56PM +0530, trisha yad wrote:
> > I wish to know how can I support this function in 3.0 ?
>
> If your description is correct, then all you need to do is to ensure
> that you route interrupts to other CPUs.
>
> You can do that by running the userspace irqbalance daemon.
>

I also tried with the irqbalance daemon, on ARM quad core architecture,
and as per my understanding, the daemon sets the
/proc/irq/<irq.no.>/smp_affinity
file according to the irq frequency on a particular processor.

          However, the daemon doesn't work as expected, I also tried
accessing the
proc file mentioned above to set the cpu mask for particular irq, but this
just block the processing of the irq, as I see the count of that irq
doesnt increase
in /proc/interrupts.

            My conclusion is that the irqbalancing is not supported on
ARM arch or there is
something  more required for this to work. Kindly provide some
pointers over this.

Regards,
Vaibhav
