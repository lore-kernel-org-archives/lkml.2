Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752118Ab2GRJGw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 05:06:52 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:43538 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750939Ab2GRJGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 05:06:44 -0400
Date: Wed, 18 Jul 2012 10:06:26 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Will Deacon <Will.Deacon@arm.com>
Subject: Re: [PATCH 01/36] atomic64_test: Simplify the #ifdef for
 atomic64_dec_if_positive() test
Message-ID: <20120718090626.GA23190@arm.com>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
 <1341608777-12982-2-git-send-email-catalin.marinas@arm.com>
 <1342586037.3669.16.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342586037.3669.16.camel@pasglop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2012 at 05:33:57AM +0100, Benjamin Herrenschmidt wrote:
> On Fri, 2012-07-06 at 22:05 +0100, Catalin Marinas wrote:
> > This patch introduces ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE and uses this
> > instead of the multitude of #if defined() checks in atomic64_test.c
> > 
> > Signed-off-by: Will Deacon <will.deacon@arm.com>
> > Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> 
> I'll let other paint the bike shed as to whether ARCH_HAS_* is the right
> thing here, but as far as the powerpc change is concerned:
> 
> Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Thanks Ben. I followed Andrew's feedback to some other patches that Will
posted and moved the #define to Kconfig:

https://lkml.org/lkml/2012/7/17/382

I don't have any strong preference.

-- 
Catalin
