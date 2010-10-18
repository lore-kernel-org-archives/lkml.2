Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757142Ab0JRPsL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 11:48:11 -0400
Received: from canuck.infradead.org ([134.117.69.58]:37175 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755327Ab0JRPsK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 11:48:10 -0400
Subject: Re: [PATCH 0/3] Add OMAP hardware spinlock misc driver
From: Peter Zijlstra <peterz@infradead.org>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Hari Kanigeri <h-kanigeri2@ti.com>, Suman Anna <s-anna@ti.com>,
        Benoit Cousson <b-cousson@ti.com>, Tony Lindgren <tony@atomide.com>,
        Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>, akpm@linux-foundation.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
In-Reply-To: <AANLkTi=w1Ge_JV41dvj1uaoFBo=UfX4ZtuHT=G6Kx1dF@mail.gmail.com>
References: <1287387875-14168-1-git-send-email-ohad@wizery.com>
	 <1287406015.29097.1579.camel@twins>
	 <20101018133502.GA12449@n2100.arm.linux.org.uk>
	 <1287409417.29097.1598.camel@twins>
	 <tnxeibnh67q.fsf@e102109-lin.cambridge.arm.com>
	 <1287415929.29097.1616.camel@twins>
	 <AANLkTi=w1Ge_JV41dvj1uaoFBo=UfX4ZtuHT=G6Kx1dF@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 18 Oct 2010 17:48:00 +0200
Message-ID: <1287416880.1998.1927.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-18 at 17:35 +0200, Ohad Ben-Cohen wrote:
> On Mon, Oct 18, 2010 at 5:32 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > Sure, but you can 'easily' extend your coherency protocols with support
> 
> In our case, there are no coherency protocols supported between the
> A9, M3 and the DSP.

Sure, I got that, I was simply commenting on Catalin's statement that
cache coherency doesn't (need to) bring atomic modifications.


