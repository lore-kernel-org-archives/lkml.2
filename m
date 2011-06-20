Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755102Ab1FTOsb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 10:48:31 -0400
Received: from mail.elliptictech.com ([209.217.122.41]:56131 "EHLO
	mail.ellipticsemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013Ab1FTOs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 10:48:29 -0400
Date: Mon, 20 Jun 2011 10:48:18 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, autofs@linux.kernel.org,
        Ian Kent <raven@themaw.net>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: Lockdep splat in autofs with 2.6.39-rc2
Message-ID: <20110620144818.GA30283@elliptictech.com>
References: <20110407194403.GA29404@elliptictech.com>
 <20110421212537.GC24898@home.goodmis.org>
 <20110427132219.GA2843@elliptictech.com>
 <20110511191301.GA18504@elliptictech.com>
 <1308012193.9218.105.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308012193.9218.105.camel@gandalf.stny.rr.com>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven, and sorry for the delay.

On 2011-06-13 20:43 -0400, Steven Rostedt wrote:
> I'm going to wrap this up and send it out as a proper patch. Can I add
> your "Reported-by" and "Tested-by" tags?

Sure, but please only add Tested-by if the code changes are the same as
the patch I actually tested.

Cheers,
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
