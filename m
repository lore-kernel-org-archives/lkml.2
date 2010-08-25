Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660Ab0HYVhB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 17:37:01 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:56062 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997Ab0HYVg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 17:36:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nb2P9HxfcyPSQfHKLy3QCpP5k3UiAGol0XoDD7c/oGeOx4+4R41xNOnYOLaMihGovb
         tWkJNS8mHuSLsAK5BSd9ePVE7HmTo2KFbUGZnWVvIjzGC8igcNuDD1tAfq5Xoikpc/VL
         /4LIZnWoPKOrRVAu3pzpq/t21h1dTyQXOmy78=
Date: Thu, 26 Aug 2010 01:36:54 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Robert Richter <robert.richter@amd.com>,
        Peter Zijlstra <peterz@infradead.org>, Lin Ming <ming.m.lin@intel.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v3] perf, x86: try to handle unknown nmis with running
	perfctrs
Message-ID: <20100825213654.GF14874@lenovo>
References: <9g472epksbkxhgmw6a3qh8r5.1282316687153@email.android.com> <20100820152510.GA4167@elte.hu> <20100825094819.GB3198@erda.amd.com> <20100825104130.GA27891@elte.hu> <20100825110006.GB27891@elte.hu> <20100825201106.GH4879@redhat.com> <20100825202458.GE14874@lenovo> <20100825212037.GI4879@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100825212037.GI4879@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 25, 2010 at 05:20:37PM -0400, Don Zickus wrote:
... 
> The only problem is only one counter is overflowing in these cases, so we
> would have to do it all the time, which may not be hard.  But I was
> thinking of something similar.
> 
> For now, I am trying to force counter0 off, seeing that most of the perf
> errata on nehalem have been on counter0.  Or maybe I can get 'perf top' to
> use something other than counter0 by running 'perf record' first?
> 
> Cheers,
> Don
> 
> > 
> > 	-- Cyrill
> 

Well, I never looked deep inside perf tool code itself. Perhaps the easiest
(if you want to disable counter0) is just disable it in kernel and see how
it goes, no?

	-- Cyrill
