Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751498Ab1GUOYS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 10:24:18 -0400
Received: from mail.perches.com ([173.55.12.10]:4223 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751231Ab1GUOYR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 10:24:17 -0400
Subject: Re: [PATCH 1/2] staging: vt6655: simplify MAC printing by using
 %pMF
From: Joe Perches <joe@perches.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <c8400fbc4ad3a91885fcda0e080be0ae80fcf077.1311252059.git.andriy.shevchenko@linux.intel.com>
References: <c8400fbc4ad3a91885fcda0e080be0ae80fcf077.1311252059.git.andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Jul 2011 07:24:16 -0700
Message-ID: <1311258256.1663.35.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-07-21 at 15:42 +0300, Andy Shevchenko wrote:
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>  drivers/staging/vt6655/device_main.c |   10 +-----
>  drivers/staging/vt6655/dpc.c         |   30 ++++----------------
>  drivers/staging/vt6655/wmgr.c        |   49 +++++++---------------------------
[ patches like ]
> +	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Probe request rx:MAC addr:%pMF\n",
> +		sFrame.pHdr->sA3.abyAddr2);

Please use %pM here and in [2/2] as well.

%pMF should be used only for FDDI.

It looks as if this was someones idea to separate
the OUI out of the mac address.


