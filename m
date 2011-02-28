Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015Ab1B1NE3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 08:04:29 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:42032 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753976Ab1B1NE1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 08:04:27 -0500
From: "TK, Pratheesh Gangadhar" <pratheesh@ti.com>
To: Subhasish Ghosh <subhasish@mistralsolutions.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>
CC: "sachi@mistralsolutions.com" <sachi@mistralsolutions.com>,
        Russell King <linux@arm.linux.org.uk>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        open list <linux-kernel@vger.kernel.org>,
        "Watkins, Melissa" <m-watkins@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Mon, 28 Feb 2011 18:34:10 +0530
Subject: RE: [PATCH v2 02/13] da850: pruss platform specific additions.
Thread-Topic: [PATCH v2 02/13] da850: pruss platform specific additions.
Thread-Index: AcvJ+X3G9/9v/NT1SB2c23Evva7seANTbx0g
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB593024BF35DEE@dbde02.ent.ti.com>
References: <1297435892-28278-1-git-send-email-subhasish@mistralsolutions.com>
 <1297435892-28278-3-git-send-email-subhasish@mistralsolutions.com>
In-Reply-To: <1297435892-28278-3-git-send-email-subhasish@mistralsolutions.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> -----Original Message-----
> From: davinci-linux-open-source-bounces@linux.davincidsp.com
> [mailto:davinci-linux-open-source-bounces@linux.davincidsp.com] On Behalf
> Of Subhasish Ghosh
> Sent: Friday, February 11, 2011 8:21 PM
> To: davinci-linux-open-source@linux.davincidsp.com
> Cc: sachi@mistralsolutions.com; Russell King; Kevin Hilman; Subhasish
> Ghosh; open list; Watkins, Melissa; linux-arm-kernel@lists.infradead.org
> Subject: [PATCH v2 02/13] da850: pruss platform specific additions.
> 
> This patch adds the platform device and assignes the platform resources
> for the PRUSS mfd driver.
> 
> Signed-off-by: Subhasish Ghosh <subhasish@mistralsolutions.com>
> ---
> +struct platform_device da8xx_pruss_dev = {
Can you please rename this to da8xx_pruss_mfddev?
> +	.name		= "da8xx_pruss",
Can you please rename name string as pruss_mfd? This will help to
base my UIO patches on top of yours.
> +	.id		= -1,
> +	.num_resources	= ARRAY_SIZE(da8xx_pruss_resources),
> +	.resource	= da8xx_pruss_resources,
> +};
> +
> +int __init da8xx_register_pruss(struct da8xx_pruss_devices *pruss_device)
Please rename this to da8xx_register_pruss_mfd

Thanks,
Pratheesh
