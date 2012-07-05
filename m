Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756518Ab2GERmv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 13:42:51 -0400
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:43357 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974Ab2GERmu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 13:42:50 -0400
Date: Thu, 5 Jul 2012 20:42:40 +0300
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Miguel =?iso-8859-1?Q?G=F3mez?= <magomez@igalia.com>
Cc: arnaud.patard@rtp-net.org, gregkh@linuxfoundation.org,
        dan.carpenter@oracle.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/19] Staging: xgifb: Improve debug strings.
Message-ID: <20120705174240.GB4519@blackmetal.musicnaut.iki.fi>
References: <cover.1341498465.git.magomez@igalia.com>
 <8e9d31bda6a900ef71ba4a19014624939540455c.1341498465.git.magomez@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <8e9d31bda6a900ef71ba4a19014624939540455c.1341498465.git.magomez@igalia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-Antivirus: VAMS
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Jul 05, 2012 at 04:45:48PM +0200, Miguel Gómez wrote:
>  	if (!htotal || !vtotal) {
> -		pr_debug("XGIfb: Invalid 'var' information\n");
> +		pr_debug("Invalid 'var' information\n");
[...]
> -		pr_err("xgifb: invalid value for option: %s\n", fullopt);
> +		pr_err("Invalid value for option: %s\n", fullopt);
[...]
> -	pr_info("xgifb: options: %s\n", options);
> +	pr_info("Options: %s\n", options);

Can you really remove the driver prefix?

>  	if (reg1 != 0xa1) { /*I/O error */
> -		dev_err(&pdev->dev, "I/O error!!!");
> +		dev_err(&pdev->dev, "I/O error!!!\n");

Those exclamation marks are just redundant noise.

> -		dev_err(&pdev->dev, "unable request memory size %x\n",
> +		dev_err(&pdev->dev, "Unable request memory size %x\n",
[...]
> -		dev_err(&pdev->dev, "no supported video mode found\n");
> +		dev_err(&pdev->dev, "No supported video mode found\n");
[...]
> -		dev_info(&pdev->dev, "added MTRR\n");
> +		dev_info(&pdev->dev, "Added MTRR\n");
[...]
> -		dev_err(&pdev->dev, "video BIOS not available\n");
> +		dev_err(&pdev->dev, "Video BIOS not available\n");
[...]
> -	dev_err(&pdev->dev, "video BIOS corrupted\n");
> +	dev_err(&pdev->dev, "Video BIOS corrupted\n");

What is the improvement?

A.
