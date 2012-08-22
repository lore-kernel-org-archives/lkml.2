Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965090Ab2HVTZf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 15:25:35 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:52980 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758943Ab2HVTZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 15:25:31 -0400
Date: Wed, 22 Aug 2012 21:25:25 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, mmarek@suse.cz,
        linux-kbuild@vger.kernel.org, JBeulich@suse.com,
        akpm@linux-foundation.org, Andi Kleen <ak@linux.intel.com>,
        Thomas Mingarelli <thomas.mingarelli@hp.com>
Subject: Re: [PATCH 38/74] lto, watchdog/hpwdt.c: Make assembler label global
Message-ID: <20120822192525.GE27604@spo001.leaseweb.com>
References: <1345345030-22211-1-git-send-email-andi@firstfloor.org> <1345345030-22211-39-git-send-email-andi@firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345345030-22211-39-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi andi,

> From: Andi Kleen <ak@linux.intel.com>
> 
> We cannot assume that the inline assembler code always ends up
> in the same file as the original C file. So make any assembler labels
> that are called with "extern" by C global
> 
> Cc: wim@iguana.be
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

You have my signed-off-by, but I'm Cc-ing also the author of the driver
(Tom Mingarelli) so that he is also aware of the proposed change.

Kind regards,
Wim.

