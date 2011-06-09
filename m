Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756996Ab1FIKku (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 06:40:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57042 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754894Ab1FIKkt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 06:40:49 -0400
Subject: Re: [PATCH] uv/x2apic: update for change in pci bridge handling.
From: Dave Airlie <airlied@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Dave Airlie <airlied@gmail.com>, jbarnes@virtuousgeek.org,
        linux-kernel@vger.kernel.org, steiner@sgi.com
Date: Thu, 09 Jun 2011 20:32:49 +1000
In-Reply-To: <20110609070912.GB20544@elte.hu>
References: <1306296049-11797-1-git-send-email-airlied@gmail.com>
	 <BANLkTi=8JQWojj4UrH1iBYN=tWdx5AuOCA@mail.gmail.com>
	 <20110609070912.GB20544@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Message-ID: <1307615573.5963.0.camel@t60prh>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-09 at 09:09 +0200, Ingo Molnar wrote:
> * Dave Airlie <airlied@gmail.com> wrote:
> 
> > On Wed, May 25, 2011 at 2:00 PM, Dave Airlie <airlied@gmail.com> wrote:
> > > From: Dave Airlie <airlied@redhat.com>
> > >
> > > I forgot about the special uv handling code for this, so this
> > > patch fixes it up.
> > 
> > ping?
> > 
> > This fixes a warning and bug in Linus tree,
> > 
> >   CC      arch/x86/kernel/apic/x2apic_uv_x.o
> > /home/airlied/git/linux-2.6/arch/x86/kernel/apic/x2apic_uv_x.c: In
> > function ‘uv_system_init’:
> > /home/airlied/git/linux-2.6/arch/x86/kernel/apic/x2apic_uv_x.c:882:2:
> > warning: passing argument 1 of ‘pci_register_set_vga_state’ from
> > incompatible pointer type [enabled by default]
> > /home/airlied/git/linux-2.6/include/linux/pci.h:1094:13: note:
> > expected ‘arch_set_vga_state_t’ but argument is of type ‘int
> > (*)(struct pci_dev *, bool,  unsigned int,  bool)’
> > 
> > 
> > Dave.
> > 
> > >
> > > Signed-off-by: Dave Airlie <airlied@redhat.com>
> > > ---
> > >  arch/x86/kernel/apic/x2apic_uv_x.c |    8 ++++----
> > >  drivers/pci/pci.c                  |    4 ++--
> > >  2 files changed, 6 insertions(+), 6 deletions(-)
> 
> Bug introduced via the DRM tree? Then the fix should go via the DRM 
> tree or via the PCI tree i suspect.

So I can take that as an ack for the x86 bit? :-)

I don't mind pushing it, just didn't want to step outside my box

Dave.


