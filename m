Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965063Ab0HFSmB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 14:42:01 -0400
Received: from kroah.org ([198.145.64.141]:42878 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964905Ab0HFSlx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 14:41:53 -0400
Date: Fri, 6 Aug 2010 11:41:49 -0700
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: Re: [GIT PATCH] STAGING merge for .36
Message-ID: <20100806184149.GA23308@kroah.com>
References: <20100805213308.GA13744@kroah.com>
 <AANLkTikzUaTAAu1GqBGqNtvmpfG3z5_HjOCQoVEh9NO9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikzUaTAAu1GqBGqNtvmpfG3z5_HjOCQoVEh9NO9@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 06, 2010 at 11:27:02AM -0700, Linus Torvalds wrote:
> On Thu, Aug 5, 2010 at 2:33 PM, Greg KH <greg@kroah.com> wrote:
> > Here's the big staging tree merge for the .36 kernel.
> >
> >  812 files changed, 106306 insertions(+), 33784 deletions(-)
> 
> Hmm. How did you generate that diff? It's not what I get. I get
> 
>  812 files changed, 107586 insertions(+), 35064 deletions(-)
> 
> which is sufficiently different that it makes me worry about what's going on.

Very odd.

I did:
	git diff -M --stat --summary origin..HEAD

That's what I've been doing for a while now, and it has been working for
the other trees.

This one was a bit different in that I did have to pull from a different
tree for one of the drivers, but that merged together nicely from what
the end result looked like.

Should I do something else for my pull summaries?

> I pulled it, because the shortlog matched, and it was all in staging
> (except for that one x86 mshyperv line), but I just wonder..

That's good, but I wonder as well.

thanks,

greg k-h
