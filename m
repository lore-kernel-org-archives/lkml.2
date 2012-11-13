Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615Ab2KMBx1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 20:53:27 -0500
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:9148 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752751Ab2KMBxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 20:53:21 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiYVAIOkoVB5LErT/2dsb2JhbABEvWWEdgOBBYEJgh4BAQU6HCMQCAMOCi4UJQMhE4gJqW+QMBSMAWwxhExhA5V7iUmGe4MDgVAX
Date: Tue, 13 Nov 2012 12:53:18 +1100
From: Dave Chinner <david@fromorbit.com>
To: Thiago Farina <tfransosi@gmail.com>
Cc: linux list <linux-kernel@vger.kernel.org>, Ben Myers <bpm@sgi.com>,
        Alex Elder <elder@kernel.org>, xfs@oss.sgi.com
Subject: Re: xfs: Remove boolean_t typedef completely.
Message-ID: <20121113015318.GD25039@dastard>
References: <CACnwZYd2kPaK1urLYc8BBuuqD7_Oo1oF+KvqWYj7DAEGy6grHQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACnwZYd2kPaK1urLYc8BBuuqD7_Oo1oF+KvqWYj7DAEGy6grHQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 12, 2012 at 10:36:47PM -0200, Thiago Farina wrote:
> On Mon, Nov 12, 2012 at 10:24 PM, Dave Chinner <david@fromorbit.com> wrote:
> > On Mon, Nov 12, 2012 at 09:36:17PM -0200, Thiago Farina wrote:
> >> Hi,
> >>
> >> Please, take a look.
> >>
> >> Patch attached.
> >
> > It's a good start for a cleanup, but there's no point in removing
> > the boolean_t from one file and then not removing it from the rest
> > of the XFS code.  It's only used in a handful of places, so just
> > remove it completely.
> >
> Done.
> 
> Please, take another look.
> 
> > Also, can you please place patches in line rather than attaching
> > them. Attaching them means they cannot be quoted in reply. See
> > Documentation/SubmittingPatches and Documentation/email-clients.txt
> > for guidelines.
> >
> Sorry, patch attached.

It's still attached as a base64 encoded attachment, not as inline
text....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
