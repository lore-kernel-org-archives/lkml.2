Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521Ab2DOPXI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 11:23:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22890 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754500Ab2DOPXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 11:23:06 -0400
Date: Sun, 15 Apr 2012 18:23:00 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: acme@ghostprotocols.net, mingo@redhat.com, jolsa@redhat.com,
        linux-kernel@vger.kernel.org, avi@redhat.com
Subject: Re: [PATCH] perf tools: Add 'G' and 'H' modifiers to event parsing
Message-ID: <20120415152300.GL11918@redhat.com>
References: <20120415145948.GK11918@redhat.com>
 <1334502742.28150.13.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334502742.28150.13.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 15, 2012 at 05:12:22PM +0200, Peter Zijlstra wrote:
> On Sun, 2012-04-15 at 17:59 +0300, Gleb Natapov wrote:
> > -modifier_event [ukhp]{1,5}
> > +modifier_event [ukhpGH]{1,5} 
> 
> You'd also need to increase the 5 to 7 I think, unless there's a clear
> exclusion with some of the other flags.
> 
> Hmm, as it stands I think the 5 is already too low: "ukhppp" is 6.
> 
> We should really write this as ['u'] ['k'] ['h'] ['G'] ['H'] ['p'{1,3}],
> not the combined thing.
If we will write them like that they all will have to be present for
successful match of modifier_event, no?

--
			Gleb.
