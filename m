Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753004Ab0DYQga (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 12:36:30 -0400
Received: from kroah.org ([198.145.64.141]:42114 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751961Ab0DYQg3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 12:36:29 -0400
Date: Sun, 25 Apr 2010 09:37:11 -0700
From: Greg KH <greg@kroah.com>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
       Kay Sievers <kay.sievers@vrfy.org>,
       David Woodhouse <dwmw2@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Emmanuel Grumbach <egrumbach@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: request_firmware API exhaust memory
Message-ID: <20100425163711.GA20196@kroah.com>
References: <k2h1ba2fa241004190520z5f048287v6f84e9117b04c803@mail.gmail.com> <20100419145934.GA10893@kroah.com> <t2w1ba2fa241004211522le49fc938m341553b0f2b89031@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <t2w1ba2fa241004211522le49fc938m341553b0f2b89031@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 22, 2010 at 01:22:51AM +0300, Tomas Winkler wrote:
> On Mon, Apr 19, 2010 at 5:59 PM, Greg KH <greg@kroah.com> wrote:
> > On Mon, Apr 19, 2010 at 03:20:34PM +0300, Tomas Winkler wrote:
> >> Lately we've been developing a device that rather more extensively
> >> used request_firmware API in load and also using pm_notifiers to load
> >> firmware.
> >
> > Do you have a pointer to your driver source anywhere that shows how you
> > are trying to use the firmware api in this manner?
> 
> I've attached a very simple  test driver I'm using.  Just wanted to
> eliminate anything else.
> Bellow is a little script that loads and releases the firmware. My
> previous observation was wrong.
> The free memory gradually decreases regardless of number or dangling
> udevd forks, which are eventually collected if the sleep period is
> long enough ~10s.

That sounds normal for the free memory.  Kay, that's also to be expected
for the udevd forks as well, right?

thanks,

greg k-h
