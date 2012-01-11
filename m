Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757503Ab2AKPOS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 10:14:18 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:49313 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757105Ab2AKPOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 10:14:15 -0500
X-Sasl-enc: U2IZdrgd/gHA6Cu8TBseWsDC1X5CNwKzE/FebsudgqgB 1326294854
Date: Wed, 11 Jan 2012 07:12:18 -0800
From: Greg KH <greg@kroah.com>
To: tim.gardner@canonical.com
Cc: stable@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>
Subject: Re: Latest kernel stable/longterm status
Message-ID: <20120111151218.GB24077@kroah.com>
References: <20120110003705.GA9482@kroah.com>
 <20120110022617.GA11376@home.goodmis.org>
 <4F0C0CF5.1080706@gmail.com>
 <20120110235612.GB1507@kroah.com>
 <4F0D6006.40506@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F0D6006.40506@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 11, 2012 at 11:10:14AM +0100, Tim Gardner wrote:
> On 01/11/2012 12:56 AM, Greg KH wrote:
> >On Tue, Jan 10, 2012 at 11:03:33AM +0100, Tim Gardner wrote:
> >>On 01/10/2012 03:26 AM, Steven Rostedt wrote:
> >>>On Mon, Jan 09, 2012 at 04:37:05PM -0800, Greg KH wrote:
> >>>>As 3.2 is now out, here's a note as to the current status of the
> >>>>different stable/longterm kernel trees.
> >>>
> >>>Thanks for all your hard work Greg!
> >>>
> >>
> >>I'd also like to thank Greg.
> >>
> >>Ubuntu will continue to support 2.6.32.y until April 2015. Ubuntu
> >>has also chosen 3.2 as a long term supported kernel for the 12.04
> >>release and will pick up support for it when 3.3 is released.
> >
> >What exactly do you mean by this?
> >
> >greg k-h
> 
> If you're agreeable, I would very much prefer to continue with the
> stable update model that you've developed by committing to the
> linux-2.6.32.y and linux-3.2.y branches in git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git.
> The mailing list review process as well as the policies regarding
> patch suitability are working well.

As I previously stated, in this email, I already have someone lined up
to maintain 2.6.32 after I am done with it, but I'm sure that person
would love it if you would send any needed patches to
stable@vger.kernel.org to help them out.

greg k-h
