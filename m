Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114Ab1DOO2b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 10:28:31 -0400
Received: from 8bytes.org ([88.198.83.132]:50390 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755089Ab1DOO2a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 10:28:30 -0400
Date: Fri, 15 Apr 2011 16:28:29 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Andreas Herrmann <herrmann.der.user@googlemail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Alex Deucher <alexdeucher@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>,
        alexandre.f.demers@gmail.com
Subject: Re: Linux 2.6.39-rc3
Message-ID: <20110415142829.GL18463@8bytes.org>
References: <20110413193459.GL19819@8bytes.org> <4DA60C30.4060606@kernel.org> <BANLkTik7W0u92n_s0t32dsoLULu4QTZneA@mail.gmail.com> <4DA6145D.9070703@kernel.org> <BANLkTinud+4nUkZtnYRrU_gAFaMDWRa_AA@mail.gmail.com> <4DA655E7.3000904@zytor.com> <BANLkTimqR_M5keMqr5WAuz-t+1BkCZbwCg@mail.gmail.com> <BANLkTincU4rM+SqhzGOK_Rgxgg8fqJOOdQ@mail.gmail.com> <20110415131152.GJ18463@8bytes.org> <20110415140445.GA4883@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110415140445.GA4883@alberich.amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 15, 2011 at 04:04:45PM +0200, Andreas Herrmann wrote:
> What about tagging this patch for stable/longterm releases?
> 
> Potentially there are other cases where certain combinations of
> hardware(GPUs)/drivers/whatsoever might trigger a GartTlbWlkErr. If
> the BIOS doesn't follow the BKDG recommendation to mask these errors,
> the system will hang/reboot. Thus I think having this quirk in .32 and
> .38 (at least) is useful.

Right, thats certainly a good idea. The problem is not specific to GPUs,
any other device can trigger this too.

	Joerg

