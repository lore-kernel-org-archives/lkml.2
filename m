Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074Ab0KEDKY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 23:10:24 -0400
Received: from imr3.ericy.com ([198.24.6.13]:35878 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753911Ab0KEDKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 23:10:19 -0400
Date: Thu, 4 Nov 2010 20:09:23 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Henrik Rydberg <rydberg@euromail.se>
CC: Jean Delvare <khali@linux-fr.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Subject: Re: [lm-sensors] [PATCH 8/8] hwmon: applesmc: Update copyright
 information
Message-ID: <20101105030923.GG28308@ericsson.com>
References: <1288511434-5662-1-git-send-email-rydberg@euromail.se>
 <1288511434-5662-9-git-send-email-rydberg@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1288511434-5662-9-git-send-email-rydberg@euromail.se>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 31, 2010 at 03:50:34AM -0400, Henrik Rydberg wrote:
> With the preceding patches, git blame assigns about half of
> the file to the present author. Add a line to the copyright
> to reflect this.
> 
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> ---
>  drivers/hwmon/applesmc.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
> index c09cd2e..7ae37eb 100644
> --- a/drivers/hwmon/applesmc.c
> +++ b/drivers/hwmon/applesmc.c
> @@ -4,6 +4,7 @@
>   * computers.
>   *
>   * Copyright (C) 2007 Nicolas Boichat <nicolas@boichat.ch>
> + * Copyright (C) 2010 Henrik Rydberg <rydberg@euromail.se>
>   *
>   * Based on hdaps.c driver:
>   * Copyright (C) 2005 Robert Love <rml@novell.com>
> -- 


Hi Henrik,

overall excellent cleanup. 

One suggestion - since you did that much rework, it would be nice if you could fix
the remaining few checkpatch errors in the file as well (and possibly the warnings).

Guenter

