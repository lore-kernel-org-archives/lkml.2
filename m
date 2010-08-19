Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986Ab0HSP7X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 11:59:23 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:49280 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751101Ab0HSP7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 11:59:20 -0400
Subject: Re: [PATCH] percpu: Fix memory leak from percpu_init_late()
From: Catalin Marinas <catalin.marinas@arm.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4C6D4439.3080007@kernel.org>
References: <4C6D4439.3080007@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Organization: ARM Limited
Date: Thu, 19 Aug 2010 16:59:14 +0100
Message-ID: <1282233554.20948.8.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Aug 2010 15:59:15.0462 (UTC) FILETIME=[792B0A60:01CB3FB7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-19 at 15:48 +0100, Tejun Heo wrote:
> On 08/19/2010 04:49 PM, Catalin Marinas wrote:
> > The chunk->map memory block allocated in percpu_init_late() (as of
> > commit 099a19d9) is later overridden in pcpu_extend_area_map(). The
> > patch frees this existing block in the latter function. Found by
> > kmemleak.
> >
> > Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> > Cc: Tejun Heo <tj@kernel.org>
> 
> Patch already pending
> 
> 
> http://git.kernel.org/?p=linux/kernel/git/tj/percpu.git;a=commit;h=206c53730b8b1707becca7a868ea8d14ebee24d2

Great, thanks, I'm dropping mine.

-- 
Catalin

