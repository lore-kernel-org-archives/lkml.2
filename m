Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146Ab0JKUNi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 16:13:38 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:37055 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755940Ab0JKUNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 16:13:37 -0400
Date: Mon, 11 Oct 2010 21:13:35 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH V5 0/7] Generalise ARM perf-events backend for oprofile
Message-ID: <20101011201335.GB14561@console-pimps.org>
References: <cover.1286584677.git.matt@console-pimps.org>
 <20101011185923.GW13563@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101011185923.GW13563@erda.amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 11, 2010 at 08:59:23PM +0200, Robert Richter wrote:
> 
> Thanks Matt, I applied your patches to the oprofile tree and merged
> them with the core branch. As I already wrote, I modified patch #4 to
> fix the compile breakage.
> 
> The patches are available for testing in
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git core
> 
> Thanks again,
> 
> -Robert

Thanks Robert, I've just read through the merge and it looks good!
