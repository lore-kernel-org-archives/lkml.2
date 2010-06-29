Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810Ab0F2URF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 16:17:05 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:37272 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750699Ab0F2URD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 16:17:03 -0400
From: Matt Fleming <matt@console-pimps.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       Lars-Peter Clausen <lars@metafoo.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-mmc@vger.kernel.org,
       Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH v3] MMC: Add JZ4740 mmc driver
In-Reply-To: <1277688041-23522-1-git-send-email-lars@metafoo.de>
References: <1276924111-11158-19-git-send-email-lars@metafoo.de> <1277688041-23522-1-git-send-email-lars@metafoo.de>
User-Agent: Notmuch/0.3.1-61-g3f63bb6 (http://notmuchmail.org) Emacs/23.1.90.2 (x86_64-unknown-linux-gnu)
Date: Tue, 29 Jun 2010 21:17:00 +0100
Message-ID: <87aaqd1tmr.fsf@linux-g6p1.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jun 2010 03:20:41 +0200, Lars-Peter Clausen <lars@metafoo.de> wrote:
> This patch adds support for the mmc controller on JZ4740 SoCs.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Matt Fleming <matt@console-pimps.org>
> Cc: linux-mmc@vger.kernel.org
> 
> ---
> Changes since v1
> - Do not request IRQ with IRQF_DISABLED since it is a noop now
> - Use a generous slack for the timeout timer. It does not need to be accurate.
> Changes since v2
> - Use sg_mapping_to iterate over sg elements in mmc read and write functions
> - Use bitops instead of a spinlock and a variable for testing whether a request
>   has been finished.
> - Rework irq and timeout handling in order to get rid of locking in hot paths

Acked-by: Matt Fleming <matt@console-pimps.org>

Are you planning on maintaining this driver? If so, it'd be a good idea
to update MAINTAINERS.
