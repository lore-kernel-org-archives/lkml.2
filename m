Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641Ab0H0TfF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 15:35:05 -0400
Received: from void.printf.net ([89.145.121.20]:49150 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752164Ab0H0TfD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 15:35:03 -0400
Date: Fri, 27 Aug 2010 20:34:57 +0100
From: Chris Ball <cjb@laptop.org>
To: Nicolas Ferre <nicolas.ferre@atmel.com>, akpm@linux-foundation.org
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, wolfgang.mues@auerswald.de,
        avictor.za@gmail.com
Subject: Re: [PATCH 1/7] mmc: at91_mci: fix pointer errors
Message-ID: <20100827193457.GC23079@void.printf.net>
References: <9535dc8dfe4476a0314b9513fb9d37862faa731d.1267209149.git.nicolas.ferre@atmel.com> <20100827193303.GB23079@void.printf.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100827193303.GB23079@void.printf.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 27, 2010 at 08:33:03PM +0100, Chris Ball wrote:
> Looks like only the first half of this patch was applied?  The
> kunmap_atomic() line is still present as before in Linus' tree. 

Might be related to Dan Carpenter's suggestion that the spacing for that
line should change to:

	kunmap_atomic(((void *)sgbuffer) - sg->offset, KM_BIO_SRC_IRQ);

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
