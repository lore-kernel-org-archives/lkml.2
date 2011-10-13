Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216Ab1JMVFX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 17:05:23 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:37382 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635Ab1JMVFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 17:05:22 -0400
Date: Thu, 13 Oct 2011 17:05:19 -0400 (EDT)
Message-Id: <20111013.170519.1844447293057298087.davem@davemloft.net>
To: bzolnier@gmail.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] icside: DMA support fix
From: David Miller <davem@davemloft.net>
In-Reply-To: <201110121645.47490.bzolnier@gmail.com>
References: <201110111933.48430.bzolnier@gmail.com>
	<20111011.145523.1844316617273586111.davem@davemloft.net>
	<201110121645.47490.bzolnier@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 13 Oct 2011 14:05:20 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date: Wed, 12 Oct 2011 16:45:34 +0200

> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH v2] icside: DMA support fix
> 
> Fix problem introduced by commit 5e37bdc ("ide: add struct
> ide_dma_ops (take 3)"): d.dma_ops shouldn't be cleared if
> we are going to use DMA.
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Applied.
