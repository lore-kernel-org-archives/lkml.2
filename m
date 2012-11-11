Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751538Ab2KKXzw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 18:55:52 -0500
Received: from mga14.intel.com ([143.182.124.37]:35031 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751179Ab2KKXzv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 18:55:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,759,1344236400"; 
   d="scan'208";a="167016579"
Date: Mon, 12 Nov 2012 00:55:47 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: David Dajun Chen <dchen@diasemi.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd/DA9055: Remove Unicode Byte Order Marks
Message-ID: <20121111235547.GI27828@sortiz-mobl>
References: <1350333885-20323-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1350333885-20323-1-git-send-email-geert@linux-m68k.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

On Mon, Oct 15, 2012 at 10:44:45PM +0200, Geert Uytterhoeven wrote:
> Older gcc (< 4.4) doesn't like files starting with Unicode BOMs:
> 
> include/linux/mfd/da9055/core.h:1: error: stray ‘\357’ in program
> include/linux/mfd/da9055/core.h:1: error: stray ‘\273’ in program
> include/linux/mfd/da9055/core.h:1: error: stray ‘\277’ in program
> include/linux/mfd/da9055/pdata.h:1: error: stray ‘\357’ in program
> include/linux/mfd/da9055/pdata.h:1: error: stray ‘\273’ in program
> include/linux/mfd/da9055/pdata.h:1: error: stray ‘\277’ in program
> include/linux/mfd/da9055/reg.h:1: error: stray ‘\357’ in program
> include/linux/mfd/da9055/reg.h:1: error: stray ‘\273’ in program
> include/linux/mfd/da9055/reg.h:1: error: stray ‘\277’ in program
> 
> Remove the BOMs, the rest of the files is plain ASCII anyway.
> 
> Output of "file" before:
> 
> include/linux/mfd/da9055/core.h:  UTF-8 Unicode (with BOM) C program text
> include/linux/mfd/da9055/pdata.h: UTF-8 Unicode (with BOM) C program text
> include/linux/mfd/da9055/reg.h:   UTF-8 Unicode (with BOM) C program text
> 
> Output of "file" after:
> 
> include/linux/mfd/da9055/core.h:  ASCII C program text
> include/linux/mfd/da9055/pdata.h: ASCII C program text
> include/linux/mfd/da9055/reg.h:   ASCII C program text
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
>  include/linux/mfd/da9055/core.h  |    2 +-
>  include/linux/mfd/da9055/pdata.h |    2 +-
>  include/linux/mfd/da9055/reg.h   |    2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
Applied to my for-next branch, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
