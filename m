Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759540Ab0EMWZN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 18:25:13 -0400
Received: from thunk.org ([69.25.196.29]:53424 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755034Ab0EMWZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 18:25:10 -0400
Date: Thu, 13 May 2010 18:24:25 -0400
From: tytso@mit.edu
To: Tony Lindgren <tony@atomide.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Matthew Garrett <mjg@redhat.com>,
       Alan Stern <stern@rowland.harvard.edu>, Paul Walmsley <paul@pwsan.com>,
       Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       Kevin Hilman <khilman@deeprootsystems.com>, magnus.damm@gmail.com,
       mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>,
       Brian Swetland <swetland@google.com>,
       =?iso-8859-1?Q?Beno=EEt?= Cousson <b-cousson@ti.com>,
       linux-omap@vger.kernel.org, Vitaly Wool <vitalywool@gmail.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 6)
Message-ID: <20100513222425.GC16989@thunk.org>
Mail-Followup-To: tytso@mit.edu, Tony Lindgren <tony@atomide.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, Matthew Garrett <mjg@redhat.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Paul Walmsley <paul@pwsan.com>,
	Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
	Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
	Kernel development list <linux-kernel@vger.kernel.org>,
	Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
	Kevin Hilman <khilman@deeprootsystems.com>, magnus.damm@gmail.com,
	mark gross <mgross@linux.intel.com>,
	Arjan van de Ven <arjan@infradead.org>,
	Geoff Smith <geoffx.smith@intel.com>,
	Brian Swetland <swetland@google.com>,
	=?iso-8859-1?Q?Beno=EEt?= Cousson <b-cousson@ti.com>,
	linux-omap@vger.kernel.org, Vitaly Wool <vitalywool@gmail.com>,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Liam Girdwood <lrg@slimlogic.co.uk>
References: <alpine.DEB.2.00.1005122118530.7624@utopia.booyaka.com>
 <20100513202320.GF3428@atomide.com>
 <20100513203412.GA21244@srcf.ucam.org>
 <201005132321.59245.rjw@sisk.pl>
 <20100513212556.GI3428@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100513212556.GI3428@atomide.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 13, 2010 at 02:25:56PM -0700, Tony Lindgren wrote:
> > I agree and I don't understand the problem that people have with the
> > opportunistic suspend feature.
> 
> It seems to be picking quite a few comments for one.

It's picking up a lot of comments because *someone* seems to be trying
to use a "last post wins" style of argumentation.  One of the things
that is hard for people who aren't regular denizens of LKML is to
understand whose comments can be ignored.....

Seriously, you are posting a lot, but it's not clear you're making any
clear sense...

					- Ted
