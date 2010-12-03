Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758180Ab0LCAJp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 19:09:45 -0500
Received: from kroah.org ([198.145.64.141]:35845 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757824Ab0LCAJn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 19:09:43 -0500
Date: Thu, 2 Dec 2010 16:07:13 -0800
From: Greg KH <greg@kroah.com>
To: Matthew Wilcox <willy@linux.intel.com>
Cc: Luben Tuikov <ltuikov@yahoo.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [USB] UAS: Rename urbs by pipe
Message-ID: <20101203000713.GA21514@kroah.com>
References: <20101202214011.GE5009@linux.intel.com>
 <815549.25363.qm@web31805.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <815549.25363.qm@web31805.mail.mud.yahoo.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 02, 2010 at 02:26:42PM -0800, Luben Tuikov wrote:
> --- On Thu, 12/2/10, Matthew Wilcox <willy@linux.intel.com> wrote:
> > > On Thu, Oct 28, 2010 at 01:05:14PM -0700, Luben Tuikov
> > wrote:
> > > > The reason to do this is to accommodate sending
> > > > different IU types using the existing
> > > > infrastructure.
> > > > 
> > > > Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>
> > > 
> > > Matthew, it's been over a month, please comment on
> > these UAS patches, or
> > > I guess I'll just apply them...
> > 
> > Hi Greg,
> > 
> > These patches are NAKed in their current form.

I never saw those NAKs, please always copy the original people who were
copied on the patch when you do that.  The list never saw them either.

> >  Luben
> > does not care for how
> > I have modified them, so I need to rework them to take his
> > name off them.

Where did you rework them?  When were those patches posted?

> > I'll have a git tree ready for you after the weekend.

No, I want patches in email please.

> Are you serious? My commit message is quoted above. This email thread
> is available at http://marc.info/?t=128829652800022&r=1&w=2 as are my
> other patches to your code, where you stated you've committed them all
> but changed the commit logs (as typed by me). When asked to provide
> your changes to the commit logs in this very thread, you didn't.
> *Please don't twist the facts as you did my commit messages to suit
> your own needs.* 

I agree, this seems very odd.

Mathew, please be more public about what is going on here.

thanks,

greg k-h
