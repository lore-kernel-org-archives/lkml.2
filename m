Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575Ab2HSTBJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 15:01:09 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50204 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627Ab2HSTBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 15:01:05 -0400
Date: Sun, 19 Aug 2012 16:00:56 -0300
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jani Nikula <jani.nikula@intel.com>,
        Yang Guang <guang.a.yang@intel.com>
Subject: Re: [ 32/37] drm/i915: correctly order the ring init sequence
Message-ID: <20120819190056.GA3545@herton-Z68MA-D2H-B3>
References: <20120817030243.807605523@decadent.org.uk>
 <20120817030248.892667316@decadent.org.uk>
 <20120817232956.GG4039@herton-Z68MA-D2H-B3>
 <CAKMK7uGYgJvWs-BYoPUwNjcmM8xFYJZhpBpyetYzoj_4br5XwA@mail.gmail.com>
 <1345388084.22400.3.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345388084.22400.3.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 19, 2012 at 03:54:44PM +0100, Ben Hutchings wrote:
> On Sat, 2012-08-18 at 12:04 +0200, Daniel Vetter wrote:
> > On Sat, Aug 18, 2012 at 1:29 AM, Herton Ronaldo Krzesinski
[...]
> > Good catch, I've forgotten to check whether all the recent ring_init
> > patches have gone  through cc: stable. For the stable team, please
> > pick up both patches:
> > 
> > f01db988ef6f6c70a6cc36ee71e4a98a68901229 and
> > 0d8957c8a90bbb5d34fab9a304459448a5131e06
> > 
> > Note that all kernels that need f01db backported also need
> > b7884eb45ec98c0d34c7f49005ae9d4b4b4e38f6 (to fix a regression
> > introduce by the former).
> 
> 3.2.y already had the second and third of these, but not f01db98
> 'drm/i915: Add wait_for in init_ring_common'.  So I've added that.
> 
> I don't have commit 18ef6f6c70a6cc36ee71e4a98a68901229 here, but I
> assume it's a cherry-picked version as it has the same subject line.

Ops sorry, yes, it's the same commit, just the hash was the version I
had picked in my local branch, I did git show in the wrong tree.

> 
> Ben.
> 
> > Yeah, the ring init sequence is a fickle beast :( but I'm pretty sure
> > with these three patches, stable kernels should be up to date and have
> > all the latest fixes.
> > 
> > Yours, Daniel
> 
> -- 
> Ben Hutchings
> I say we take off; nuke the site from orbit.  It's the only way to be sure.

-- 
[]'s
Herton
