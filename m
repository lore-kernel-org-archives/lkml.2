Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756789Ab2DFAV5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 20:21:57 -0400
Received: from casper.infradead.org ([85.118.1.10]:54684 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756562Ab2DFAV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 20:21:56 -0400
Message-ID: <4F7E371B.8010605@kernel.dk>
Date: Thu, 05 Apr 2012 18:21:47 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Asai Thambi S P <asamymuthupa@micron.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sam Bradshaw <sbradshaw@micron.com>
Subject: Re: [PATCH 0/5] mtip32xx: Add support for device status and some
 optimitizations
References: <4F7E07BB.4080507@micron.com>
In-Reply-To: <4F7E07BB.4080507@micron.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-04-05 14:59, Asai Thambi S P wrote:
> 
> This patchset adds support for new sysfs entry 'status', fix in restart port,
> and some optimizations like merging various flag variables. 
> 
> Asai Thambi S P (5):
>   mtip32xx: Add new bitwise flag 'dd_flag' and make set comp_time as
>     common
>   mtip32xx: Add new sysfs entry 'status' and fix restart port
>   mtip32xx: Shorten macro names
>   mtip32xx: handling of commands in various scenarios
>   mtip32xx: dump tagmap on failure
> 
>  drivers/block/mtip32xx/mtip32xx.c |  844 +++++++++++++++++++++++++++++--------
>  drivers/block/mtip32xx/mtip32xx.h |   58 ++-
>  2 files changed, 702 insertions(+), 200 deletions(-)

These are not applying to for-3.4/drivers, so I can't apply them as-is.

-- 
Jens Axboe

