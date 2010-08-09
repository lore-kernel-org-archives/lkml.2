Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541Ab0HIRPK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 13:15:10 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54846 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706Ab0HIRPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 13:15:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=lEfwOLBVh2rK4xgYXUXZTT08XBf/QnNklR5aEkFVrvgSWUow91XGle7fJ9hZE1OYhz
         +1YoNUiz63QfXlpwjgyliDXCcqVC1oQ95b8f1BzqhKAGlpm3loaYJP4lpU6fsD5/j5Yf
         MQoukYsU4wFIrQn9e++4cD/zw0sMjwG7sagPY=
Date: Mon, 9 Aug 2010 19:14:42 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sparc64: Fix perf_arch_get_caller_regs().
Message-ID: <20100809171440.GB5329@nowhere>
References: <20100808.220450.148531617.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100808.220450.148531617.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 08, 2010 at 10:04:50PM -0700, David Miller wrote:
> 
> After b0f82b81fe6bbcf78d478071f33e44554726bc81 ("perf: Drop the skip
> argument from perf_arch_fetch_regs_caller") the build broke on sparc64
> due to the lack of a module symbol export of __perf_arch_fetch_caller_regs.
> 
> But that assembler helper can actually be complete eliminated now that
> the semantics of this interface have been greatly simplified.
> 
> Signed-off-by: David S. Miller <davem@davemloft.net>
> ---
> 
> Frederic, I'll merge this to Linus via the sparc tree, this is
> just FYI...



Ok thanks a lot! I have no more access to a Sparc box, so I'm
sorry I can't anymore test perf and ftrace on this architecture :)

