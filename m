Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754435Ab2LFBOJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 20:14:09 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:36032 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754400Ab2LFBOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 20:14:07 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlMMAJfwv1B5LLKS/2dsb2JhbABEuCaGABdzgh4BAQU6HBIGCxAIAxguFCUDIROID8JnFIwjg2BhA5YCkEiDBg
Date: Thu, 6 Dec 2012 12:14:02 +1100
From: Dave Chinner <david@fromorbit.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Martin Steigerwald <Martin@lichtvoll.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH, 3.7-rc7, RESEND] fs: revert commit bbdd6808 to fallocate
 UAPI
Message-ID: <20121206011402.GB27172@dastard>
References: <1353366267-15629-1-git-send-email-david@fromorbit.com>
 <201212051148.28039.Martin@lichtvoll.de>
 <CA+55aFzgP29WfB1yvnj+Q9-TsbX+b-TCCjTS_vPJ16DxMy6aDQ@mail.gmail.com>
 <201212051718.44017.Martin@lichtvoll.de>
 <CA+55aFxsPBo4TZEPq+14NBE8Snmd9qiTjAiEP0fFXBzaJ9y+gw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxsPBo4TZEPq+14NBE8Snmd9qiTjAiEP0fFXBzaJ9y+gw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 05, 2012 at 10:25:17AM -0800, Linus Torvalds wrote:
> Yes, people can argue that "process" is about technical issues too,
> but let's be honest: our process is fluid. Not everything gets
> reviewed on the mailing list, and people *do* talk about things
> face-to-face at conferences.

Yes, that is true.

But we don't review code at conferences. We have mailing lists for
that.  I've lost count of the number of times I've heard "post your
code" or "let's take it to the list" or "better to discuss this on
the list where everyone can comment" at conferences such as
Plumbers. It's a standard practise - talk at conferences, review
on mailing lists.

And for changes to syscalls? That's something that must be peer
reviewed because we are going to be stuck with those changes forever
as we can't undo them at a later date. It doesn't matter who made the
change in question, I would have done exactly the same thing....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
