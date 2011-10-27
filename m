Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258Ab1J0XC4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 19:02:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50449 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902Ab1J0XCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 19:02:55 -0400
X-Greylist: delayed 563 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Oct 2011 19:02:55 EDT
Date: Thu, 27 Oct 2011 15:53:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, hpa@zytor.com,
        jeremy.fitzhardinge@citrix.com, mingo@redhat.com, stable@kernel.org,
        tglx@linutronix.de
Subject: Re: Not really merged? Re: [merged]
 x86-paravirt-pte-updates-in-kunmap_atomic-need-to-be-synchronous-regardless-of-lazy_mmu-mode.patch
 removed from -mm tree
Message-Id: <20111027155329.0adc1358.akpm@linux-foundation.org>
In-Reply-To: <20111025182450.GA9843@phenom.dumpdata.com>
References: <201110141951.p9EJpn3A006989@hpaq5.eem.corp.google.com>
	<20111025182450.GA9843@phenom.dumpdata.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Oct 2011 14:24:50 -0400
Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:

> On Fri, Oct 14, 2011 at 12:51:48PM -0700, akpm@google.com wrote:
> > 
> > The patch titled
> >      Subject: x86/paravirt: PTE updates in k(un)map_atomic need to be synchronous, regardless of lazy_mmu mode
> > has been removed from the -mm tree.  Its filename was
> >      x86-paravirt-pte-updates-in-kunmap_atomic-need-to-be-synchronous-regardless-of-lazy_mmu-mode.patch
> > 
> > This patch was dropped because it was merged into mainline or a subsystem tree
> 
> Hey Andrew,
> 
> I am actually not seeing this in mainline? Was it accidently dropped out of your tree?

hm, well spotted.  I'm not sure what happened here - possibly the patch
was merged into an x86 tree (and hence linux-next) but later got lost. 
Or possibly not, and I just screwed up.

Either way, it's a pretty important patch - we marked it for -stable
backporting.

> If that is the case I can convience you to put it back in or can I drive it to Linus with
> your Ack-ed by?

I resurrected my copy and shall send it along to the x86 guys soon.

