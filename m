Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750837Ab0ELEHb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 00:07:31 -0400
Received: from trinity.fluff.org ([89.16.178.74]:48836 "EHLO trinity.fluff.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750695Ab0ELEH3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 00:07:29 -0400
Date: Wed, 12 May 2010 05:07:13 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: InKi Dae <daeinki@gmail.com>, linux-fbdev-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
       Ben Dooks <ben-linux@fluff.org>
Subject: Re: [PATCH] s3c-fb: added patch series for s5pv210 and some
	features.
Message-ID: <20100512040713.GP2589@trinity.fluff.org>
References: <m2g90b950fc1005070059k99d138efr4bfa7de44c58fdd0@mail.gmail.com> <20100510172254.1f28f07c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100510172254.1f28f07c.akpm@linux-foundation.org>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 10, 2010 at 05:22:54PM -0400, Andrew Morton wrote:
> On Fri, 7 May 2010 16:59:56 +0900 InKi Dae <daeinki@gmail.com> wrote:
> 
> > this includes three patch series and divides previous patch
> > into smaller part.
> > 
> > so Andrew, please remove my previous patch,
> > s3c-fb-add-s5pv210-support-and-some-features.patch from mm tree.
> > 
> > patch contents are as following.
> > 
> > 1. s3c_fb_1_3.patch
> >   - as patch for supporting s5pv210, CH_ENABLE bit of SHAD
> >     register should be enabled to enable window layer on s5pv210.
> > 
> > 2. s3c_fb_2_3.patch
> >    - s5pv210 has five window layers (window0 ~ 4), among them,
> >      window0 ~ 2 could be used for local path with fimc(capture device)
> >      and fimd writeback feature so this patch makes default window
> >      layer for UI to be set at machine code.
> > 
> > 3. s3c_fb_3_3.patch
> >    - it has been working fine at 16bpp but in case of pixel format
> >      more then 24bpp it would occur distortedness situation
> >      on that mode. so this patch set the word swap control bit of
> >      WINCONx to 1 as default value. but it should be set to 0
> >      in case that each ENLOCAL bit of WINCON0 ~ 2 registers
> >      is enabled. this issue would be solved with local path feature soon.
> 
> I prefer not to receive patches this way, sorry.  I will need to detach
> the attachments, copy-n-paste the changelogs and signoffs and then
> invent meaningful English-language titles for each patch.

Please include me on these patches as I am working on adding S3C2443/2416
support to the driver and removing the need for arch-based header files
for this.

I may ask Andrew if we can merge the updates via my samsung tree as it is
possible that we need to touch arch code and driver code at the same time.

-- 
Ben

Q:      What's a light-year?
A:      One-third less calories than a regular year.

