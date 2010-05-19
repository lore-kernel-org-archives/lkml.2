Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199Ab0ESUlf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 16:41:35 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48492 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753514Ab0ESUld (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 16:41:33 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: felipe.balbi@nokia.com
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 6)
Date: Wed, 19 May 2010 22:42:55 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rjw; KDE/4.3.5; x86_64; ; )
Cc: ext James Bottomley <James.Bottomley@suse.de>,
       "me@felipebalbi.com" <me@felipebalbi.com>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "Theodore Ts'o" <tytso@mit.edu>, Geoff Smith <geoffx.smith@intel.com>,
       Brian Swetland <swetland@google.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Tejun Heo <tj@kernel.org>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Liam Girdwood <lrg@slimlogic.co.uk>, Matthew Garrett <mjg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <1274115885.4418.59.camel@mulgrave.site> <1274191188.10304.5.camel@mulgrave.site> <20100519065934.GH12879@nokia.com>
In-Reply-To: <20100519065934.GH12879@nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005192242.55706.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 19 May 2010, Felipe Balbi wrote:
> On Tue, May 18, 2010 at 03:59:48PM +0200, ext James Bottomley wrote:
> >On Tue, 2010-05-18 at 09:40 +0300, Felipe Balbi wrote:
> >> On Mon, May 17, 2010 at 09:49:35PM +0200, ext James Bottomley wrote:
> >> >Right, because Firmware writers are from the rugged unresponsive uplands
> >> >of planet
> >> >ignore-user-complaints-and-eat-them-for-breakfast-if-they-file-bugs and
> >> >Software writers are from the emollient responsive groves of planet
> >> >harmony.  Obviously what would work for one wouldn't work for the other.
> >> >
> >> >As a software writer, I fully buy into that world view.  The trouble is
> >> >that when I go to dinner with hardware people, they seem to be awfully
> >> >nice chaps ... almost exactly like me, in fact ...
> >>
> >> what does this add to suspend_blockers discussion ?
> >
> >Sorry I was evidently being too subtle.
> >
> >The point is that if, as you acknowledge, that you can't train firmware
> >engineers to be responsive, there's no reason to think you can train
> >software engineers in the same quality ... they're very similar people.
> 
> I wouldn't say it's up to the engineer himself, it's more related to how 
> the company that person works for deal with such things.
> 
> >The corollary is that real world systems have to operate in the face of
> >misbehaving hardware *and* software.
> 
> I still think the kernel shouldn't deal with broken applications and we 
> shouldn't try to fix them in kernel space. We can, of course, try to 
> find them and have all sorts of bells and whistles shouting 'process 
> %s is preventing CPU from sleeping for %llu nanoseconds' or something 
> like that.

Please note that this approach is not too practical for vendors who ship
systems like cell phones to the general public.

Rafael
