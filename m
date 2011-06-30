Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861Ab1F3PN2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 11:13:28 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36049 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751609Ab1F3PN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 11:13:26 -0400
Date: Thu, 30 Jun 2011 08:13:21 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] asm-generic: Raise default NR_IRQS when using sparse IRQs
Message-ID: <20110630151319.GA3249@opensource.wolfsonmicro.com>
References: <1309382426-30614-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <alpine.LFD.2.02.1106300926350.2917@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1106300926350.2917@ionos>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 30, 2011 at 09:27:20AM +0200, Thomas Gleixner wrote:
> On Wed, 29 Jun 2011, Mark Brown wrote:

> > Rather than have each platform using sparse IRQs pick a suitably large
> > NR_IRQS for use with sparse IRQs make the default high when they are
> > enabled.  We pick 64k as there is still a bitmap of IRQs that is
> > allocated statically, and as we all know 64k should be enough for
> > anyone.

> The sparse bitmap is overallocated to NR_IRQS + 8k anyway, so that's
> rather pointless.

Hrm, OK.  In that case why are platforms faffing around trying to size
NR_IRQs in the first place?
