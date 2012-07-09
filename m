Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920Ab2GIOys (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 10:54:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754301Ab2GIOyq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 10:54:46 -0400
Date: Mon, 9 Jul 2012 17:54:42 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, David Ahern <dsahern@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: perf with precise attribute kills all KVM based VMs
Message-ID: <20120709145442.GE7298@redhat.com>
References: <4FFAE6D8.5050609@gmail.com>
 <20120709141904.GC7298@redhat.com>
 <1341843844.3462.75.camel@twins>
 <4FFAED16.7050204@redhat.com>
 <4FFAEF13.7010108@gmail.com>
 <1341845396.3462.81.camel@twins>
 <4FFAEFF1.9000706@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FFAEFF1.9000706@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 09, 2012 at 05:51:29PM +0300, Avi Kivity wrote:
> On 07/09/2012 05:49 PM, Peter Zijlstra wrote:
> > On Mon, 2012-07-09 at 08:47 -0600, David Ahern wrote:
> >> 
> >> I found this testing changes to perf-kvm, but found the problem extends 
> >> to just perf-record. With perf-record exclude_guest defaults to 1. See 
> >> tools/perf/util/util.c, event_attr_init(). 
> > 
> > You lost me there.. so perf-record defaults to exclude_guest=1 (which
> > would make the proposed patch I just send actually possible), but its
> > still going *bang* ?
> 
> It's possible that the DS writes overshoot the MSR... or that there's a
> bug somewhere.
> 
I hope it is the later, because we can do nothing with the former.

--
			Gleb.
