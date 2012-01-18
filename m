Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635Ab2ARCRf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 21:17:35 -0500
Received: from gate.crashing.org ([63.228.1.57]:55404 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756578Ab2ARCRe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 21:17:34 -0500
Message-ID: <1326853009.26116.30.camel@pasglop>
Subject: Re: [RFC 13/14] irq_domain: Remove 'new' irq_domain in favour of
 the ppc one
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Michael Bohan <mbohan@codeaurora.org>, Rob Herring <robherring2@gmail.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        linuxppc-dev@lists.ozlabs.org, Russell King <linux@arm.linux.org.uk>,
        sfr@canb.auug.org.au,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm@vger.kernel.org
Date: Wed, 18 Jan 2012 13:16:49 +1100
In-Reply-To: <CACxGe6ufk+BUoXZBKm5Q-O1Aj1j=18fJ5KjOC-fKQMbpw4z=mw@mail.gmail.com>
References: <1326313337-24603-1-git-send-email-grant.likely@secretlab.ca>
	 <1326313337-24603-14-git-send-email-grant.likely@secretlab.ca>
	 <4F0DFC0F.2090005@gmail.com>
	 <CACxGe6vVSO0cTgPurr6jFoo9QF_W02UaABOFYadCTQGU9dcwmg@mail.gmail.com>
	 <4F0F7B60.5040701@gmail.com> <4F14E05C.30207@codeaurora.org>
	 <1326771731.26116.29.camel@pasglop>
	 <CACxGe6ufk+BUoXZBKm5Q-O1Aj1j=18fJ5KjOC-fKQMbpw4z=mw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-01-17 at 17:28 -0700, Grant Likely wrote:
> BTW: Ben, if you can carve out some time, I'd appreciate a look over
> my series and make sure you're okay with it.  Once it's had some
> testing by arm and ppc folks, I want to get it into linux-next.

I intend to do so but not while I'm at LCA :-)

Cheers,
Ben.


