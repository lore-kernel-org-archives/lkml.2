Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759494Ab2HJJ7Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 05:59:25 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:40078 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759333Ab2HJJ7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 05:59:23 -0400
Date: Fri, 10 Aug 2012 10:59:11 +0100
From: Dave Martin <dave.martin@linaro.org>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        arm@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/10] ARM: pass -marm to gcc by default
Message-ID: <20120810095911.GA2157@linaro.org>
References: <1344461278-28245-1-git-send-email-arnd@arndb.de>
 <1344461278-28245-5-git-send-email-arnd@arndb.de>
 <alpine.LFD.2.02.1208091709010.5231@xanadu.home>
 <20120809211717.GW18957@n2100.arm.linux.org.uk>
 <alpine.LFD.2.02.1208091721460.5231@xanadu.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1208091721460.5231@xanadu.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09, 2012 at 05:22:30PM -0400, Nicolas Pitre wrote:
> On Thu, 9 Aug 2012, Russell King - ARM Linux wrote:
> 
> > On Thu, Aug 09, 2012 at 05:12:58PM -0400, Nicolas Pitre wrote:
> > > CFLAGS_THUMB2 should probably be renamed to something more appropriate 
> > > in this case, e.g. CFLAGS_MODE.
> > 
> > CFLAGS_ISA would be more relevant to it, because it's selecting the
> > instruction set.
> 
> Agreed.  This particular TLA escaped my mind somehow.

Seems fair enough.  It doesn't quite match the official architectural
terminology, but it clear enough what it means, and less cumbersome than
the alternatives.

Best not to use MODE though.  That word is way too overloaded.

---Dave

