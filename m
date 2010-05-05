Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760622Ab0EEPgA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 11:36:00 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:39008 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1760368Ab0EEPf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 11:35:58 -0400
Date: Wed, 5 May 2010 11:35:56 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Brian Swetland <swetland@google.com>,
       Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       <linux-pm@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       Paul Walmsley <paul@pwsan.com>, <magnus.damm@gmail.com>,
       mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>
Subject: Re: [PATCH 0/8] Suspend block api (version 6)
In-Reply-To: <20100504235644.GA5231@opensource.wolfsonmicro.com>
Message-ID: <Pine.LNX.4.44L0.1005051133210.1885-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 May 2010, Mark Brown wrote:

> Now, the solution here if we're going to use opportunistic suspend like
> this is to provide some method for the audio subsystem to figure out
> that the system doesn't actually want it to suspend when it gets told do
> do so.  Like I say ideally we'd provide some standard interface in the
> PM subsystem for userspace to communicate this to subsystems and drivers
> so that we've got a joined up story when people run into issues in cases
> like this, though obviously if this goes in then we'll have to put in
> something subsystem or driver specific for affected areas.  I know what
> I'd implement generically for audio, but I've held back since the option
> is fairly messy when not used in conjunction with a deliberate choice to
> use opportunistic suspend and I was expecting a standard mechanism to
> slot into to provide control for userspace.
> 
> In other words, the issue is that we run into situations where we need
> an element of suspend control to go along with the opportunistic suspend
> in order to allow some elements to be kept running - since suspend
> blocking is taken suspend suppression seems like a reasonable term.

Android must already include some solution to this problem.  Why not 
use that solution more generally?

Alan Stern

