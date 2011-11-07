Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752390Ab1KGVaz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 16:30:55 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:50285 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856Ab1KGVay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 16:30:54 -0500
Date: Mon, 7 Nov 2011 14:30:53 -0700 (MST)
From: Paul Walmsley <paul@pwsan.com>
To: Felipe Balbi <balbi@ti.com>
cc: Tony Lindgren <tony@atomide.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] arm: omap2+: hwmod: fix breakage introduced by
 d6504acd
In-Reply-To: <1320688617-4543-1-git-send-email-balbi@ti.com>
Message-ID: <alpine.DEB.2.00.1111071429530.12394@utopia.booyaka.com>
References: <1320688617-4543-1-git-send-email-balbi@ti.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Nov 2011, Felipe Balbi wrote:

> commit d6504acd (OMAP2+: hwmod: remove OMAP_CHIP*) has
> mistakenly added MUSB as a hwmod available only on ES2.0
> of OMAP3430.
> 
> MUSB hwmod has always be available on all OMAP revisions
> since OMAP2430.

Are you sure about this?  I don't see it in my 3430ES1 TRM text.


- Paul
