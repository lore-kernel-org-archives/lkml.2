Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184Ab1KJV7f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 16:59:35 -0500
Received: from relais.videotron.ca ([24.201.245.36]:53007 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101Ab1KJV7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 16:59:34 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; CHARSET=US-ASCII
Date: Thu, 10 Nov 2011 16:59:33 -0500 (EST)
From: Nicolas Pitre <nico@fluxnic.net>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 08/16] ARM: LPAE: Page table maintenance for the 3-level
 format
In-reply-to: <1320682618-1182-9-git-send-email-catalin.marinas@arm.com>
Message-id: <alpine.LFD.2.02.1111101654400.3307@xanadu.home>
References: <1320682618-1182-1-git-send-email-catalin.marinas@arm.com>
 <1320682618-1182-9-git-send-email-catalin.marinas@arm.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Nov 2011, Catalin Marinas wrote:

> This patch modifies the pgd/pmd/pte manipulation functions to support
> the 3-level page table format. Since there is no need for an 'ext'
> argument to cpu_set_pte_ext(), this patch conditionally defines a
> different prototype for this function when CONFIG_ARM_LPAE.

Maybe it doesn't make sense to still call it cpu_set_pte_ext then?


Nicolas
