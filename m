Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190Ab2IOWcS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2012 18:32:18 -0400
Received: from mga03.intel.com ([143.182.124.21]:55420 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751905Ab2IOWcR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2012 18:32:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,428,1344236400"; 
   d="scan'208";a="145472639"
Date: Sun, 16 Sep 2012 00:32:14 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: gregkh@linuxfoundation.org, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] mfd: MAX77693: Fix bug
Message-ID: <20120915223214.GF3647@sortiz-mobl>
References: <1345529747-24808-1-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345529747-24808-1-git-send-email-cw00.choi@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chanwoo,

On Tue, Aug 21, 2012 at 03:15:47PM +0900, Chanwoo Choi wrote:
> This patchset fix bug of Maxim MAX77693 chip. First patch unmask interrupt
> masking bit for charger/flas/muic device of Maxim MAX77693 and second patch
> remove NULL pointer error when mfd-max77693 driver initialize irqs of Maxim
> MAX77693 devices.
> 
> Chanwoo Choi (2):
>   mfd: MAX77693: Fix bug of interrupt handlding for MAX77693 devices
>   mfd: MAX77693: Fix NULL pointer error when initialize irqs of Maxim
>     MAX77693
> 
>  drivers/extcon/extcon-max77693.c |   20 +++++++++++++-------
>  drivers/mfd/max77693-irq.c       |   36 +++++++++++++++++++++++++++++++-----
>  drivers/mfd/max77693.c           |   14 ++++++++++++++
>  3 files changed, 58 insertions(+), 12 deletions(-)
Both patches applied to my for-linus branch.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
