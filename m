Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932933Ab0HDOxZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 10:53:25 -0400
Received: from cantor.suse.de ([195.135.220.2]:54269 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932320Ab0HDOxY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 10:53:24 -0400
Date: Wed, 4 Aug 2010 07:50:25 -0700
From: Greg KH <gregkh@suse.de>
To: Michael Neuling <mikey@neuling.org>
Cc: michael@ellerman.id.au, linux-kernel@vger.kernel.org
Subject: Re: git tree for testing stable kernels RCs
Message-ID: <20100804145025.GA21125@suse.de>
References: <1527.1280883904@neuling.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1527.1280883904@neuling.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 04, 2010 at 11:05:04AM +1000, Michael Neuling wrote:
> Greg,
> 
> Do you have a git tree with RC candidates for the stable kernels?  I'm
> interested in full trees, not just the patch series like you have in
> your stable-queue.git tree.  I'm happy if this tree is re-based before
> the final stable release.

Nope, I don't, the workflow for the stable trees does not lend itself to
a git tree that doesn't constantly change, sorry.

> The reason I ask is that Michael Ellerman has added the stable kernels
> to his list of trees he tests with his kisskb infrastructure.  You can
> see the results here:
> 
> stable-2.6.27: http://kisskb.ellerman.id.au/kisskb/branch/19/
> stable-2.6.32: http://kisskb.ellerman.id.au/kisskb/branch/17/
> stable-2.6.34: http://kisskb.ellerman.id.au/kisskb/branch/15/
> stable-2.6.35: http://kisskb.ellerman.id.au/kisskb/branch/16/
> 
> These results have already helped us find bugs but it would be even
> better if we could fix the problems before the final release.

Just simple build bugs, right?  Not that it's not nice to catch them
though.

> If you don't have this available we're likely to build one but before
> we do, I thought I'd ask if you had this pre-built somewhere anyway.

Nope, have fun building it :)

thanks,

greg k-h
