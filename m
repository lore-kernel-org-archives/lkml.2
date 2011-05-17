Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919Ab1EQNEV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 09:04:21 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50677 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754487Ab1EQNET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 09:04:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=PXKCjtdkOJeWEAeaNNVG2aHr5Y41qrbR2t2UCHxdp1ntU5p+0FUe9NPhqUDbFvFUx1
         AnYBZE+ribxVajpZhcykEDXo5GlRMCwBdztZ8OAKahcx+fgEjXtTsOlZ1dZ7U4YE71LY
         Rqjl2lCda2PtH2UhkrtP4rDEKtxYU8dN2ilMo=
Date: Tue, 17 May 2011 15:04:14 +0200
From: Tejun Heo <tj@kernel.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Shaohua Li <shaohua.li@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "cl@linux.com" <cl@linux.com>, "npiggin@kernel.dk" <npiggin@kernel.dk>
Subject: Re: [patch V3] percpu_counter: scalability works
Message-ID: <20110517130414.GO20624@htj.dyndns.org>
References: <1305593751.2375.69.camel@sli10-conroe>
 <1305608212.9466.45.camel@edumazet-laptop>
 <1305609768.2375.84.camel@sli10-conroe>
 <1305622861.2850.21.camel@edumazet-laptop>
 <20110517091102.GE20624@htj.dyndns.org>
 <1305625541.2850.29.camel@edumazet-laptop>
 <20110517095001.GF20624@htj.dyndns.org>
 <1305634807.2850.89.camel@edumazet-laptop>
 <20110517124528.GN20624@htj.dyndns.org>
 <1305637223.2850.95.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305637223.2850.95.camel@edumazet-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, May 17, 2011 at 03:00:23PM +0200, Eric Dumazet wrote:
> Absolutely not. Its slow path yes, but not super-slow.

I was speaking in relative terms.  We're talking about local only fast
path vs. something which hits every percpu counter likely causing
cache misses in many of them.  It's bound to be multiple orders of
magnitude heavier than fast path.

Thanks.

-- 
tejun
