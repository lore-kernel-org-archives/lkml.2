Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752273Ab1LAJ1Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 04:27:25 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:35465 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751226Ab1LAJ1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 04:27:24 -0500
Date: Thu, 1 Dec 2011 09:26:54 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Frank Rowand <frank.rowand@am.sony.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC PATCH 0/6] ARM: Remove the
 __ARCH_WANT_INTERRUPTS_ON_CTXSW definition
Message-ID: <20111201092654.GB27394@arm.com>
References: <1322569352-23584-1-git-send-email-catalin.marinas@arm.com>
 <4ED6F0FD.1080702@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ED6F0FD.1080702@am.sony.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 01, 2011 at 03:14:05AM +0000, Frank Rowand wrote:
> On 11/29/11 04:22, Catalin Marinas wrote:
> > Hi,
> > 
> > This set of patches removes the use of __ARCH_WANT_INTERRUPTS_ON_CTXSW
> > on ARM.
> 
> All 6 patches:
> 
> Reviewed-by: Frank Rowand <frank.rowand@am.sony.com>

Thanks.

-- 
Catalin
