Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567Ab2ISPpY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 11:45:24 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:50997 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756540Ab2ISPpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 11:45:19 -0400
Message-ID: <5059E88C.7090801@gmail.com>
Date: Wed, 19 Sep 2012 10:45:16 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: devicetree-discuss@lists.ozlabs.org,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] gpio: adnp: dt: Reference generic interrupt binding
References: <1348045056-29769-1-git-send-email-thierry.reding@avionic-design.de> <1348045056-29769-2-git-send-email-thierry.reding@avionic-design.de>
In-Reply-To: <1348045056-29769-2-git-send-email-thierry.reding@avionic-design.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2012 03:57 AM, Thierry Reding wrote:
> Instead of having to duplicate the description of the properties needed
> for interrupt support, reference the new standard document.
> 
> Cc: Linus Walleij <linus.walleij@stericsson.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: devicetree-discuss@lists.ozlabs.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> ---
> This patch should go through LinusW's tree because it already carries
> the patch that created this documentation.
> 
>  Documentation/devicetree/bindings/gpio/gpio-adnp.txt | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/gpio/gpio-adnp.txt b/Documentation/devicetree/bindings/gpio/gpio-adnp.txt
> index 5a09a21..625eee7 100644
> --- a/Documentation/devicetree/bindings/gpio/gpio-adnp.txt
> +++ b/Documentation/devicetree/bindings/gpio/gpio-adnp.txt
> @@ -11,6 +11,10 @@ Required properties:
>  - gpio-controller: Marks the device as a GPIO controller
>  - nr-gpios: The number of pins supported by the controller.
>  
> +The GPIO exander can optionally be used as an interrupt controller, in

s/exander/expander/

Otherwise,

Acked-by: Rob Herring <rob.herring@calxeda.com>

> +which case it uses the default two cell specifier as described in
> +Documentation/devicetree/bindings/interrupt-controller/interrupts.txt.
> +
>  Example:
>  
>  	gpioext: gpio-controller@41 {
> 

