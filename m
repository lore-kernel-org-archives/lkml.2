Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762Ab2COGPP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 02:15:15 -0400
Received: from linux-sh.org ([111.68.239.195]:46937 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752672Ab2COGPM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 02:15:12 -0400
Date: Thu, 15 Mar 2012 15:14:50 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/7] arch/sh/drivers/dma/{dma-g2,dmabrg}.c: ensure arguments to request_irq and free_irq are compatible
Message-ID: <20120315061450.GC10046@linux-sh.org>
References: <1331494587-12196-1-git-send-email-Julia.Lawall@lip6.fr> <1331494587-12196-5-git-send-email-Julia.Lawall@lip6.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331494587-12196-5-git-send-email-Julia.Lawall@lip6.fr>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 11, 2012 at 08:36:24PM +0100, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Convert calls to free_irq so that the second argument is the same as the
> last argument of the corresponding call to request_irq.  Without this
> property, free_irq does nothing.
> 
> In the case of dmabrg.c the change is merely cosmetic - changing 0 to NULL.
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> 
Applied, thanks.
