Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752339Ab1GIIeF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 04:34:05 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:51214 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285Ab1GIIeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 04:34:03 -0400
Date: Sat, 9 Jul 2011 11:32:41 +0300
From: Dan Carpenter <error27@gmail.com>
To: Ravishankar <ravishankarkm32@gmail.com>
Cc: gregkh@suse.de, wfp5p@virginia.edu, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>
Subject: Re: [PATCH 9/9] Staging: comedi: fix printk issue in pcmmio.c
Message-ID: <20110709083241.GD18655@shale.localdomain>
References: <1310192700-14603-1-git-send-email-ravishankarkm32@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310192700-14603-1-git-send-email-ravishankarkm32@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 09, 2011 at 11:55:00AM +0530, Ravishankar wrote:
> @@ -663,7 +663,7 @@ static int pcmmio_dio_insn_bits(struct comedi_device *dev,
>  		}
>  #ifdef DAMMIT_ITS_BROKEN
>  		/* DEBUG */
> -		printk("data_out_byte %02x\n", (unsigned)byte);
> +	printk(KERN_DEBUG "data_out_byte %02x\n", (unsigned) byte);
>  #endif

The indenting was correct in the original.

regards,
dan carpenter

