Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756899Ab1FIHJ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 03:09:28 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60236 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753956Ab1FIHJY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 03:09:24 -0400
Date: Thu, 9 Jun 2011 09:09:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dave Airlie <airlied@gmail.com>
Cc: jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org,
        Dave Airlie <airlied@redhat.com>, steiner@sgi.com
Subject: Re: [PATCH] uv/x2apic: update for change in pci bridge handling.
Message-ID: <20110609070912.GB20544@elte.hu>
References: <1306296049-11797-1-git-send-email-airlied@gmail.com>
 <BANLkTi=8JQWojj4UrH1iBYN=tWdx5AuOCA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTi=8JQWojj4UrH1iBYN=tWdx5AuOCA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dave Airlie <airlied@gmail.com> wrote:

> On Wed, May 25, 2011 at 2:00 PM, Dave Airlie <airlied@gmail.com> wrote:
> > From: Dave Airlie <airlied@redhat.com>
> >
> > I forgot about the special uv handling code for this, so this
> > patch fixes it up.
> 
> ping?
> 
> This fixes a warning and bug in Linus tree,
> 
>   CC      arch/x86/kernel/apic/x2apic_uv_x.o
> /home/airlied/git/linux-2.6/arch/x86/kernel/apic/x2apic_uv_x.c: In
> function ‘uv_system_init’:
> /home/airlied/git/linux-2.6/arch/x86/kernel/apic/x2apic_uv_x.c:882:2:
> warning: passing argument 1 of ‘pci_register_set_vga_state’ from
> incompatible pointer type [enabled by default]
> /home/airlied/git/linux-2.6/include/linux/pci.h:1094:13: note:
> expected ‘arch_set_vga_state_t’ but argument is of type ‘int
> (*)(struct pci_dev *, bool,  unsigned int,  bool)’
> 
> 
> Dave.
> 
> >
> > Signed-off-by: Dave Airlie <airlied@redhat.com>
> > ---
> >  arch/x86/kernel/apic/x2apic_uv_x.c |    8 ++++----
> >  drivers/pci/pci.c                  |    4 ++--
> >  2 files changed, 6 insertions(+), 6 deletions(-)

Bug introduced via the DRM tree? Then the fix should go via the DRM 
tree or via the PCI tree i suspect.

Thanks,

	Ingo
