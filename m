Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761015Ab1D3A2x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 20:28:53 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:35840 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760064Ab1D3A2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 20:28:50 -0400
Date: Fri, 29 Apr 2011 20:28:47 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
X-X-Sender: nico@xanadu.home
To: Grant Likely <grant.likely@secretlab.ca>
cc: devicetree-discuss@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 5/8] arm/dt: Drop irq_create_of_mapping() from arm
 code.
In-Reply-To: <20110429071553.12522.65073.stgit@ponder>
Message-ID: <alpine.LFD.2.00.1104292027560.24613@xanadu.home>
References: <20110429070135.12522.35745.stgit@ponder> <20110429071553.12522.65073.stgit@ponder>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Apr 2011, Grant Likely wrote:

> It is now implemented by core code.
> 
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> ---
>  arch/arm/kernel/devtree.c |   14 --------------
>  1 files changed, 0 insertions(+), 14 deletions(-)

Maybe this should be folded in the patch that introduced this instead?


Nicolas
