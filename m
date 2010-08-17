Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757286Ab0HQPXP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 11:23:15 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:60113 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755941Ab0HQPXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 11:23:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mF1MgeakfYLn77WQ/CqhTah8r0OB+BwUTJ2KNtRwaNvfQEFvbqqrZKms7YZLFwjPhm
         t9ndmyWLnc5qc8q7ceNgIr/mALJV9kvERHPDrKjgCAvtnXNXPxCo6azGI0Hq407+j02o
         Bhd/sTDCowTNMejrBscUf3SARpC0zfdAmm2cc=
Date: Tue, 17 Aug 2010 19:23:08 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Don Zickus <dzickus@redhat.com>,
        Lin Ming <ming.m.lin@intel.com>, Ingo Molnar <mingo@elte.hu>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v2] perf, x86: try to handle unknown nmis with running
	perfctrs
Message-ID: <20100817152308.GB5879@lenovo>
References: <20100804163930.GE5130@lenovo> <20100804184806.GL26154@erda.amd.com> <20100804192634.GG5130@lenovo> <20100806065203.GR26154@erda.amd.com> <20100806142131.GA1874@redhat.com> <20100809194829.GB26154@erda.amd.com> <20100816190659.GI5805@lenovo> <20100816225525.GO26154@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100816225525.GO26154@erda.amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 17, 2010 at 12:55:25AM +0200, Robert Richter wrote:
> On 16.08.10 15:06:59, Cyrill Gorcunov wrote:
> > I suspect Peter was supposed to be in To: field ;)
> 
> It was the attempt to answer 2 mails with one. :)
> 

ah, I see ;)

> > Robert, I think we still may miss unknown irq, consider the case when
> > unknown nmi is latched while you handle nmi from perf and what is
> > more interesting several counters may be overflowed. So you set
> > delta small enough and second (unknown nmi) will be in range and
> > treated as being perf back-to-back, or I miss something from patch?
> 
> Yes, that's true, but before you have to enable your Infinite
> Improbability Drive.
> 

not at all, it's absolutely legit to happen ;)

> -Robert
> 
> -- 
> Advanced Micro Devices, Inc.
> Operating System Research Center
> 
	-- Cyrill
