Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757645Ab0EROAA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 10:00:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43207 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757353Ab0ERN75 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 09:59:57 -0400
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 6)
From: James Bottomley <James.Bottomley@suse.de>
To: felipe.balbi@nokia.com
Cc: "me@felipebalbi.com" <me@felipebalbi.com>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "Theodore Ts'o" <tytso@mit.edu>, Geoff Smith <geoffx.smith@intel.com>,
       Brian Swetland <swetland@google.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Tejun Heo <tj@kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Liam Girdwood <lrg@slimlogic.co.uk>, Matthew Garrett <mjg@redhat.com>
In-Reply-To: <20100518064022.GA6522@nokia.com>
References: <Pine.LNX.4.44L0.1005151716180.24645-100000@netrider.rowland.org>
	 <87hbm6cz90.fsf@deeprootsystems.com>
	 <1274115885.4418.59.camel@mulgrave.site> <20100517174647.GA11512@gandalf>
	 <1274119179.4418.68.camel@mulgrave.site> <20100517181252.GA14260@gandalf>
	 <1274124267.4418.149.camel@mulgrave.site> <20100517193840.GB14047@gandalf>
	 <20100517193952.GC14047@gandalf> <1274125775.4418.182.camel@mulgrave.site>
	 <20100518064022.GA6522@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 May 2010 09:59:48 -0400
Message-ID: <1274191188.10304.5.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-18 at 09:40 +0300, Felipe Balbi wrote:
> On Mon, May 17, 2010 at 09:49:35PM +0200, ext James Bottomley wrote:
> >Right, because Firmware writers are from the rugged unresponsive uplands
> >of planet
> >ignore-user-complaints-and-eat-them-for-breakfast-if-they-file-bugs and
> >Software writers are from the emollient responsive groves of planet
> >harmony.  Obviously what would work for one wouldn't work for the other.
> >
> >As a software writer, I fully buy into that world view.  The trouble is
> >that when I go to dinner with hardware people, they seem to be awfully
> >nice chaps ... almost exactly like me, in fact ...
> 
> what does this add to suspend_blockers discussion ?

Sorry I was evidently being too subtle.

The point is that if, as you acknowledge, that you can't train firmware
engineers to be responsive, there's no reason to think you can train
software engineers in the same quality ... they're very similar people.

The corollary is that real world systems have to operate in the face of
misbehaving hardware *and* software.

James


