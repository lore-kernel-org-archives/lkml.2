Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758202Ab0ENUlM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 16:41:12 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:54684 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446Ab0ENUlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 16:41:10 -0400
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Tony Lindgren <tony@atomide.com>, Matthew Garrett <mjg@redhat.com>,
       Alan Stern <stern@rowland.harvard.edu>, Paul Walmsley <paul@pwsan.com>,
       Arve =?iso-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       magnus.damm@gmail.com, "Theodore Ts'o" <tytso@mit.edu>,
       mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>,
       Brian Swetland <swetland@google.com>,
       =?iso-8859-1?Q?Beno=EEt?= Cousson <b-cousson@ti.com>,
       linux-omap@vger.kernel.org, Vitaly Wool <vitalywool@gmail.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 6)
References: <alpine.DEB.2.00.1005122118530.7624@utopia.booyaka.com>
	<201005132321.59245.rjw@sisk.pl> <20100513212556.GI3428@atomide.com>
	<201005132356.21355.rjw@sisk.pl>
From: Kevin Hilman <khilman@deeprootsystems.com>
Organization: Deep Root Systems, LLC
Date: Fri, 14 May 2010 13:41:05 -0700
In-Reply-To: <201005132356.21355.rjw@sisk.pl> (Rafael J. Wysocki's message of "Thu\, 13 May 2010 23\:56\:21 +0200")
Message-ID: <878w7mgqse.fsf@deeprootsystems.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> On Thursday 13 May 2010, Tony Lindgren wrote:
>> * Rafael J. Wysocki <rjw@sisk.pl> [100513 14:16]:

[...]

>>  
>> > It solves a practical issue that _at_ _the_ _moment_ cannot be solved
>> > differently, while there's a growing number of out-of-tree drivers depending
>> > on this framework.  We need those drivers in and because we don't have any
>> > viable alternative at hand, we have no good reason to reject it.
>> 
>> Nothing is preventing merging the drivers can be merged without
>> these calls.
>
> And yet, there _is_ a growing nuber of drivers that don't get merge because
> of that.  That's _reality_.  Are you going to discuss with facts, or what?

It may be reality, but IMO, "preventing other drivers" isn't a good
*technical* argument for merging a feature.  It feels like these "for
the 'good' of the community" arguments are being used to trump the
technical arguments.  Maybe we need to keep the separate.

Distros (especially embedded ones) have long had out of tree features
that create barriers to getting other drivers upstream.  While it
might be nice to see all those features upstream, no one has argued
that they should get merged simply because they create a barrier.  Each
feature should be merged on its own technical merit.

Kevin
