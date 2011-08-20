Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174Ab1HTQwu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Aug 2011 12:52:50 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:45014 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753621Ab1HTQwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Aug 2011 12:52:49 -0400
Date: Sat, 20 Aug 2011 19:50:34 +0300
From: Dan Carpenter <error27@gmail.com>
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: apatard@mandriva.com, gregkh@suse.de, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/12] staging: xgifb: eliminate #ifdef NewScratch
Message-ID: <20110820165034.GK3715@shale.localdomain>
References: <1313782830-31461-1-git-send-email-aaro.koskinen@iki.fi>
 <1313782830-31461-2-git-send-email-aaro.koskinen@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313782830-31461-2-git-send-email-aaro.koskinen@iki.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 19, 2011 at 10:40:19PM +0300, Aaro Koskinen wrote:
> @@ -616,16 +611,13 @@
>  #define Monitor1Sense        0x20
>  #define HiTVSense            0x40
>  
> -#ifdef NewScratch
>  #define YPbPrSense           0x80   /* NEW SCRATCH */
                                       ^^^^^^^^^^^^^^^^^
You could delete this comment too if you wanted.  It's not worth
doing a resend, but you could do it in another patch.

> -#endif

regards,
dan carpenter


