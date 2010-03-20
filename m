Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055Ab0CTE7J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 00:59:09 -0400
Received: from one.firstfloor.org ([213.235.205.2]:47674 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666Ab0CTE7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 00:59:08 -0400
Date: Sat, 20 Mar 2010 05:59:02 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       robert.richter@amd.com
Subject: Re: [PATCH] oprofile: remove double ring buffering
Message-ID: <20100320045902.GR20695@one.firstfloor.org>
References: <20100320000323.GA8411@basil.fritz.box> <1269060320.28658.7.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269060320.28658.7.camel@localhost>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 20, 2010 at 12:45:20AM -0400, Steven Rostedt wrote:
> On Sat, 2010-03-20 at 01:03 +0100, Andi Kleen wrote:
> > [This is currently being tested if it fixes the excessive samples
> > dropping I have been complaining about for some time. Still wanted
> > to post the patch for review.]
> > 
> > commit 49e66e8ab54f1114237e6dc24dc32ac912870c41
> > Author: Andi Kleen <ak@linux.intel.com>
> > Date:   Fri Mar 19 21:03:48 2010 +0100
> > 
> >     oprofile: remove double ring buffering
> >     
> >     oprofile used a double buffer scheme for its cpu event buffer
> >     to avoid races on reading with the old lock less ring buffer.
> 
> The old ring buffer was not lockless, hence the need for two ring
> buffers because of NMIs. The new ring buffer is lockless.

Thanks. Description fixed.

-Andi
