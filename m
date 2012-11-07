Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934Ab2KGTAi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 14:00:38 -0500
Received: from casper.infradead.org ([85.118.1.10]:37064 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284Ab2KGTAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 14:00:37 -0500
Message-ID: <509AAFD1.9040408@kernel.dk>
Date: Wed, 07 Nov 2012 20:00:33 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Selvan Mani <smani@micron.com>
CC: sbradshaw@micron.com, asamymuthupa@micron.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] mtip32xx: Few small fixes
References: <509A5ABF.80804@micron.com>
In-Reply-To: <509A5ABF.80804@micron.com>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-11-07 13:57, Selvan Mani wrote:
> Hi Jens,
> 
> Few more minor fixes for 3.7.
> 
> This patchset contains fix for the lba address problem in big-endian, potential 
> crash on secure erase operation and incorrect erase mode mask
> 
> Asai Thambi S P (3):
>   mtip32xx: fix potential crash on SEC_ERASE_UNIT
>   mtip32xx: Fix to make lba address correct in big-endian systems
>   mtip32xx: Fix incorrect mask used for erase mode
> 
>  drivers/block/mtip32xx/mtip32xx.c |   12 ++++++++----
>  drivers/block/mtip32xx/mtip32xx.h |    2 +-
>  2 files changed, 9 insertions(+), 5 deletions(-)

Thanks, all look sane, small, and tidy. Applied for this release series.

-- 
Jens Axboe

