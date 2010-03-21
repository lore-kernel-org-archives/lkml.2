Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751971Ab0CUIau (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 04:30:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:51854 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361Ab0CUIas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 04:30:48 -0400
Subject: Re: [PATCH 01/24] mtd/maps/pismo: remove dangling pointer and a
	leak
From: David Woodhouse <dwmw2@infradead.org>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Wolfram Sang <w.sang@pengutronix.de>,
       "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
       "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
       "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20100320154113.GB14470@flint.arm.linux.org.uk>
References: <1269094385-16114-1-git-send-email-w.sang@pengutronix.de>
	 <1269094385-16114-2-git-send-email-w.sang@pengutronix.de>
	 <20100320145729.GA5399@flint.arm.linux.org.uk>
	 <20100320153146.GB5515@pengutronix.de>
	 <20100320154113.GB14470@flint.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 21 Mar 2010 08:30:41 +0000
Message-ID: <1269160241.4028.9777.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-03-20 at 15:41 +0000, Russell King wrote:
> 
> Thanks.
> 
> Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
> 
> David, are you going to pick this up? 

http://git.infradead.org/mtd-2.6.git/commitdiff/395b2288

Thanks.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

