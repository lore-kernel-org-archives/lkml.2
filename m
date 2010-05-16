Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636Ab0EPCgt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 22:36:49 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:53391 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131Ab0EPCgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 22:36:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=feAd09K3oqS0fbxpuVodmu/LqiPh6Wa07+sah3V8LAuC+GblMJLAWQxT8VaXdD4VYz
         n5ym92p9Surfd9UWuWsqxMkLw1/l+E+bC4Kw4pZxMuNnsN58KBOOSv2Pr2qaDV1BcW27
         daH4VKkWpogHvrz5URo32RKGfyyszLsfZaiII=
Date: Sun, 16 May 2010 04:36:49 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Don Zickus <dzickus@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Cyrill Gorcunov <gorcunov@gmail.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [GIT PULL] Lockup detector build fixes
Message-ID: <20100516023648.GD7645@nowhere>
References: <20100515073732.GA17120@elte.hu> <1273977240-30800-1-git-send-regression-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273977240-30800-1-git-send-regression-fweisbec@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 16, 2010 at 04:33:56AM +0200, Frederic Weisbecker wrote:
> Ingo,
> 
> Please pull the perf/nmi branch that can be found at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> 	perf/nmi
> 
> Thanks,
> 	Frederic


Tested on x86 and Sparc 64 with and without CONFIG_LOCKUP_DETECTOR.
No problem so far. Tell me if you find any.

