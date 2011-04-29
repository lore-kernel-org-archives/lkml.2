Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760935Ab1D2Tz6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 15:55:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33605 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759857Ab1D2Tz5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 15:55:57 -0400
Date: Fri, 29 Apr 2011 21:55:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Boris Ostrovsky <ostr@amd64.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, jvpeetz@web.de,
        borislav.petkov@amd.com, boris.ostrovsky@amd.com
Subject: Re: [PATCH] Subject: [PATCH] x86, AMD: K8 Rev.A-E processors are
 subject to erratum 400
Message-ID: <20110429195548.GA17166@elte.hu>
References: <1304106663-3720-1-git-send-email-ostr@amd64.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304106663-3720-1-git-send-email-ostr@amd64.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Boris Ostrovsky <ostr@amd64.org> wrote:

> Signed-off-by: Boris Ostrovsky <Boris.Ostrovsky@amd.com>
> Acked-by: Borislav Petkov <borislav.petkov@amd.com>
> Reported-by: Joerg-Volker Peetz <jvpeetz@web.de>
> Tested-by: Joerg-Volker Peetz <jvpeetz@web.de>
> 
> Older AMD K8 processors (Revisions A-E) are affected by erratum 400 (APIC 
> timer interrupts don't occur in C states greater than C1). This, for example, 
> means that X86_FEATURE_ARAT flag should not be set for these parts.
> 
> This addresses regression introduced by commit 
> b87cf80af3ba4b4c008b4face3c68d604e1715c6 (x86, AMD: Set ARAT feature on AMD 
> processors") so it is somewhat high priority.

Hm, what is the regression, how do users see it? Hangs? Delays? Crashes? 
Something more benign? The changelog should really contain such information.

Thanks,

	Ingo
