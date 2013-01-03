Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753039Ab3ACCKh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 21:10:37 -0500
Received: from mail-la0-f45.google.com ([209.85.215.45]:62675 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769Ab3ACCKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 21:10:35 -0500
MIME-Version: 1.0
In-Reply-To: <1356083041-29179-1-git-send-email-peter.ujfalusi@ti.com>
References: <1356083041-29179-1-git-send-email-peter.ujfalusi@ti.com>
From: Bryan Wu <cooloney@gmail.com>
Date: Wed, 2 Jan 2013 18:10:13 -0800
Message-ID: <CAK5ve-L=L2qp1A01Kui9RAMn9mZxL7P-c0sZ1bDveLoKkK0Fzg@mail.gmail.com>
Subject: Re: [PATCH v5 0/7] leds: leds-pwm: Device tree support
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Richard Purdie <rpurdie@rpsys.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

I merged this patchset into my for-next branch already.

Thanks for pushing this.
-Bryan

On Fri, Dec 21, 2012 at 1:43 AM, Peter Ujfalusi <peter.ujfalusi@ti.com> wrote:
> Hello,
>
> Changes since v4:
> - Commit message for patch #7 (DT binding for the leds-pwm driver) has been
>   updated
>
> Changes since v3:
> Addressed comments from Thierry Redding:
> - DT binding documentation for leds-pwm updated
> - of_pwm_request() renamed as of_pwm_get()
> - introduction of devm_of_pwm_get()
> - Commit message updates
> - Other comments has been also addressed
> - Acked-by from Grant is not added to the patches since they were modified since
>   v3
>
> Changes since v2:
> - rebased on top of linux-next
> - DT bindings now alligned with Grant's request
> - exporting of_pwm_request() from PWM core to allow clean DT bindings
> - DT binding documentation changed to reflect the changes
>
> Changes since v1:
> - As suggested by Bryan Wu: the legacy pwm_request() has been removed from
>   patch 1
> - Device tree bindings added for leds-pwm driver.
>
> When we boot with Device tree we handle one LED per device to be more aligned
> with PWM core's DT implementation.
> An example of the DT usage is provided in the new DT binding documentation for
> leds-pwm.
>
> Tested on OMAP4 Blaze (SDP), BeagleBoard with legacy and DT boot. On Zoom2 with
> legacy boot.
>
> Regards,
> Peter
> ---
> Peter Ujfalusi (7):
>   leds: leds-pwm: Convert to use devm_get_pwm
>   leds: leds-pwm: Preparing the driver for device tree support
>   pwm: Correct parameter name in header for *pwm_get() functions
>   pwm: core: Rename of_pwm_request() to of_pwm_get() and export it
>   pwm: Add devm_of_pwm_get() as exported API for users
>   leds: leds-pwm: Simplify cleanup code
>   leds: leds-pwm: Add device tree bindings
>
>  .../devicetree/bindings/leds/leds-pwm.txt          |  48 +++++++
>  drivers/leds/leds-pwm.c                            | 152 +++++++++++++++------
>  drivers/pwm/core.c                                 |  38 +++++-
>  include/linux/leds_pwm.h                           |   2 +-
>  include/linux/pwm.h                                |  20 ++-
>  5 files changed, 212 insertions(+), 48 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/leds/leds-pwm.txt
>
> --
> 1.8.0.2
>
