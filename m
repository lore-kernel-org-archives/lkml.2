Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759514Ab0HEBmZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 21:42:25 -0400
Received: from ozlabs.org ([203.10.76.45]:45630 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759277Ab0HEBmX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 21:42:23 -0400
From: Michael Neuling <mikey@neuling.org>
To: Greg KH <gregkh@suse.de>
cc: michael@ellerman.id.au, linux-kernel@vger.kernel.org
Subject: Re: git tree for testing stable kernels RCs
In-reply-to: <20100804145025.GA21125@suse.de>
References: <1527.1280883904@neuling.org> <20100804145025.GA21125@suse.de>
Comments: In-reply-to Greg KH <gregkh@suse.de>
   message dated "Wed, 04 Aug 2010 07:50:25 -0700."
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.1.1
Date: Thu, 05 Aug 2010 11:42:21 +1000
Message-ID: <7065.1280972541@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <20100804145025.GA21125@suse.de> you wrote:
> On Wed, Aug 04, 2010 at 11:05:04AM +1000, Michael Neuling wrote:
> > Greg,
> > 
> > Do you have a git tree with RC candidates for the stable kernels?  I'm
> > interested in full trees, not just the patch series like you have in
> > your stable-queue.git tree.  I'm happy if this tree is re-based before
> > the final stable release.
> 
> Nope, I don't, the workflow for the stable trees does not lend itself to
> a git tree that doesn't constantly change, sorry.

No problem, I thought I'd ask anyway.

> > The reason I ask is that Michael Ellerman has added the stable kernels
> > to his list of trees he tests with his kisskb infrastructure.  You can
> > see the results here:
> > 
> > stable-2.6.27: http://kisskb.ellerman.id.au/kisskb/branch/19/
> > stable-2.6.32: http://kisskb.ellerman.id.au/kisskb/branch/17/
> > stable-2.6.34: http://kisskb.ellerman.id.au/kisskb/branch/15/
> > stable-2.6.35: http://kisskb.ellerman.id.au/kisskb/branch/16/
> > 
> > These results have already helped us find bugs but it would be even
> > better if we could fix the problems before the final release.
> 
> Just simple build bugs, right?  Not that it's not nice to catch them
> though.

Yes, just build bugs.  They seem to happen from time to time with
stable.

> > If you don't have this available we're likely to build one but before
> > we do, I thought I'd ask if you had this pre-built somewhere anyway.
> 
> Nope, have fun building it :)

Fun git party time, woot!! :-)

Mikey
