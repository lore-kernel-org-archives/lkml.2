Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759475Ab2IEVEW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 17:04:22 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50431 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753937Ab2IEVEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 17:04:21 -0400
Date: Wed, 5 Sep 2012 14:01:47 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: sameo@linux.intel.com, myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] mfd: MAX77693: Fix bug
Message-ID: <20120905210147.GB27262@kroah.com>
References: <1345529747-24808-1-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345529747-24808-1-git-send-email-cw00.choi@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Feel free to take these patches through the MFD tree:

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
