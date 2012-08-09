Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723Ab2HIVWe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 17:22:34 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:35942 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447Ab2HIVWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 17:22:33 -0400
Date: Thu, 9 Aug 2012 17:22:30 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        arm@kernel.org, linux-kernel@vger.kernel.org,
        Dave Martin <dave.martin@linaro.org>
Subject: Re: [PATCH 04/10] ARM: pass -marm to gcc by default
In-Reply-To: <20120809211717.GW18957@n2100.arm.linux.org.uk>
Message-ID: <alpine.LFD.2.02.1208091721460.5231@xanadu.home>
References: <1344461278-28245-1-git-send-email-arnd@arndb.de> <1344461278-28245-5-git-send-email-arnd@arndb.de> <alpine.LFD.2.02.1208091709010.5231@xanadu.home> <20120809211717.GW18957@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Aug 2012, Russell King - ARM Linux wrote:

> On Thu, Aug 09, 2012 at 05:12:58PM -0400, Nicolas Pitre wrote:
> > CFLAGS_THUMB2 should probably be renamed to something more appropriate 
> > in this case, e.g. CFLAGS_MODE.
> 
> CFLAGS_ISA would be more relevant to it, because it's selecting the
> instruction set.

Agreed.  This particular TLA escaped my mind somehow.


Nicolas
