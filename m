Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751935Ab1HCHLA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 03:11:00 -0400
Received: from wondertoys-mx.wondertoys.net ([206.117.179.246]:46582 "EHLO
	labridge.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750901Ab1HCHK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 03:10:57 -0400
X-Greylist: delayed 3601 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Aug 2011 03:10:57 EDT
Subject: Re: [PATCH] Staging: comedi: fix printk issue in pcl818.c
From: Joe Perches <joe@perches.com>
To: Ravishankar <ravishankarkm32@gmail.com>
Cc: gregkh@suse.de, wfp5p@virginia.edu, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>
In-Reply-To: <1312349090-31007-1-git-send-email-ravishankarkm32@gmail.com>
References: <[PATCH]Staging: Comedi: fix printk issues in pcl818.c>
	 <1312349090-31007-1-git-send-email-ravishankarkm32@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 02 Aug 2011 23:10:53 -0700
Message-ID: <1312351854.26546.9.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-03 at 10:54 +0530, Ravishankar wrote:
> From: Ravishankar <ravi.shankar@greenturtles.in>
> This is a patch to the pcl818.c file that fixes up a printk warning found by the checkpatch.pl tool

This patch does a lot more than fix a printk warning.

Please make your patch descriptions match your patch.

>  drivers/staging/comedi/drivers/pcl818.c |  118 +++++++++++++++----------------

> @@ -1461,7 +1452,7 @@ static int ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
>  	struct comedi_cmd *cmd = &s->async->cmd;
>  	int retval;
>  
> -	printk("pcl818_ai_cmd()\n");
> +	dev_dbg(dev->hw_dev "pcl818_ai_cmd()\n");

Compile your patches _before_ sending them.


