Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591Ab0F2SJl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 14:09:41 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:55915 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753405Ab0F2SJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 14:09:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jTgVvL3/f2cGPcCUJsXcHNZRp4UDX0+Ikd1PJGa6ZeL4JnjtaRwLbqWZZUSTiNGbO0
         zNFExS/DiDv2hvSekRVoqToGCAk4FcoUHG2lwMZ/dr6T2BMz2sWHNknoqyfX9Vj5Ck1J
         SkJeNRQQUKFNbu5dGJLLFY/jEvYxGfLrX1+uY=
Date: Tue, 29 Jun 2010 20:09:49 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: paulus <paulus@samba.org>, stephane eranian <eranian@googlemail.com>,
       Robert Richter <robert.richter@amd.com>,
       Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Yanmin <yanmin_zhang@linux.intel.com>,
       Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 11/11] perf: Rework the PMU methods
Message-ID: <20100629180947.GB11967@nowhere>
References: <20100624142804.431553874@chello.nl> <20100624143407.106583261@chello.nl> <20100629153753.GI5318@nowhere> <1277829601.1868.50.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277829601.1868.50.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 29, 2010 at 06:40:01PM +0200, Peter Zijlstra wrote:
> On Tue, 2010-06-29 at 17:37 +0200, Frederic Weisbecker wrote:
> 
> > Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
> 
> I know it breaks at least x86 (although subtle, takes a few perf records
> to daze and confuse), arm and sh.
> 
> I need to get back to this patch-set and sort that :-)


Ok :)

But at least the whole idea looks good. Concerning the software parts
I will make a second pass to optimize from my exclusion patchset, but
other than that, it sets a nice background for it.

