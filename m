Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537Ab2LFMFj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 07:05:39 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:55070
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750826Ab2LFMFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 07:05:37 -0500
Date: Thu, 6 Dec 2012 07:05:33 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Martin Steigerwald <Martin@lichtvoll.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>, "Theodore Ts'o" <tytso@mit.edu>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH, 3.7-rc7, RESEND] fs: revert commit bbdd6808 to fallocate
 UAPI
Message-ID: <20121206120532.GA14100@infradead.org>
References: <1353366267-15629-1-git-send-email-david@fromorbit.com>
 <20121126025520.GC22858@thunk.org>
 <20121126091202.GO32450@dastard>
 <201212051148.28039.Martin@lichtvoll.de>
 <CA+55aFzgP29WfB1yvnj+Q9-TsbX+b-TCCjTS_vPJ16DxMy6aDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzgP29WfB1yvnj+Q9-TsbX+b-TCCjTS_vPJ16DxMy6aDQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 05, 2012 at 07:45:39AM -0800, Linus Torvalds wrote:
> On Wed, Dec 5, 2012 at 2:48 AM, Martin Steigerwald <Martin@lichtvoll.de> wrote:
> >
> > Linus, while I am interested in an answer I think that Dave and Christoph
> > as Linux filesystem developers actually deserve one (instead of silently
> > being ignored which is also a decision in this matter).
> >
> > I did not see an answer in linux-2.6 commit log as of today so far.
> 
> Christ guys. This whole thread is retarded.
> 
> The *ONLY* reason people seem to have for reverting that is a "ooh, my
> feelings are hurt by how this was done, and now I'm a pissy bitch and
> I want to get this reverted".
> 
> Stop the f*cking around already.
> 
> If you want something reverted, you show me the *technical* reason for
> it. Not the "ooh, I'm so annoyed by how this was done" reason for it.
> 
> And if your little feelings got hurt, get your mommy to tuck you in,
> don't email me about it. Because I'm not exactly known for my deep
> emotional understanding and supportive personality, am I?

No, the problem is that the thing is not just a) wrong, but b) only made
it in through sneaky ways.

