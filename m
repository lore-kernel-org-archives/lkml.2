Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751482Ab0IEGWk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 02:22:40 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63339 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013Ab0IEGWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 02:22:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=QPiz1sydf1zVXkNJKmMsPnKHI5P7AEHaKvadw5SAF2ONV34orRgMsO2ldGN904AE68
         gjbwMnkSW5HXwu3RkQGEKevA0EwNRcQmTYXpJNQlt5JfcGQHH3KsmR3H3x/mNrY3AxOa
         +IeAxHjhghQ/OzBJxuM00A9jn4rIYaSLc+yAk=
Date: Sun, 5 Sep 2010 08:22:40 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Christian Riesch <christian.riesch@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Subject: Re: [PATCH 0/2] [RFC] posix clock tuning
Message-ID: <20100905062240.GB2699@riccoc20.at.omicron.at>
References: <cover.1283504065.git.richard.cochran@omicron.at>
 <alpine.DEB.2.00.1009041221240.888@router.home>
 <4C828652.4060804@gmail.com>
 <alpine.DEB.2.00.1009042042130.9425@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1009042042130.9425@router.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 04, 2010 at 08:47:39PM -0500, Christoph Lameter wrote:
> On Sat, 4 Sep 2010, Christian Riesch wrote:
> 
> > Richard's idea is to support clock hardware for IEEE 1588 (PTP, Precision Time
> > Protocol). Have a look at the earlier discussions:
> >
> > http://lkml.org/lkml/2010/8/16/90
> 
> A superficial scan does not give me any definite agreement on an approach.

Welcome to the club. I am also not too sure how to bring everything
that was said together.

I have attempted to synthesize the various ideas from the previous
threads into a concrete form (a new patch set) in order to see:

1. If I understood what the commentators were asking for.
2. Whether people now agree on the approach.

> Ok this goes more into something that may prove useful but it would be
> very helpful still to have a clear discussion as to why this is all
> needed. From what I can tell the functionality is already there and
> another clock device (CLOCK_SGI_CYCLE) is already providing a model for
> how a PTP clock could be controlled and used.

John Stultz warned against that approach in his mail from August 18.

    http://lkml.org/lkml/2010/8/18/264

At this point, I think it is clear that, in order to support IEEE
1588, some kind of changes are needed. I have argued and discussed the
issues at some length. I am willing to continue the discussion, but I
would also appreciate more than a "superficial scan." PTP is quite a
large topic that probably cannot be adequately treated in a single
email.

Having said that, if you are convinced that the existing interfaces
are good enough to support PTP (and possible future methods, as
discussed in the threads), then I am all ears to find out how to do
make it work.

Thanks,
Richard

