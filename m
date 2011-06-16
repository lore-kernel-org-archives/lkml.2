Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757675Ab1FPMPQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 08:15:16 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45389 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757535Ab1FPMPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 08:15:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=OJ3rx3jgu7PRRqQx9+C+IVGa8zY2W4SS7V7G/hD/P9GKezpKcYL2Xck3YQF5HHqSj8
         ni8KaGTasY8vtHgLp1Q2mw8X/oqBoVrlZhnK6f3FTAjCh5VDb4iZjaA9uKqcOAmmOyn7
         nVk+Qe0tafEaElXwH/0loHmcbaJIfyrDpmdDI=
Date: Thu, 16 Jun 2011 14:15:05 +0200
From: Tejun Heo <tj@kernel.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: x86@kernel.org, mingo@elte.hu, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, suresh.b.siddha@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET] stop_machine: implement
 stop_machine_from_offline_cpu()
Message-ID: <20110616121505.GB2611@htj.dyndns.org>
References: <1308071218-5912-1-git-send-email-tj@kernel.org>
 <1308226219.13240.41.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308226219.13240.41.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Peter.

On Thu, Jun 16, 2011 at 02:10:19PM +0200, Peter Zijlstra wrote:
> Maybe a silly question, but why does mtrr need all this? Surely mtrr can
> serialize state by other means than stopping all cpus. A simple mutex
> around the shared state blocking other cpus from updating the mtrr state
> while we're copying the state to our newly born cpu should cure things.

Hmmm... good question.  I don't know mtrr too well either but the
stop-machine requirement seems to directly come from intel's
specification.  I suppose Suresh can fill us in better.

Thanks.

-- 
tejun
