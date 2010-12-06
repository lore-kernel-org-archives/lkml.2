Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315Ab0LFO66 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 09:58:58 -0500
Received: from one.firstfloor.org ([213.235.205.2]:54211 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709Ab0LFO65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 09:58:57 -0500
Date: Mon, 6 Dec 2010 15:58:52 +0100
From: Andi Kleen <andi@firstfloor.org>
To: "Ted Ts'o" <tytso@mit.edu>, Andi Kleen <andi@firstfloor.org>,
        David Sharp <dhsharp@google.com>, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, mrubin@google.com
Subject: Re: [Patch 00/15] Reduce tracing payload size.
Message-ID: <20101206145852.GA24977@basil.fritz.box>
References: <1291421609-14665-1-git-send-email-dhsharp@google.com>
 <878w03t4sn.fsf@basil.nowhere.org>
 <20101206135637.GC8135@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101206135637.GC8135@thunk.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 06, 2010 at 08:56:37AM -0500, Ted Ts'o wrote:
> On Mon, Dec 06, 2010 at 02:22:00PM +0100, Andi Kleen wrote:
> > David Sharp <dhsharp@google.com> writes:
> > >
> > > These patches are just a start to shrinking the size of trace events. I am
> > > planning to also make small versions of trace events that are used when
> > > CONFIG_SMALL_TRACES is enabled. I'm also open to discussion of other ways to
> > > shrink event sizes.
> > 
> > Maybe the simplest would be to lzo them as they get logged?
> > I assume you already considered that?
> 
> The tracing subsystem is supposed to be extremely low-overhead.
> Compressiong the event log would add considerable CPU overhead.  If we

lzo as a rule of thumb is about as expensive as 3x memcpy()
That's not really expensive.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
