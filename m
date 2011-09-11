Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757940Ab1IKBHs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Sep 2011 21:07:48 -0400
Received: from mail-gw0-f42.google.com ([74.125.83.42]:45705 "EHLO
	mail-gw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754138Ab1IKBHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Sep 2011 21:07:47 -0400
Date: Sun, 11 Sep 2011 10:07:39 +0900
From: Tejun Heo <tj@kernel.org>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, x86@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        yinghai@kernel.org, bp@alien8.de
Subject: Re: [PATCH] arch/x86/mm/init_32.c: quiet sparse noise; local
 functions should be static
Message-ID: <20110911010739.GH29319@htj.dyndns.org>
References: <201109091609.23433.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201109091609.23433.hartleys@visionengravers.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 09, 2011 at 04:09:23PM -0700, H Hartley Sweeten wrote:
> Local functions should be marked static.  This quiets the following
> sparse noise:
> 
> warning: symbol 'lowmem_pfn_init' was not declared. Should it be static?
> warning: symbol 'highmem_pfn_init' was not declared. Should it be static?
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers,com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Yinghai Lu <yinghai@kernel.org>
> Cc: Borislav Petkov <bp@alien8.de> 

Looks good to me.

 Reviewed-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
