Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157Ab1DOOdw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 10:33:52 -0400
Received: from 8bytes.org ([88.198.83.132]:57938 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756092Ab1DOOdv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 10:33:51 -0400
Date: Fri, 15 Apr 2011 16:33:50 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
        Alex Deucher <alexdeucher@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>,
        alexandre.f.demers@gmail.com
Subject: Re: Linux 2.6.39-rc3
Message-ID: <20110415143350.GM18463@8bytes.org>
References: <20110413193459.GL19819@8bytes.org> <4DA60C30.4060606@kernel.org> <BANLkTik7W0u92n_s0t32dsoLULu4QTZneA@mail.gmail.com> <4DA6145D.9070703@kernel.org> <BANLkTinud+4nUkZtnYRrU_gAFaMDWRa_AA@mail.gmail.com> <4DA655E7.3000904@zytor.com> <BANLkTimqR_M5keMqr5WAuz-t+1BkCZbwCg@mail.gmail.com> <BANLkTincU4rM+SqhzGOK_Rgxgg8fqJOOdQ@mail.gmail.com> <20110415131152.GJ18463@8bytes.org> <20110415131650.GB18660@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110415131650.GB18660@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 15, 2011 at 03:16:50PM +0200, Ingo Molnar wrote:
> Ok, but how did the allocation changes start triggering this error in 
> v2.6.39-rc1? There must still be some layout specific thing here, right?
> Do we understand the details of that as well?

No, I must admit that I lack enough knowledge about the GPU hardware to
make an guess how this tanslation-request happened. All I can tell is
the address that was reported in the MCE, it is 0xa0001000 (==the second
page of the GART aperture).

Maybe Alex can help here. Alex, may it be possible that the GPU
generates DMA requests in the GTT area before the GTT is activated (or
the activation is completed)? Or can you imagine any other reason?

	Joerg

