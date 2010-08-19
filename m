Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567Ab0HSOwQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 10:52:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:58174 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406Ab0HSOwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 10:52:14 -0400
Message-ID: <4C6D4439.3080007@kernel.org>
Date: Thu, 19 Aug 2010 16:48:25 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] percpu: Fix memory leak from percpu_init_late()
References: <20100819144956.27058.69126.stgit@e102109-lin.cambridge.arm.com>
In-Reply-To: <20100819144956.27058.69126.stgit@e102109-lin.cambridge.arm.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 19 Aug 2010 14:52:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19/2010 04:49 PM, Catalin Marinas wrote:
> The chunk->map memory block allocated in percpu_init_late() (as of
> commit 099a19d9) is later overridden in pcpu_extend_area_map(). The
> patch frees this existing block in the latter function. Found by
> kmemleak.
> 
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Tejun Heo <tj@kernel.org>

Patch already pending

 http://git.kernel.org/?p=linux/kernel/git/tj/percpu.git;a=commit;h=206c53730b8b1707becca7a868ea8d14ebee24d2

Thanks.

-- 
tejun
