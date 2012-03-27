Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751258Ab2C1EnY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 00:43:24 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62090 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804Ab2C1EnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 00:43:23 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] of/irq: add empty irq_of_parse_and_map() for non-dt builds
To: Thomas Abraham <thomas.abraham@linaro.org>
Cc: Rob Herring <robherring2@gmail.com>, devicetree-discuss@lists.ozlabs.org,
        patches@linaro.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <CAJuYYwTjqdSAXBr6c+da85dSxRM5_-L=54RkBo1eJt9Jn=sCXw@mail.gmail.com>
References: <1332581257-15989-1-git-send-email-thomas.abraham@linaro.org> <4F6DC847.8000902@gmail.com> <20120325004232.AD9793E0409@localhost> <CAJuYYwTjqdSAXBr6c+da85dSxRM5_-L=54RkBo1eJt9Jn=sCXw@mail.gmail.com>
Date: Tue, 27 Mar 2012 16:28:27 -0600
Message-Id: <20120327222827.576EE3E1551@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Mar 2012 20:26:15 +0530, Thomas Abraham <thomas.abraham@linaro.org> wrote:
> On 25 March 2012 06:12, Grant Likely <grant.likely@secretlab.ca> wrote:
> > On Sat, 24 Mar 2012 08:12:39 -0500, Rob Herring <robherring2@gmail.com> wrote:
> >> On 03/24/2012 04:27 AM, Thomas Abraham wrote:
> >> > Add a empty irq_of_parse_and_map() that returns 0 for non-dt builds and
> >> > avoid having #ifdef CONFIG_OF around all calls to irq_of_parse_and_map().
> >> >
> >> > Suggested-by: Grant Likely <grant.likely@secretlab.ca>
> >> > Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
> >> > ---
> >>
> >> Acked-by: Rob Herring <rob.herring@calxeda.com>
> >>
> >> Go ahead and merge with the rest of your series.
> >
> > Actually, it's not quite fully baked; the forward declaration of
> > irq_of_parse_and_map() needs to be moved under the #if
> > defined(CONFIG_OF_IRQ) block (just move the #if statement up 7 lines).
> > After doing that you can add my acked-by and merge it with the rest of
> > your series.  There is no sense merging it through my tree when you
> > are the only user depending on it.
> >
> > Acked-by: Grant Likely <grant.likely@secretlab.ca>
> 
> Thanks. I will do that change which you have suggested and take it
> through the Samsung tree. But I was thinking that if it goes through
> your tree, there would be less chances of a merge conflict in
> include/linux/of_irq.h, a file that might see updates from other
> sources.

Hmmm... is this going to be merged for v3.4 or v3.5?  If it is v3.5,
then yes it probably does need to go through my tree since there may
be others that need to pull it into their trees.  I was thinking that
you needed this immediately.

g.

