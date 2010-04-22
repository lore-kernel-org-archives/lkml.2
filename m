Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437Ab0DVWqy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 18:46:54 -0400
Received: from 1wt.eu ([62.212.114.60]:63493 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753268Ab0DVWqw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 18:46:52 -0400
Date: Fri, 23 Apr 2010 00:46:35 +0200
From: Willy Tarreau <w@1wt.eu>
To: Greg KH <gregkh@suse.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Joe Perches <joe@perches.com>,
       devel@driverdev.osuosl.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: What's the staging review and acceptance process?
Message-ID: <20100422224635.GD7798@1wt.eu>
References: <1271881967.1730.482.camel@Joe-Laptop.home> <20100422034532.GA25177@suse.de> <1271910357.1730.627.camel@Joe-Laptop.home> <20100422054902.GA28037@suse.de> <20100422101708.69c90142@lxorguk.ukuu.org.uk> <20100422201819.GC26924@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100422201819.GC26924@suse.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 22, 2010 at 01:18:19PM -0700, Greg KH wrote:
> On Thu, Apr 22, 2010 at 10:17:08AM +0100, Alan Cox wrote:
> > On Wed, 21 Apr 2010 22:49:02 -0700
> > Greg KH <gregkh@suse.de> wrote:
> > 
> > > On Wed, Apr 21, 2010 at 09:25:57PM -0700, Joe Perches wrote:
> > > > On Wed, 2010-04-21 at 20:45 -0700, Greg KH wrote:
> > > > > That caused the huge backlog staring at
> > > > > me right now.
> > > > 
> > > > Which likely discouraged the new contributors who
> > > > submitted stuff still in that backlog.
> > > 
> > > While a series of unfortunate events did happen to cause this, do you
> > > have any evidence of this causing people to go away? 
> > 
> > Subjectively the answer is yes I think. More quantatively it was the case.
> > I did some measurements long ago with 2.4-ac and there was direct and
> > clear connection between two things and patch submission/activity levels.
> > One was 'cycle time' (ie time from submit->response->tree) - the other was
> > putting the name of the contributor in the per -ac patch summaries that
> > used to get mailed out.
> 
> Yeah, I know I liked seeing my name there, that was very nice to have :)

For this exact reason, I pay a lot of attention to credit the people who
contribute some work, even if I have to adapt it afterwards. I've long
observed that doing this is essential if you want to see them come again
with some nice work.

Concerning the delay, it's even a tunable. When I took over 2.4, I did
not realize that being too much reactive to mails became an incitation
for submitters to send many many things. After some time (primarily due
to lack of time), I started to work by batches and I noticed that the
submission rates dramatically dropped. So I totally agree with Alan here.

BTW Greg, I too remember the time when a buddy was excited to forward to
me an announce from Alan where my name was cited :-)

Regards,
Willy

