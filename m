Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932096Ab2LSPEb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 10:04:31 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:61438 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996Ab2LSPEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 10:04:22 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] of: Fix export of of_find_matching_node_and_match()
To: Rob Herring <robherring2@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Stephen Warren <swarren@nvidia.com>,
        Rob Herring <rob.herring@calxeda.com>
In-Reply-To: <50D1C608.9040001@gmail.com>
References: <1355914716-19469-1-git-send-email-grant.likely@secretlab.ca> <CACxGe6vTxQGr+t5O4q0J265K02-EEeEiGoOTvB1o-ee2bBrhZg@mail.gmail.com> <50D1C608.9040001@gmail.com>
Date: Wed, 19 Dec 2012 15:04:18 +0000
Message-Id: <20121219150418.6EEE03E0AD7@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Dec 2012 07:50:00 -0600, Rob Herring <robherring2@gmail.com> wrote:
> On 12/19/2012 05:02 AM, Grant Likely wrote:
> > On Wed, Dec 19, 2012 at 10:58 AM, Grant Likely
> > <grant.likely@secretlab.ca> wrote:
> >> Commit 50c8af4cf9, "of: introduce for_each_matching_node_and_match()"
> >> renamed of_find_matching_node() to of_find_matching_node_and_match() and
> >> created a new static inline of_find_matching_node() wrapper around the
> >> new name. However, the change neglected to change the EXPORT_SYMBOL()
> >> reference causing build errors for modules.
> >>
> >> This patch fixes the EXPORT_SYMBOL() statement. Discovered on a PowerPC
> >> Efika build with the mpc52xx_uart driver being built as a module.
> >>
> >> Reported-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> >> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> >> Cc: Stephen Warren <swarren@nvidia.com>
> >> Cc: Rob Herring <rob.herring@calxeda.com>
> >> Cc: Anatolij Gustschin <agust@denx.de>
> > 
> > Rob, I've just pushed this out to my devicetree/merge branch. If
> > you've got any fixes queued up for Linus, then please pull this in
> > before sending them on to him. Otherwise I'll send Linus a pull req
> > for this fix this evening. Ether way, please reply to let me know what
> > you're going to do.
> > 
> 
> The only item on my todo is this one:
> 
> "of: define struct device in of_platform.h if !OF_DEVICE and !OF_ADDRESS"
> 
> But I'm not going to get to it today if you want to pick it up.

I don't see that one anywhere. Where did it come from?

g.

