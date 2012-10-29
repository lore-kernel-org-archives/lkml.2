Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757841Ab2J2GH4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 02:07:56 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34595 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757725Ab2J2GHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 02:07:49 -0400
Subject: Re: [PATCH 06/16] dma: Convert dev_printk(KERN_<LEVEL> to
 dev_<level>(
From: Vinod Koul <vkoul@infradead.org>
To: Joe Perches <joe@perches.com>
Cc: vinod.koul@intel.com, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Dan Williams <djbw@fb.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <cf922e807ca2ec44837ffc7a320851e9c5272d03.1351411047.git.joe@perches.com>
References: <cover.1351411047.git.joe@perches.com>
	 <cf922e807ca2ec44837ffc7a320851e9c5272d03.1351411047.git.joe@perches.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Oct 2012 11:24:35 +0530
Message-ID: <1351490075.7077.36.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-10-28 at 01:05 -0700, Joe Perches wrote:
> dev_<level> calls take less code than dev_printk(KERN_<LEVEL>
> and reducing object size is good.
> Coalesce formats for easier grep. 

Applied thanks

-- 
Vinod Koul
Intel Corp.

