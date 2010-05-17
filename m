Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755222Ab0EQSpr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 14:45:47 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40925 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754034Ab0EQSpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 14:45:40 -0400
Date: Mon, 17 May 2010 11:45:42 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Felipe Balbi <me@felipebalbi.com>
Cc: Brian Swetland <swetland@google.com>,
       James Bottomley <James.Bottomley@suse.de>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Alan Stern <stern@rowland.harvard.edu>, linux-omap@vger.kernel.org,
       "Theodore Ts'o" <tytso@mit.edu>, Geoff Smith <geoffx.smith@intel.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Liam Girdwood <lrg@slimlogic.co.uk>, Matthew Garrett <mjg@redhat.com>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 6)
Message-ID: <20100517184541.GA7963@opensource.wolfsonmicro.com>
References: <Pine.LNX.4.44L0.1005151716180.24645-100000@netrider.rowland.org>
 <87hbm6cz90.fsf@deeprootsystems.com>
 <1274115885.4418.59.camel@mulgrave.site>
 <20100517174647.GA11512@gandalf>
 <1274119179.4418.68.camel@mulgrave.site>
 <20100517181252.GA14260@gandalf>
 <AANLkTikueXPEWEHQt-Fl3Xvb3EB4ntsBlJUjjtmpinGK@mail.gmail.com>
 <20100517183904.GA14047@gandalf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100517183904.GA14047@gandalf>
X-Cookie: Q:	Are we not men?
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 17, 2010 at 09:39:05PM +0300, Felipe Balbi wrote:
> On Mon, May 17, 2010 at 11:26:59AM -0700, Brian Swetland wrote:

> > For a large majority of apps, running in the background while the
> > device is asleep (screen off) is not essential, they don't request the
> > "keep device awake" permission, never hold a wakelock, etc.  Those
> > that do need to do this have the permission, may hold suspend
> > blockers, and are accounted for.

> but can anyone write an app that holds a suspend_blocker ?? If so, then
> your goal is already broken, right ? I mean, if anyone can keep a
> suspend_blocker held forever, you'll never ever sleep, right ? While
> with runtime, if you keep the keypad open, only the keypad and the paths
> directly related to it (probably the i2c controller and the power domain
> where the i2c controller sits) will be kept alive, no ?

The Android UI provides a list of which applications have been
preventing suspend and how long for, the idea being that if something
has been holding suspend blockers for ever you can at least look at the
list and see what it was.
