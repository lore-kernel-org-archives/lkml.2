Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757483Ab2IUSPW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 14:15:22 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:61987 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754948Ab2IUSPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 14:15:19 -0400
Date: Fri, 21 Sep 2012 14:15:17 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Cyril Chemparathy <cyril@ti.com>
cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        arnd@arndb.de, catalin.marinas@arm.com, grant.likely@secretlab.ca,
        linux@arm.linux.org.uk, will.deacon@arm.com
Subject: Re: [PATCH v3 03/17] ARM: use late patch framework for phys-virt
 patching
In-Reply-To: <1347385155-11643-4-git-send-email-cyril@ti.com>
Message-ID: <alpine.LFD.2.02.1209211411140.6667@xanadu.home>
References: <1347385155-11643-1-git-send-email-cyril@ti.com> <1347385155-11643-4-git-send-email-cyril@ti.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Sep 2012, Cyril Chemparathy wrote:

> This patch replaces the original physical offset patching implementation
> with one that uses the newly added patching framework.
> 
> Signed-off-by: Cyril Chemparathy <cyril@ti.com>

Please also remove the MODULE_ARCH_VERMAGIC_P2V entirely from module.h 
in this patch.  This corresponds to the old patch table format which is 
no longer supported once this patch is applied.  The new mechanism is 
covered by MODULE_ARCH_VERMAGIC_RT_PATCH already.

Once that is done, you may add...

Reviewed-by: Nicolas Pitre <nico@linaro.org>


Nicolas
