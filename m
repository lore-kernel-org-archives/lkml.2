Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063Ab0HPTSu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 15:18:50 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:49762 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755979Ab0HPTSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 15:18:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=n6oThI/d1I0eCYW0llI5fVo55cpPf+CEZYAgzV/EAphUnGNdHZoPehgDbQeRaAcn3w
         cf5ZEhOod3UlffWzO2unE9Z0a5yPzRS7Vdeex+p4CkXg0K55NVHlzF1Y05EakkSLq0Oq
         /okQpInPKR2vAmkcWRzba+1uofb5vyKuo7WQw=
Date: Mon, 16 Aug 2010 23:18:46 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Robert Richter <robert.richter@amd.com>, Don Zickus <dzickus@redhat.com>,
        Lin Ming <ming.m.lin@intel.com>, Ingo Molnar <mingo@elte.hu>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v2] perf, x86: try to handle unknown nmis with running
	perfctrs
Message-ID: <20100816191846.GJ5805@lenovo>
References: <20100804192634.GG5130@lenovo> <20100806065203.GR26154@erda.amd.com> <20100806142131.GA1874@redhat.com> <20100809194829.GB26154@erda.amd.com> <20100811220058.GT26154@erda.amd.com> <1281970116.1926.1495.camel@laptop> <20100816162706.GH5805@lenovo> <20100816171610.GN26154@erda.amd.com> <20100816190659.GI5805@lenovo> <1281985996.1926.1848.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281985996.1926.1848.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 16, 2010 at 09:13:16PM +0200, Peter Zijlstra wrote:
> On Mon, 2010-08-16 at 23:06 +0400, Cyrill Gorcunov wrote:
> > I never heard of backward running tsc, though tsc is a strange beast.
> > 
> Its not supposed to happen, but then there's BIOS failure-add that frobs
> the TSC from SMIs and fun TSC artifacts around CPU frequency changes and
> people resetting TSC in S-states etc..

grr :/

> 
> In short, never trust the TSC to be even remotely sane.
> 

ok, good to know, thanks!

	-- Cyrill
