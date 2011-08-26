Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276Ab1HZOVM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 10:21:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30252 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899Ab1HZOVK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 10:21:10 -0400
Date: Fri, 26 Aug 2011 16:18:01 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        Dave Martin <dave.martin@linaro.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: Re: [PATCH v2 03/43] arm: Use set_current_blocked() and
	block_sigmask()
Message-ID: <20110826141801.GA14276@redhat.com>
References: <1313772419-21951-1-git-send-email-matt@console-pimps.org> <1313772419-21951-4-git-send-email-matt@console-pimps.org> <20110825171556.GH27143@e102144-lin.cambridge.arm.com> <1314353194.17145.9.camel@mfleming-mobl1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314353194.17145.9.camel@mfleming-mobl1.ger.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26, Matt Fleming wrote:
>
> On Thu, 2011-08-25 at 18:15 +0100, Will Deacon wrote:
> > Ok. Looks like the only change from v1 is calling block_sigmask. which does
> > what was previously done inline (in v1).
> >
> > So you can keep my ack if you like!
>
> Thanks!

Yes, thanks.

> Oleg, could you add Will's Acked-by?

Ooooh. Will, Matt, I really hope you won't insist. The problem is,
I already pushed these changes, I'd like to avoid another test of
my poor git skills ;)

Oleg.

