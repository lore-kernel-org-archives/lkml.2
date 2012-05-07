Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757160Ab2EGPFO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 11:05:14 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:44867 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756806Ab2EGPFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 11:05:12 -0400
Message-ID: <4FA7E4A3.6050004@wwwdotorg.org>
Date: Mon, 07 May 2012 09:05:07 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: broonie@opensource.wolfsonmicro.com, lrg@ti.com, grant.likely@secretlab.ca,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V1] regulator: fixed: dt: add property for gpio open drain
 flag
References: <1336386499-20408-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1336386499-20408-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2012 04:28 AM, Laxman Dewangan wrote:
> Add property for the gpio flag open drain when registering
> fixed regulator.

> diff --git a/Documentation/devicetree/bindings/regulator/fixed-regulator.txt ...

> +- gpio-open-drain: GPIO is open drain type.
> +  If this property is missing then default assumption is false.

Given that there's a GPIOF_OPEN_DRAIN, isn't the GPIO specifier in the
gpio property meant to encode this somehow (the format is up to the GPIO
controller's binding) - the flags are returned by of_get_named_gpio_flags().

(especially given you asked me off-list about updating the GPIO binding
documentation with information about the flags that Tegra's binding
documented for this)
