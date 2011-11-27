Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755027Ab1K0M5V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 07:57:21 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:62567 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752795Ab1K0M5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 07:57:20 -0500
Date: Sun, 27 Nov 2011 12:56:56 +0000
From: Will Deacon <will.deacon@arm.com>
To: Kautuk Consul <consul.kautuk@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1 v5] arm: fault.c: Port OOM changes into do_page_fault
Message-ID: <20111127125656.GA26042@mudshark.cambridge.arm.com>
References: <1321986690-6079-1-git-send-email-consul.kautuk@gmail.com>
 <20111126235032.GC9581@n2100.arm.linux.org.uk>
 <CAFPAmTTWVwq8H6HVzdvTcN-jcSoNQ2-TfLWT33ks8_kpGND+SA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFPAmTTWVwq8H6HVzdvTcN-jcSoNQ2-TfLWT33ks8_kpGND+SA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 27, 2011 at 05:58:33AM +0000, Kautuk Consul wrote:
> >
> > Thanks.  I think this is fine.  Please put it in the patch system so it's
> > not forgotten, and I'll get to it sometime during the next week.  Thanks.
> >
> 
> Thanks. I don't know what you mean by "put it in the patch system" as I already
> did a "git send-email" for this patch to this mailing list.
> 
> So, please find the v5 patch file attached to this email for any
> further reference.

You should read the documentation here:

http://www.arm.linux.org.uk/developer/patches/info.php

and then you can use git send-email --suppress-cc=all to email your patch to
the patch system, making sure you have the correct KernelVersion tag.

Will
