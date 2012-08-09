Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480Ab2HIVRd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 17:17:33 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:59160 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753742Ab2HIVRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 17:17:32 -0400
Date: Thu, 9 Aug 2012 22:17:17 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        arm@kernel.org, linux-kernel@vger.kernel.org,
        Dave Martin <dave.martin@linaro.org>
Subject: Re: [PATCH 04/10] ARM: pass -marm to gcc by default
Message-ID: <20120809211717.GW18957@n2100.arm.linux.org.uk>
References: <1344461278-28245-1-git-send-email-arnd@arndb.de> <1344461278-28245-5-git-send-email-arnd@arndb.de> <alpine.LFD.2.02.1208091709010.5231@xanadu.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1208091709010.5231@xanadu.home>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09, 2012 at 05:12:58PM -0400, Nicolas Pitre wrote:
> CFLAGS_THUMB2 should probably be renamed to something more appropriate 
> in this case, e.g. CFLAGS_MODE.

CFLAGS_ISA would be more relevant to it, because it's selecting the
instruction set.
