Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756700Ab0ENWqG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 18:46:06 -0400
Received: from mail-pz0-f204.google.com ([209.85.222.204]:35964 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753534Ab0ENWqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 18:46:02 -0400
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
	<878w7mgqse.fsf@deeprootsystems.com>
	<87tyqaduvr.fsf@deeprootsystems.com> <201005142350.01222.rjw@sisk.pl>
From: Kevin Hilman <khilman@deeprootsystems.com>
Organization: Deep Root Systems, LLC
Date: Fri, 14 May 2010 15:45:58 -0700
In-Reply-To: <201005142350.01222.rjw@sisk.pl> (Rafael J. Wysocki's message of "Fri\, 14 May 2010 23\:50\:01 +0200")
Message-ID: <87k4r69k61.fsf@deeprootsystems.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> On Friday 14 May 2010, Kevin Hilman wrote:
>> Kevin Hilman <khilman@deeprootsystems.com> writes:
>> 
>> > "Rafael J. Wysocki" <rjw@sisk.pl> writes:
>> >
>> >> On Thursday 13 May 2010, Tony Lindgren wrote:
>> >>> * Rafael J. Wysocki <rjw@sisk.pl> [100513 14:16]:
>> >
>> > [...]
>> >
>> >>>  
>> >>> > It solves a practical issue that _at_ _the_ _moment_ cannot be solved
>> >>> > differently, while there's a growing number of out-of-tree drivers depending
>> >>> > on this framework.  We need those drivers in and because we don't have any
>> >>> > viable alternative at hand, we have no good reason to reject it.
>> >>> 
>> >>> Nothing is preventing merging the drivers can be merged without
>> >>> these calls.
>> >>
>> >> And yet, there _is_ a growing nuber of drivers that don't get merge because
>> >> of that.  That's _reality_.  Are you going to discuss with facts, or what?
>> >
>> > It may be reality, but IMO, "preventing other drivers" isn't a good
>> > *technical* argument for merging a feature.  It feels like these "for
>> > the 'good' of the community" arguments are being used to trump the
>> > technical arguments.  Maybe we need to keep the separate.
>> 
>> To continue along the "for the good of the community" path...
>> 
>> If it truly is the lack of a suspend blocker API that is preventing
>> the merge of these out of tree drivers, I second Mark's proposal[1] to
>> merge a noop version of the API while the technical issues continue to
>> be discussed.
>
> I'm against that, sorry.

OK, I'll bite... Why?

>> Then we would see how many drivers get submitted and merged.
>>
>> Personally, I suspect that lack of this feature is not the real
>> obstacle to getting these out-of-tree drivers upstream.  Having this
>> API upstream will not change the product schedules and corporate
>> cultures that have prevented code from making its way upstream.
>
> But apparently it is considered as a suitable excuse.

No, it is not a _technical_ excuse.  Just a healthy, experience-based
dose of skepticism.

It was expressed because I find the arguments above for merging
because it prevents out-of-tree drivers from merging quite
unconvincing.  This is not just about opportunistic suspend + suspend
blockers specifically but comes from several years experience in the
embedded Linux world.

Kevin
