Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758040Ab1CCMWu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 07:22:50 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:41664 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078Ab1CCMWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 07:22:49 -0500
Date: Thu, 3 Mar 2011 13:22:42 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Dirk Eibach <eibach@gdsys.de>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        rdunlap@xenotime.net, devicetree-discuss@lists.ozlabs.org,
        w.sang@pengutronix.de
Subject: Re: [PATCH v2] hwmon: (ads1015) Add devicetree documentation
Message-ID: <20110303132242.713cd342@endymion.delvare>
In-Reply-To: <1299154757-13682-1-git-send-email-eibach@gdsys.de>
References: <20110303102157.GC3649@pengutronix.de>
	<1299154757-13682-1-git-send-email-eibach@gdsys.de>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  3 Mar 2011 13:19:17 +0100, Dirk Eibach wrote:
> Signed-off-by: Dirk Eibach <eibach@gdsys.de>
> ---
> Changes since v1:
> - removed sysfs from description
> - explain channels 
> 
>  Documentation/devicetree/bindings/i2c/ads1015.txt |   29 +++++++++++++++++++++
>  1 files changed, 29 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/i2c/ads1015.txt
> 
> diff --git a/Documentation/devicetree/bindings/i2c/ads1015.txt b/Documentation/devicetree/bindings/i2c/ads1015.txt
> new file mode 100644
> index 0000000..0f30616
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/i2c/ads1015.txt
> @@ -0,0 +1,29 @@
> +ADS1015 (I2C)
> +
> +This device is a 12-bit A-D converter with 4 inputs.
> +
> +The inputs can be used single ended or in certain differential combinations.
> +
> +For configuration all possible combinations are mapped to 8 channels:
> +0: Voltage over AIN0 and AIN1.
> +1: Voltage over AIN0 and AIN3.
> +2: Voltage over AIN1 and AIN3.
> +3: Voltage over AIN2 and AIN3.
> +4: Voltage over AIN0 and GND.
> +5: Voltage over AIN1 and GND.
> +6: Voltage over AIN2 and GND.
> +7: Voltage over AIN3 and GND.
> +
> +Optional properties:
> +
> + - exported-channels : exported_channels is a bitmask that specifies which
> +		       channels should be accessable by the user.

"accessable" doesn't exist as an English word.

> +
> +Example:
> +ads1015@49 {
> +	compatible = "ti,ads1015";
> +	reg = <0x49>;
> +	exported-channels = <0x14>;
> +};
> +
> +In this example only channel 2 and 4 would be accessable by the user.

Ditto.

-- 
Jean Delvare
