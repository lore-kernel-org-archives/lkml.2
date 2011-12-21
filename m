Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753052Ab1LUKWl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 05:22:41 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:51155 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900Ab1LUKWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 05:22:38 -0500
Message-ID: <4EF1B36A.8050304@monstr.eu>
Date: Wed, 21 Dec 2011 11:22:34 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: devicetree-discuss@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org,
        Sascha Hauer <kernel@pengutronix.de>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC 1/8] gpio/microblaze: Eliminate duplication of of_get_named_gpio_flags()
References: <1320801583-12774-1-git-send-email-grant.likely@secretlab.ca> <1320801583-12774-2-git-send-email-grant.likely@secretlab.ca>
In-Reply-To: <1320801583-12774-2-git-send-email-grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant Likely wrote:
> of_reset_gpio_handle() is largely a cut-and-paste copy of
> of_get_named_gpio_flags(). There really isn't any reason for the
> split, so this patch deletes the duplicate function
> 
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> Cc: Michal Simek <monstr@monstr.eu>
> ---
>  arch/microblaze/kernel/reset.c |   43 +--------------------------------------
>  1 files changed, 2 insertions(+), 41 deletions(-)

Sorry for taking to long.

Tested and applied to microblaze tree.

Thanks,
Michal

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
