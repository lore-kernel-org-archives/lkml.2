Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756896Ab1HEQXa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 12:23:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33183 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756839Ab1HEQX0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 12:23:26 -0400
Message-ID: <4E3C18D7.9070303@zytor.com>
Date: Fri, 05 Aug 2011 09:22:47 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Jinyoung Park <jinyoungp@nvidia.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: aat2870 causes build failure in current upstream
References: <4E385B53.3040108@zytor.com> <20110804171725.GA12729@elte.hu> <4E3B87C2.3020304@nvidia.com>
In-Reply-To: <4E3B87C2.3020304@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04/2011 11:03 PM, Jinyoung Park wrote:
> Hi,
> 
> I try to check allmodconfig error issue for aat2870 backlight driver.
> But I could not observing error message what you attached, building is
> successed.
> Please let me know how to reproduce allmodconfig problem for aat2870
> backlight driver.
> 
> This is my repro step.
> $ git clone
> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
> $ cd linux-next
> $ make allmodconfig
> $ make
> 
> Thanks,
> Jin.
> 

Get Linus' current tree, not linux-next.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

