Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759364Ab1DNSNA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 14:13:00 -0400
Received: from mail.digium.com ([216.207.245.2]:44886 "EHLO mail.digium.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759253Ab1DNSMt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 14:12:49 -0400
Date: Thu, 14 Apr 2011 13:12:33 -0500
From: Shaun Ruffell <sruffell@digium.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Lin Ming <ming.m.lin@intel.com>,
        Don Zickus <dzickus@redhat.com>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Robert Richter <robert.richter@amd.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] perf, x86: fix unknown NMIs on a Pentium4 box
Message-ID: <20110414181226.GA14390@digium.com>
References: <4DA70950.3060102@openvz.org> <20110414174327.GA8863@elte.hu> <20110414174420.GA8950@elte.hu> <4DA733B1.1010702@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DA733B1.1010702@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 14, 2011 at 09:49:37PM +0400, Cyrill Gorcunov wrote:
> On 04/14/2011 09:44 PM, Ingo Molnar wrote:
>> 
>> below is the commit which needs to be fixed - note that i improved the 
>> changelog, please keep these fixes for future submissions.
> 
> Yes, thanks, i'll ping back as only get nit resolved.

Cyrill, I had not been running perf when I was testing, but I was able to
reproduce what Ingo reported. I'll make sure to run that on any future tests
as well. My apologies.
