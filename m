Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882Ab0LJSuy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 13:50:54 -0500
Received: from mail-gw0-f42.google.com ([74.125.83.42]:59950 "EHLO
	mail-gw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754846Ab0LJSux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 13:50:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rmgYRPWGAZsCCeMlIEmgke5L+t/aG9kiRq6M0cPpIhaxxajzpauIDG/x11zhrMzEjM
         3B/MKklvcfv6n0lPphYMgnKauRtknJ90lsBPFVua2qiPOst5W5xg+XrEb3UREdosoC/C
         ZTfCaJTr0x8jU4p/uld79gE7UvHReEVRLXix8=
Date: Fri, 10 Dec 2010 10:50:42 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Ping Cheng <pinglinux@gmail.com>
Cc: Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: mt: Interface and MT_TOOL documentation updates
Message-ID: <20101210185041.GC1630@core.coreip.homeip.net>
References: <1291929732-5989-1-git-send-email-rydberg@euromail.se>
 <AANLkTi=mqMY_VG=0RdN5O0fDh6wpTRb5Z59L6440hvX6@mail.gmail.com>
 <20101210181306.GB1630@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101210181306.GB1630@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 10, 2010 at 10:13:06AM -0800, Dmitry Torokhov wrote:
> On Fri, Dec 10, 2010 at 09:55:12AM -0800, Ping Cheng wrote:
> > On Thu, Dec 9, 2010 at 1:22 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
> > > +
> > > +- The MT_TOOL_ENVELOPE type is used to indicate that the contact position
> > > +is not well-defined, and is only used for legacy hardware. The real contact
> > > +positions are to be found within the bounding rectangle formed by the
> > > +envelope contact positions.
> > 
> > Can we make MT_TOOL_ENVELOPE cover a bit more cases by:
> > 
> > 1. Removing ", and is only used for legacy hardware";
> > 2. Adding "Or the number of contacts inside the bounding rectangle is
> > reported if hardware provides the number but not the real contact
> > positions" to the end of the paragraph.
> 
> Are you saying that there is upcoming hardware models that do not report
> individual contacts?
> 

Anyway, if we plot the evolution of hardware:

	ST -> ST + #fingers -> Envelope -> Full MT

I think we can rigthfully say that at this time all hardware that is not
full MT is legacy technology...

-- 
Dmitry
