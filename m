Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550Ab1F1WKE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 18:10:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46780 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752652Ab1F1WJ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 18:09:57 -0400
Date: Wed, 29 Jun 2011 00:09:55 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/29] gma500: Ensure the frame buffer has a linear
 virtual mapping
In-Reply-To: <20110628230245.4cec6958@lxorguk.ukuu.org.uk>
Message-ID: <alpine.LNX.2.00.1106290003060.11049@pobox.suse.cz>
References: <20110616160104.6039.44019.stgit@localhost.localdomain> <20110616160642.6039.31781.stgit@localhost.localdomain> <20110628211859.GA23217@kroah.com> <20110628230245.4cec6958@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Jun 2011, Alan Cox wrote:

> > Is there drm changes in linux-next for this driver that I don't have?
> > 
> > If so, maybe we need to just start sending these patches through that tree?
> 
> Not DRM - looks like more sem-random treewide damage in -next tht has yet
> again not gone via the maintainers of subsystems.
> 
> e44ba033c5654dbfda53461c9b1f7dd9bd1d198f
> 
> 28f65c11f2ffb3957259dece647a24f8ad2e241b
> 
> Can you drop the bits you have merged and I'll send you a new set (which
> will instead break the stuff Jiri has in his tree and he can fix it up)
> 
> Really though this sort of treewide trivial has to stop, its costing tons
> of time and delays in real work. It should all be going via maintainers
> of subsystems but clearly Jiri is letting stuff through that isn't
> trivial but is in fact nuisance.

So, what I am normally doing:

- I usually wait several weeks (!) before I pick up patches to trivial 
  tree that have been also sent to maintainers. Exactly to avoid this kind 
  of situation.
  With treewide patches, the situation is of course a little bit 
  different in principle.
- I reject to apply any drivers/staging bits on a regular basis. I 
  consider drivers/staging a moving target, and I usually re-route 
  anything  touching drivers/staging to Greg immediately. Admittedly, I 
  have failed to do so in this case, sorry about that.
- I consider the trivial tree to be really the 'tail' of the whole 
  development process, so whenever there is any merge conflict in 
  linux-next caused by anything in trivial tree, I always take the 
  responsibility to resolve the conflict so that subsystem maintainers are 
  not bothered

I will drop the staging bits, sorry again for missing those in the bulk.

I am still wondering how come that this is causing trouble to anyone 
though -- is anyone really developing real code on top of linux-next 
(which should be there to cross-check merge problems between subsystems 
and test functionality) instead of particular subsystem tree?

Thanks,

-- 
Jiri Kosina
SUSE Labs
