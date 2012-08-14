Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761Ab2HNTvP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 15:51:15 -0400
Received: from mail.active-venture.com ([67.228.131.205]:60354 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821Ab2HNTvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 15:51:13 -0400
X-Originating-IP: 108.223.40.66
Date: Tue, 14 Aug 2012 12:51:15 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Sourav Poddar <sourav.poddar@ti.com>
Cc: devicetree-discuss@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        Benoit Cousson <b-cousson@ti.com>, Felipe Balbi <balbi@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: Re: [PATCH] Documentation: dt: hwmon: Update for tmp102
Message-ID: <20120814195115.GA17168@roeck-us.net>
References: <1344961412-13622-1-git-send-email-sourav.poddar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344961412-13622-1-git-send-email-sourav.poddar@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2012 at 09:53:32PM +0530, Sourav Poddar wrote:
> Add Documentation for tmp102 temperature sensor.
> 
> Cc: Benoit Cousson <b-cousson@ti.com>
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Signed-off-by: Sourav Poddar <sourav.poddar@ti.com>
> ---
>  Documentation/devicetree/bindings/hwmon/tmp102.txt |   11 +++++++++++
>  1 files changed, 11 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/hwmon/tmp102.txt
> 
> diff --git a/Documentation/devicetree/bindings/hwmon/tmp102.txt b/Documentation/devicetree/bindings/hwmon/tmp102.txt
> new file mode 100644
> index 0000000..df1342b
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/hwmon/tmp102.txt
> @@ -0,0 +1,11 @@
> +TMP102 Temperature sensor
> +
> +Required properties:
> +- compatible: ti,tmp102
> +
> +Example:
> +
> +tmp102@48 {
> +        compatible = "ti,tmp102";
> +        reg = <0x48>;
> +};
> -- 

It would be simpler to just add a single line to
	Documentation/devicetree/bindings/i2c/trivial-devices.txt

Guenter
