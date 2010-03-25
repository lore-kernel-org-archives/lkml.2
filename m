Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853Ab0CYU0S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 16:26:18 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51345 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754819Ab0CYU0R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 16:26:17 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Nigel Cunningham <ncunningham@crca.org.au>
Subject: Re: what the patches do Re: [RFC 10/15] PM / Hibernate: user, implement user_ops reader
Date: Thu, 25 Mar 2010 21:29:10 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc2-rjw; KDE/4.3.5; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>, Jiri Slaby <jslaby@suse.cz>,
       jirislaby@gmail.com, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
References: <1269361063-3341-1-git-send-email-jslaby@suse.cz> <201003252114.36605.rjw@sisk.pl> <4BABC5B6.2070301@crca.org.au>
In-Reply-To: <4BABC5B6.2070301@crca.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003252129.10224.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 25 March 2010, Nigel Cunningham wrote:
> Hi.
> 
> On 26/03/10 07:14, Rafael J. Wysocki wrote:
> > On Thursday 25 March 2010, Nigel Cunningham wrote:
> >> Hi.
> >>
> >> On 25/03/10 16:30, Pavel Machek wrote:
> >> [...]
> >>
> >>> I have some problems with sws_module_ops interface (handcoded locking
> >>> is too ugly to live), but it is better than I expected. But there may
> >>> be better solution available, one that does not need two interfaces to
> >>> maintain (we can't really get rid of userland interface). What about
> >>> this?
> >>
> >> Just picking up on that bracketed part: Can we flag the userland
> >> interface (and uswsusp) as being planned for eventual removal now... or
> >> at least agree to work toward that?
> >
> > No, we can't.
> >
> >> I'm asking because if we're going to make a go of getting the in-kernel
> >> code in much better shape, and we have Rafael, Jiri and I - and you? -
> >> all pulling in the same direction to improve it, there's going to come a
> >> point (hopefully not too far away) where uswsusp is just making life too
> >> difficult, and getting rid of it will be a big help.
> >
> > We're not dropping user space interfaces used by every distro I know of.
> 
> So what's your long term plan then?

First, improve the in-kernel thing, second, switch people to it, _then_ remove
the s2disk interface (after we're reasonably sure it's not used by any major
distro) and _finally_ simplify things after it's been removed.

Does that sound reasonable?

Rafael
