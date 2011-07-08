Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022Ab1GHPUT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 11:20:19 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:45283 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794Ab1GHPUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 11:20:16 -0400
Date: Fri, 8 Jul 2011 18:18:54 +0300
From: Dan Carpenter <error27@gmail.com>
To: Ravishankar <ravishankarkm32@gmail.com>
Cc: gregkh@suse.de, wfp5p@virginia.edu, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>
Subject: Re: [PATCH 6/6] Staging: comedi: fix warning issue in dt9812.c
Message-ID: <20110708151854.GZ18655@shale.localdomain>
References: <1310137928-6942-1-git-send-email-ravishankarkm32@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310137928-6942-1-git-send-email-ravishankarkm32@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 08, 2011 at 08:42:08PM +0530, Ravishankar wrote:
> --- a/drivers/staging/comedi/drivers/dt9812.c
> +++ b/drivers/staging/comedi/drivers/dt9812.c
> @@ -196,7 +196,7 @@ struct dt9812_flash_data {
>  };
>  
>  #define DT9812_MAX_NUM_MULTI_BYTE_RDS  \
> -    ((DT9812_MAX_WRITE_CMD_PIPE_SIZE - 4 - 1) / sizeof(u8))
> +((DT9812_MAX_WRITE_CMD_PIPE_SIZE - 4 - 1) / sizeof(u8))

This should be indented.  Replace the spaces with a tab.

regards,
dan carpenter

