Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845Ab2IUFQs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 01:16:48 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:59781 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993Ab2IUFQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 01:16:46 -0400
Message-ID: <505BF83D.8040201@wwwdotorg.org>
Date: Thu, 20 Sep 2012 23:16:45 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: "Philip, Avinash" <avinashphilip@ti.com>
CC: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        rpurdie@rpsys.net, thierry.reding@avionic-design.de,
        broonie@opensource.wolfsonmicro.com, shawn.guo@linaro.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, nsekhar@ti.com, gururaja.hebbar@ti.com
Subject: Re: [PATCH v2] pwm_backlight: Add device tree support for Low Threshold
 Brightness
References: <1348203080-16348-1-git-send-email-avinashphilip@ti.com>
In-Reply-To: <1348203080-16348-1-git-send-email-avinashphilip@ti.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2012 10:51 PM, Philip, Avinash wrote:
> Some backlights perform poorly when driven by a PWM with a short
> duty-cycle. For such devices, the low threshold can be used to specify a
> lower bound for the duty-cycle and should be chosen to exclude the
> problematic range.
> 
> This patch adds support for an optional low-threshold-brightness
> property.

> diff --git a/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt b/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt

>  Optional properties:
>    - pwm-names: a list of names for the PWM devices specified in the
>                 "pwms" property (see PWM binding[0])
> +  - low-threshold-brightness: brightness threshold low level. Low threshold
> +    brightness set to value so that backlight present on low end of
> +    brightness.

For my education, why not just specify values above this value in the
brightness-levels array; how do those two interact? It seems like any
description of that is missing from the PWM documentation, and would be
good to have in the DT binding too.

