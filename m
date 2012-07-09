Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641Ab2GIOvh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 10:51:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8770 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754549Ab2GIOvf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 10:51:35 -0400
Message-ID: <4FFAEFF1.9000706@redhat.com>
Date: Mon, 09 Jul 2012 17:51:29 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: David Ahern <dsahern@gmail.com>, Gleb Natapov <gleb@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: perf with precise attribute kills all KVM based VMs
References: <4FFAE6D8.5050609@gmail.com> <20120709141904.GC7298@redhat.com>  <1341843844.3462.75.camel@twins> <4FFAED16.7050204@redhat.com>  <4FFAEF13.7010108@gmail.com> <1341845396.3462.81.camel@twins>
In-Reply-To: <1341845396.3462.81.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/2012 05:49 PM, Peter Zijlstra wrote:
> On Mon, 2012-07-09 at 08:47 -0600, David Ahern wrote:
>> 
>> I found this testing changes to perf-kvm, but found the problem extends 
>> to just perf-record. With perf-record exclude_guest defaults to 1. See 
>> tools/perf/util/util.c, event_attr_init(). 
> 
> You lost me there.. so perf-record defaults to exclude_guest=1 (which
> would make the proposed patch I just send actually possible), but its
> still going *bang* ?

It's possible that the DS writes overshoot the MSR... or that there's a
bug somewhere.


-- 
error compiling committee.c: too many arguments to function


