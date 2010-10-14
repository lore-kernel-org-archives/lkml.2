Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671Ab0JNFBW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 01:01:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:56971 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754259Ab0JNFBV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 01:01:21 -0400
Message-ID: <4CB68E8A.9000008@kernel.org>
Date: Thu, 14 Oct 2010 07:00:58 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        linux-kernel@vger.kernel.org, 2nddept-manager@sdl.hitachi.co.jp,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH -tip  3/5] Define __stop_machine when CONFIG_STOP_MACHINE=n
References: <20101014031011.4100.32343.stgit@ltc236.sdl.hitachi.co.jp> <20101014031030.4100.34156.stgit@ltc236.sdl.hitachi.co.jp>
In-Reply-To: <20101014031030.4100.34156.stgit@ltc236.sdl.hitachi.co.jp>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 14 Oct 2010 05:01:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2010 05:10 AM, Masami Hiramatsu wrote:
> Define dummy __stop_machine() function even when CONFIG_STOP_MACHINE=n.
> This getcpu-required version of stop_machine() will be used from
> poke_text_smp().
> 
> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: linux-kernel@vger.kernel.org

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
