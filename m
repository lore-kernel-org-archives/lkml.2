Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804Ab0ETFPq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 01:15:46 -0400
Received: from ist.d-labs.de ([213.239.218.44]:48008 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753045Ab0ETFPp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 01:15:45 -0400
Date: Thu, 20 May 2010 07:15:28 +0200
From: Florian Mickler <florian@mickler.org>
To: felipe.balbi@nokia.com
Newsgroups: gmane.linux.kernel,gmane.linux.ports.arm.omap
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
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Liam Girdwood <lrg@slimlogic.co.uk>, Matthew Garrett <mjg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 6)
Message-ID: <20100520071528.494c38e4@schatten.dmk.lab>
In-Reply-To: <20100519065934.GH12879@nokia.com>
References: <1274115885.4418.59.camel@mulgrave.site>
	<20100517174647.GA11512@gandalf>
	<1274119179.4418.68.camel@mulgrave.site>
	<20100517181252.GA14260@gandalf>
	<1274124267.4418.149.camel@mulgrave.site>
	<20100517193840.GB14047@gandalf>
	<20100517193952.GC14047@gandalf>
	<1274125775.4418.182.camel@mulgrave.site>
	<20100518064022.GA6522@nokia.com>
	<1274191188.10304.5.camel@mulgrave.site>
	<20100519065934.GH12879@nokia.com>
X-Newsreader: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 May 2010 09:59:34 +0300
Felipe Balbi <felipe.balbi@nokia.com> wrote:


> >The corollary is that real world systems have to operate in the face of
> >misbehaving hardware *and* software.
> 
> I still think the kernel shouldn't deal with broken applications and we 
> shouldn't try to fix them in kernel space. We can, of course, try to 
> find them and have all sorts of bells and whistles shouting 'process 
> %s is preventing CPU from sleeping for %llu nanoseconds' or something 
> like that.
> 

But with that, you still shift the burden of exchanging that app with
an feature-equivalent non-broken version to the user. 
which is not user friendly and not necessary if you have a "smart"
enough kernel.

Cheers,
Flo 
