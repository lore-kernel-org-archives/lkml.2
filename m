Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S933315Ab1ERRZB (ORCPT <rfc822;macro@linux-mips.org> + 1 other);
        Wed, 18 May 2011 13:25:01 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:58871 "EHLO
        devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933132Ab1ERRY7 (ORCPT
        <rfc822;linux-kernel@vger.kernel.org>);
        Wed, 18 May 2011 13:24:59 -0400
Message-ID: <4DD3F6F7.5090508@ti.com>
Date: Wed, 18 May 2011 17:42:31 +0100
From: Liam Girdwood <lrg@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>
CC: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "broonie@opensource.wolfsonmicro.com" 
        <broonie@opensource.wolfsonmicro.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        Graeme Gregory <gg@slimlogic.co.uk>
Subject: Re: [PATCHv4 4/6] GPIO: TPS65910: Move driver to drivers/gpio/
References: <797F9124-08A3-45B9-BA71-284BB3048F1D@slimlogic.co.uk>
In-Reply-To: <797F9124-08A3-45B9-BA71-284BB3048F1D@slimlogic.co.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Return-Path: <linux-kernel-owner@vger.kernel.org>

On 17/05/11 00:35, Jorge Eduardo Candelaria wrote:
> The GPIO driver should reside in drivers/gpio/ for better
> organization.
> 
> Signed-off-by: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
> ---
>  drivers/gpio/Kconfig         |    7 +++
>  drivers/gpio/Makefile        |    1 +
>  drivers/gpio/tps65910-gpio.c |   91 ++++++++++++++++++++++++++++++++++++++++++
>  drivers/mfd/Kconfig          |    3 +-
>  drivers/mfd/Makefile         |    2 +-
>  drivers/mfd/tps65910-gpio.c  |   91 ------------------------------------------
>  6 files changed, 102 insertions(+), 93 deletions(-)
>  create mode 100644 drivers/gpio/tps65910-gpio.c
>  delete mode 100644 drivers/mfd/tps65910-gpio.c
> 

Grant, if you are happy with this I can this series altogether via regulator.

Thanks

Liam
