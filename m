Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243Ab0GIRdM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 13:33:12 -0400
Received: from router-fw.net-space.pl ([89.174.63.77]:58837 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753568Ab0GIRdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 13:33:11 -0400
Date: Fri, 9 Jul 2010 19:32:56 +0200
From: Daniel Kiper <dkiper@net-space.pl>
To: Andi Kleen <andi@firstfloor.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Daniel Kiper <dkiper@net-space.pl>,
       xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] Re: GSoC 2010 - Migration from memory ballooning to	memory hotplug in Xen
Message-ID: <20100709173256.GC8696@router-fw-old.local.net-space.pl>
References: <20100708194553.GA30124@router-fw-old.local.net-space.pl> <871vbdr4ey.fsf@basil.nowhere.org> <4C36648F.6020006@goop.org> <20100709003409.GC15950@basil.fritz.box>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100709003409.GC15950@basil.fritz.box>
User-Agent: Mutt/1.3.28i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 09, 2010 at 02:34:09AM +0200, Andi Kleen wrote:
> > > The only advantage of using memory hotadd is that the mem_map doesn't
> > > need to be pre-allocated, but that's only a few percent of the memory.
> > >
> > > So it would only help if you want to add gigantic amounts of memory
> > > to a VM (like >20-30x of what it already has).
> >
> > That's not wildly unreasonable on the face of it; consider a domain
> > which starts at 1GB but could go up to 32GB as demand requires.  But
>
> The programs which need 32GB will probably not even start in 1GB :)

I am able to run program which allocates 32GB on machine 1GB... :-)))
Do not underestimate memory overcommit...

Daniel
