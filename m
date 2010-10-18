Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756981Ab0JRPgM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 11:36:12 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:44088 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755550Ab0JRPgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 11:36:10 -0400
MIME-Version: 1.0
X-Originating-IP: [109.186.69.160]
In-Reply-To: <1287415929.29097.1616.camel@twins>
References: <1287387875-14168-1-git-send-email-ohad@wizery.com>
 <1287406015.29097.1579.camel@twins> <20101018133502.GA12449@n2100.arm.linux.org.uk>
 <1287409417.29097.1598.camel@twins> <tnxeibnh67q.fsf@e102109-lin.cambridge.arm.com>
 <1287415929.29097.1616.camel@twins>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Mon, 18 Oct 2010 17:35:49 +0200
Message-ID: <AANLkTi=w1Ge_JV41dvj1uaoFBo=UfX4ZtuHT=G6Kx1dF@mail.gmail.com>
Subject: Re: [PATCH 0/3] Add OMAP hardware spinlock misc driver
To: Peter Zijlstra <peterz@infradead.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Hari Kanigeri <h-kanigeri2@ti.com>, Suman Anna <s-anna@ti.com>,
        Benoit Cousson <b-cousson@ti.com>, Tony Lindgren <tony@atomide.com>,
        Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>, akpm@linux-foundation.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 18, 2010 at 5:32 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> Sure, but you can 'easily' extend your coherency protocols with support

In our case, there are no coherency protocols supported between the
A9, M3 and the DSP.
