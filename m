Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252Ab2JCU60 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 16:58:26 -0400
Received: from smtp.outflux.net ([198.145.64.163]:41107 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754450Ab2JCU6W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 16:58:22 -0400
Date: Wed, 3 Oct 2012 13:58:18 -0700
From: Kees Cook <kees@outflux.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Nick Bowler <nbowler@elliptictech.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.6
Message-ID: <20121003205818.GB9092@outflux.net>
References: <CA+55aFw1Y5_HtfXh+-OEQ2KGpW0N18kA4O3R7=cv29_CaF+3UQ@mail.gmail.com>
 <20121003194614.GA2893@elliptictech.com>
 <20121003200515.GZ9092@outflux.net>
 <CA+55aFwgF1O_DzF0bqGO06n2kxNGE=f5BQsvZF_+q9o0pFPeGw@mail.gmail.com>
 <20121003204141.GB6026@thunk.org>
 <20121003204919.GA9092@outflux.net>
 <CA+55aFwXLXfAHHBEYYiz_4qjxWUpENECCZwFN_1gq+e48f+3Sw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwXLXfAHHBEYYiz_4qjxWUpENECCZwFN_1gq+e48f+3Sw@mail.gmail.com>
Organization: Outflux
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2012 at 01:54:21PM -0700, Linus Torvalds wrote:
> On Wed, Oct 3, 2012 at 1:49 PM, Kees Cook <kees@outflux.net> wrote:
> >
> > I think the benefits of this being on by default outweigh glitches
> > like this. Based on Nick's email, it looks like a directory tree of his
> > own creation.
> 
> I agree that *one* report like this doesn't necessarily mean that we
> need to turn it off, if Nick is happy to just fix up his script and
> it's all local.
> 
> However, I suspect we'll see more. And once that happens, we're not
> going to keep a default that breaks peoples old scripts, and we're
> going to have to rely on distributions (or users) explicitly setting
> it.
> 
> Compatibility is just too important.

If this happens, I _really_ want to bring back the CONFIG options I had in
an earlier version of this patch. I want to be able to declare the default
at build time, and not leave a system vulnerable from boot until sysctls
get set.

-Kees

-- 
Kees Cook                                            @outflux.net
