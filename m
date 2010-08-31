Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757068Ab0HaJbn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 05:31:43 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:59381 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756922Ab0HaJbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 05:31:42 -0400
Subject: Re: [PATCH 3/3] x86: oprofile: fix oprofile_arch_init behaviour on
 failure
From: Will Deacon <will.deacon@arm.com>
To: Robert Richter <robert.richter@amd.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Matt Fleming <matt@console-pimps.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20100831090518.GZ22783@erda.amd.com>
References: <1283107921-21464-1-git-send-email-will.deacon@arm.com>
	 <1283107921-21464-2-git-send-email-will.deacon@arm.com>
	 <1283107921-21464-3-git-send-email-will.deacon@arm.com>
	 <1283107921-21464-4-git-send-email-will.deacon@arm.com>
	 <20100830090929.GU22783@erda.amd.com>
	 <1283244880.645.17.camel@e102144-lin.cambridge.arm.com>
	 <20100831090518.GZ22783@erda.amd.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 31 Aug 2010 10:31:29 +0100
Message-ID: <1283247089.4063.2.camel@e102144-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 31 Aug 2010 09:31:33.0240 (UTC) FILETIME=[4CC2A780:01CB48EF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-31 at 10:05 +0100, Robert Richter wrote:
> On 31.08.10 04:54:40, Will Deacon wrote:
> > Do you think it would be better to rework this patch so that the static
> > using_nmi variable is set explicitly by init.c, or shall I just drop
> > this patch altogether (and resubmit the first two)?
> 
> For x86 wont change the code (actually I found a bug in the init_sysfs
> error handler for which I will send a fix). Just wanted to get your
> confirmation in case I was missing something that x86 is not affected.
> I will apply the first 2 patches, no need to resubmit.
> 
Ok, great. The commit comment might need tweaking for the first
patch now that the x86 code remains unchanged.

Cheers,

Will

