Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175Ab1EVUVh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 16:21:37 -0400
Received: from gir.skynet.ie ([193.1.99.77]:41115 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754815Ab1EVUVT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 16:21:19 -0400
Date: Sun, 22 May 2011 21:20:42 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: Andi Kleen <andi@firstfloor.org>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 01/12] Force always inline for gcc 4.5 when optimizing
 for size
In-Reply-To: <f21331d6ac687d28aa7f9b7f0f5b7620.squirrel@www.firstfloor.org>
Message-ID: <alpine.DEB.2.00.1105222115270.8205@skynet.skynet.ie>
References: <1305936082-21304-1-git-send-email-andi@firstfloor.org>    <alpine.DEB.2.00.1105220816480.12897@skynet.skynet.ie> <f21331d6ac687d28aa7f9b7f0f5b7620.squirrel@www.firstfloor.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > Oh these look like a good plan, one of our contributors has an inline
> > fetish and it got cut-n-pasted into a few places particular in radeon.
> >
> > But we won't be turning DRM debugging off, its what we use to debug things
> > in the field, I did get a patch recently to reduce some of its overhead
> 
> Why can't it be a CONFIG option like all other debugging code?

Not sure which part of debug things in the field doesn't explain it, 
having people remove the debugging code would sort of work against fixing 
problems. Having a config option might be possible, but then I'd have to 
deal with people who think they know what they are doing turning it off, 
so I'd rather not. Next think you know some distro turns it off and you 
have users who you can't help anymore.

> If you want to keep it on would need to drop even more inlines to get
> the 50k overhead down.

Dave.
