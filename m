Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758929Ab2ILOS0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 10:18:26 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:25551 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797Ab2ILOSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 10:18:24 -0400
Date: Wed, 12 Sep 2012 17:18:16 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: "Valentin, Eduardo" <eduardo.valentin@ti.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org, b-cousson@ti.com,
        j-keerthy@ti.com, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH 1/4] staging: omap-thermal: Correct checkpatch.pl warnings
Message-ID: <20120912141816.GK19410@mwanda>
References: <1347379615-6881-1-git-send-email-eduardo.valentin@ti.com>
 <1347379615-6881-2-git-send-email-eduardo.valentin@ti.com>
 <20120912081127.GB19396@mwanda>
 <20120912082639.GI19410@mwanda>
 <CAGF5oy8kyMOO+0kxHO054LKxEh5jkUQGUuUM4OF0ncQV4x8uxQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGF5oy8kyMOO+0kxHO054LKxEh5jkUQGUuUM4OF0ncQV4x8uxQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 12:19:00PM +0300, Valentin, Eduardo wrote:
> Hello Dan,
> 
> On Wed, Sep 12, 2012 at 11:26 AM, Dan Carpenter
> <dan.carpenter@oracle.com> wrote:
> > On Wed, Sep 12, 2012 at 11:11:27AM +0300, Dan Carpenter wrote:
> >> On Tue, Sep 11, 2012 at 07:06:52PM +0300, Eduardo Valentin wrote:
> >> > From: J Keerthy <j-keerthy@ti.com>
> >> >
> >> > Removes checkpatch warnings on omap-bandgap.c.
> >> >
> >>
> >> Which checkpatch.pl warnings?
> >>
> >> > +                           omap_bandgap_writel(bg_ptr,
> >> > +                                   rval->tshut_threshold,
> >> > +                                              tsr->tshut_threshold);
> >>
> >> That's just whacky.
> >>
> >> Personally, I've never cared much about long lines, so I'd prefer
> >> to leave these as is until someone can break the functions up and
> >> remove them in a proper way instead of just shifting everything
> >> randomly to the left.
> >>
> >
> > Sorry, that was my default response without looking at the code.
> >
> > This is already broken up into small functions pretty nicely.  You
> > might want to consider using shorter names.  For example
> > omap_bandgap_writel() could be changed to "obg_writel()" and "bg_ptr"
> > could be changed to just "bg" because it's obviously a pointer.
> 
> Yeah, that's one option. Of course the deal is to find the proper
> balance between cryptic symbol names and code mangled / shifted to the
> left.
> 

Another option would be to just let checkpatch complain.  It's a
perl script, not the king of us.  Do what looks the nicest to human
beings.

regards,
dan carpenter

