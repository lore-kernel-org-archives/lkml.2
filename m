Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931Ab0EZNGV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 09:06:21 -0400
Received: from [18.85.46.34] ([18.85.46.34]:37064 "EHLO bombadil.infradead.org"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752691Ab0EZNGU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 09:06:20 -0400
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
From: Peter Zijlstra <peterz@infradead.org>
To: Florian Mickler <florian@mickler.org>
Cc: felipe.balbi@nokia.com, Vitaly Wool <vitalywool@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Paul@smtp1.linux-foundation.org" <Paul@smtp1.linux-foundation.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
In-Reply-To: <20100526145452.685337db@schatten.dmk.lab>
References: <1274863655.5882.4875.camel@twins>
	 <AANLkTinN6MKvCEhPkbYQRD2gu-mGXdNW9asRsTuKN3_Y@mail.gmail.com>
	 <1274867106.5882.5090.camel@twins>
	 <20100526120242.5c9b73ad@schatten.dmk.lab>
	 <AANLkTim4021cTnhVZrQpefq1MG-eEPOFLDRO-XDepHb4@mail.gmail.com>
	 <20100526133721.602633b2@schatten.dmk.lab>
	 <AANLkTikzgaOFdQKess4E-D86OLPOzxP3dWiDkU_UR0ri@mail.gmail.com>
	 <20100526142430.327ccbc4@schatten.dmk.lab>
	 <20100526122932.GB1990@nokia.com>
	 <20100526143323.7c6f8705@schatten.dmk.lab>
	 <20100526123532.GA2629@nokia.com>
	 <20100526145452.685337db@schatten.dmk.lab>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 26 May 2010 15:06:17 +0200
Message-ID: <1274879177.27810.386.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-26 at 14:54 +0200, Florian Mickler wrote:

> It really comes down to a policy decision by the distribution maker.
> And I don't think kernel upstream should be the one to force one way or
> the other.

That's exactly what we always do. If we were not to do so, the kernel
would be a bloated incoherent piece of crap.

>  So merging this patch set will allow android to continue
> their work _on mainline_ while everybody else can continue as before.

> Nonetheless, I really think the kernel needs to allow for the android
> way of power saving. It misses out on a big feature and a big user-base
> if not.

I really think we should not do so. Let them help in fixing the real
issue instead of creating a new class of userspace that is more
important than another.

> But look at it this way: Suspend blockers are a way for the kernel
> to make user space programs accountable for using the resource "power".

How is userspace without suspend blockers not accountable? We can easily
account runtime and in fact have several ways to do so.
