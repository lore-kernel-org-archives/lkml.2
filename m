Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875Ab0L3MsI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 07:48:08 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57511 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761Ab0L3MsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 07:48:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=W8/wwE1Jc406x14Y/k/h850D1aC5GlSwSGamM1qfrlQkZN0U22hhuVlHGXjLity8BO
         +hkyKqbywJPyTAMmd32AxKoRRsC+1Msx5Xl8DzTvEcCnh1eiU+AeD59mQXenRaS+0fK8
         2zMPtp24m+4fqqnYrkdY3GdcdqD/3DIHOhO28=
Date: Thu, 30 Dec 2010 13:48:00 +0100
From: Tejun Heo <tj@kernel.org>
To: David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        tglx@linutronix.de, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        eric.dumazet@gmail.com, yinghai@kernel.org, brgerst@gmail.com,
        gorcunov@gmail.com, Pekka Enberg <penberg@kernel.org>,
        shaohui.zheng@intel.com
Subject: Re: [PATCH 15/16] x86: Unify node_to_cpumask_map handling between
 32 and 64bit
Message-ID: <20101230124800.GD18831@htj.dyndns.org>
References: <1293536929-31683-1-git-send-email-tj@kernel.org>
 <1293536929-31683-16-git-send-email-tj@kernel.org>
 <alpine.DEB.2.00.1012281240000.8883@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1012281240000.8883@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 28, 2010 at 12:43:24PM -0800, David Rientjes wrote:
> This has been almost entirely rewritten in x86/numa by c1c3443c ("x86, 
> numa: Fake node-to-cpumask for NUMA emulation") and the pending fix 
> http://marc.info/?l=linux-kernel&m=129340072128297 ("x86, numa: Fix 
> CONFIG_DEBUG_PER_CPU_MAPS without NUMA").  Since this is only moving those 
> functions to numa.c, it should be trivial to fix once based on x86/numa.

Sigh, the new NUMA emulation thing is 64bit only. :-( I'll see if it
can be applied to 32bit too.  BTW, how does this interact with the
Shaohui's patchset.  Isn't that about NUMA emulation too?  Are these
the same patches?

Thanks.

-- 
tejun
