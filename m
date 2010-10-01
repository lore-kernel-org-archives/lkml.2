Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756977Ab0JAWQJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 18:16:09 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36571 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751110Ab0JAWQI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 18:16:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Nigel Cunningham <nigel@tuxonice.net>
Subject: Re: [PATCH 01/23] Hibernation: Split compression support out.
Date: Sat, 2 Oct 2010 00:15:10 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc6-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Linux PM <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "TuxOnIce-devel" <tuxonice-devel@tuxonice.net>
References: <1285566238-10966-1-git-send-email-nigel@tuxonice.net> <201010012328.09892.rjw@sisk.pl> <4CA65684.1050500@tuxonice.net>
In-Reply-To: <4CA65684.1050500@tuxonice.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201010020015.10749.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, October 01, 2010, Nigel Cunningham wrote:
> Hi Rafael.

Hi,

> On 02/10/10 07:28, Rafael J. Wysocki wrote:
> > On Monday, September 27, 2010, Nigel Cunningham wrote:
> >> Hi.
> >>
> >> On 28/09/10 06:27, Rafael J. Wysocki wrote:
> >>> On Monday, September 27, 2010, Nigel Cunningham wrote:
> > ...
> >>> This one doesn't really good to me.  What I'd prefer would be to have a
> >>> structure of "swap operations" pointers like ->start(), ->write_data(),
> >>> ->read_data(), and ->finish() that will point to the functions in this file
> >>> (if compression is to be used) or to the "old" swap_write_page()/swap_read_page()
> >>> otherwise.  That would reduce the number of the
> >>> (flags&   SF_NOCOMPRESS_MODE) checks quite substantially and will likely result
> >>> in code that's easier to follow.
> >>
> >> Me too. I was heading in that direction, but not doing it in one step.
> >> I'll happily change that.
> >
> > I'm still waiting for the reworked patch.  If you can submit it in a few days
> > and it looks good, I'll include it into the pull request for 2.6.37.
> 
> Sorry for the delay.

No biggie.

> Would you be happy if, rather than reworking that patch and modifying 
> other patches that are affected, I added a new patch to the end of the 
> series?

Not really.  That would make it difficult for other people to follow the
changes.  Let's do things in the right order from the start. :-)

Thanks,
Rafael
