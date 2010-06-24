Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565Ab0FXJI6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 05:08:58 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:43719 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754191Ab0FXJI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 05:08:57 -0400
Subject: Re: [PATCH 2/3] ARM: module - simplify unwind table handling
From: Catalin Marinas <catalin.marinas@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Phil Carmody <ext-phil.2.carmody@nokia.com>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <20100624090502.GA1398@n2100.arm.linux.org.uk>
References: <1275567442-11370-1-git-send-email-ext-phil.2.carmody@nokia.com>
	 <1275567442-11370-2-git-send-email-ext-phil.2.carmody@nokia.com>
	 <1275567442-11370-3-git-send-email-ext-phil.2.carmody@nokia.com>
	 <20100624090502.GA1398@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Organization: ARM Limited
Date: Thu, 24 Jun 2010 10:08:47 +0100
Message-ID: <1277370527.31432.0.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Jun 2010 09:08:47.0888 (UTC) FILETIME=[DADB7900:01CB137C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-24 at 10:05 +0100, Russell King - ARM Linux wrote:
> On Thu, Jun 03, 2010 at 03:17:21PM +0300, Phil Carmody wrote:
> >  #ifdef CONFIG_ARM_UNWIND
> ...
> > +#else
> > +struct mod_arch_specific {
> > +}
> > +#endif
> 
> I assume no one tried building these with UNWIND disabled?  linux-next
> reports most ARM builds are broken by this.
> 
> Dropped all three patches out of my git tree until it can be fixed.

It looks like a patch for fixing the build was posted on the 16th of
June, though not sure whether it went to your patch system or not.

-- 
Catalin

