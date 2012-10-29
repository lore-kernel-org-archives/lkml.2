Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756710Ab2J2GGb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 02:06:31 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33722 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755019Ab2J2GGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 02:06:30 -0400
Subject: Re: [PATCH] dmaengine: use for_each_set_bit
From: Vinod Koul <vkoul@infradead.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: vinod.koul@intel.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, Dan Williams <djbw@fb.com>
In-Reply-To: <1351262115-2737-1-git-send-email-akinobu.mita@gmail.com>
References: <1351262115-2737-1-git-send-email-akinobu.mita@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Oct 2012 11:23:14 +0530
Message-ID: <1351489994.7077.33.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-26 at 23:35 +0900, Akinobu Mita wrote:
> Use for_each_set_bit() to implement for_each_dma_cap_mask() and
> remove unused first_dma_cap() and next_dma_cap(). 

Applied thanks
-- 
Vinod Koul
Intel Corp.

