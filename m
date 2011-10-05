Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934719Ab1JETfR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 15:35:17 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:40206 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933233Ab1JETfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 15:35:15 -0400
X-Sasl-enc: cPs6K1FXY+uqg+urx3dtrSe8bGavJLb5ObSDjUBH0ba3 1317843314
Date: Wed, 5 Oct 2011 12:29:35 -0700
From: Greg KH <greg@kroah.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] drivercore: Add helper macro for platform_driver
 boilerplate
Message-ID: <20111005192935.GA26664@kroah.com>
References: <20111004232403.10364.22050.stgit@ponder>
 <20111005065617.GA6824@kroah.com>
 <CACxGe6si_i9mbVQFjbKYkq1H1QOp9UvQqrd=+2fYGrs63xzC1A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACxGe6si_i9mbVQFjbKYkq1H1QOp9UvQqrd=+2fYGrs63xzC1A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 05, 2011 at 10:43:02AM -0600, Grant Likely wrote:
> On Wed, Oct 5, 2011 at 12:56 AM, Greg KH <greg@kroah.com> wrote:
> > On Tue, Oct 04, 2011 at 05:26:55PM -0600, Grant Likely wrote:
> >> For simple modules that contain a single platform_driver without any
> >> additional setup code then ends up being a block of duplicated
> >> boilerplate.  This patch adds a new macro, module_platform_driver(),
> >> which replaces the module_init()/module_exit() registrations with
> >> template functions.
> >>
> >> This patch also converts all the relevant spi drivers to use the new
> >> macro.  There are a lot of drivers in the tree that are using this
> >> pattern and could be converted.
> >>
> >> It also fixes up some incorrect section annotations where I found
> >> them.
> >>
> >> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> >> ---
> >>
> >> I think this is useful, and I like the diffstat that it produces.
> >> What does everyone else think of this approach?  I can do versions for
> >> i2c_drivers and spi_drivers too.
> >>
> >> This is *not* tested very much.  I'm circulating mostly for review for
> >> now.
> >
> > The idea looks sane to me, I like the diffstat it ends up creating, nice
> > job.
> 
> Thanks.  Can I take that as your a-b?  Can I merge it via the spi tree?

Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

And yes, please feel free to merge it through any tree you can.

greg k-h
