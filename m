Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333Ab0EQTyW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 15:54:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45270 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753126Ab0EQTyU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 15:54:20 -0400
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 6)
From: James Bottomley <James.Bottomley@suse.de>
To: me@felipebalbi.com
Cc: Kevin Hilman <khilman@deeprootsystems.com>,
       Alan Stern <stern@rowland.harvard.edu>, linux-omap@vger.kernel.org,
       "Theodore Ts'o" <tytso@mit.edu>, Geoff Smith <geoffx.smith@intel.com>,
       Brian Swetland <swetland@google.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Tejun Heo <tj@kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Liam Girdwood <lrg@slimlogic.co.uk>, Matthew Garrett <mjg@redhat.com>
In-Reply-To: <20100517193952.GC14047@gandalf>
References: <Pine.LNX.4.44L0.1005151716180.24645-100000@netrider.rowland.org>
	 <87hbm6cz90.fsf@deeprootsystems.com>
	 <1274115885.4418.59.camel@mulgrave.site> <20100517174647.GA11512@gandalf>
	 <1274119179.4418.68.camel@mulgrave.site> <20100517181252.GA14260@gandalf>
	 <1274124267.4418.149.camel@mulgrave.site> <20100517193840.GB14047@gandalf>
	 <20100517193952.GC14047@gandalf>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 17 May 2010 15:49:35 -0400
Message-ID: <1274125775.4418.182.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-17 at 22:39 +0300, Felipe Balbi wrote:
> hi,
> 
> On Mon, May 17, 2010 at 10:38:40PM +0300, Felipe Balbi wrote:
> > that's a whole other story. Hardware issues are things which in 99.999%
> > of the cases we can't change. We have to work around them. Software
> > bugs, on the other hand, can be fixed much more easily. I'm sure you
> > agree with that, don't you ?
> > 
> > Trying to make a comparisson between hardware bug and software bug is
> > simply non-sense in this case.
> 
> before you reply saying that most of the problems are firmware bugs, try
> to file a bug to any of the usb storage manufacturers and wait for them
> to fix. It's virtualy impossible, so let's consider it a problem that
> has to be worked around.

Right, because Firmware writers are from the rugged unresponsive uplands
of planet
ignore-user-complaints-and-eat-them-for-breakfast-if-they-file-bugs and
Software writers are from the emollient responsive groves of planet
harmony.  Obviously what would work for one wouldn't work for the other.

As a software writer, I fully buy into that world view.  The trouble is
that when I go to dinner with hardware people, they seem to be awfully
nice chaps ... almost exactly like me, in fact ...

James



