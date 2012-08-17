Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050Ab2HQJFE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 05:05:04 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:37784 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980Ab2HQJEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 05:04:55 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19fibSF2VFWn44Ie/7hHrXC
Date: Fri, 17 Aug 2012 02:04:52 -0700
From: Tony Lindgren <tony@atomide.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v2 04/31] arm64: MMU definitions
Message-ID: <20120817090451.GP11011@atomide.com>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com>
 <1344966752-16102-5-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344966752-16102-5-git-send-email-catalin.marinas@arm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Catalin Marinas <catalin.marinas@arm.com> [120814 10:57]:
> The virtual memory layout is described in
> Documentation/arm64/memory.txt. This patch adds the MMU definitions for
> the 4KB and 64KB translation table configurations. The SECTION_SIZE is
> 2MB with 4KB page and 512MB with 64KB page configuration.
> 
> PHYS_OFFSET is calculated at run-time and stored in a variable (no
> run-time code patching at this stage).

Care to clarify this part a bit? Is the memory standardized somehow
now and not needed? Or do we still need to add that for various SoCs
later on?

Other than that:

Acked-by: Tony Lindgren <tony@atomide.com>
