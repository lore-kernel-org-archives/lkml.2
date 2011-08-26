Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648Ab1HZJ0i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 05:26:38 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53535 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753892Ab1HZJ0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 05:26:37 -0400
Date: Fri, 26 Aug 2011 10:26:32 +0100
From: Jamie Iles <jamie@jamieiles.com>
To: Stephen Warren <swarren@nvidia.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, Colin Cross <ccross@android.com>,
        Erik Gilling <konkers@android.com>, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        devicetree-discuss@lists.ozlabs.org, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Belisko Marek <marek.belisko@gmail.com>,
        Jamie Iles <jamie@jamieiles.com>, Shawn Guo <shawn.guo@freescale.com>,
        Sergei Shtylyov <sshtylyov@mvista.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH v3 11/13] of: add property iteration helpers
Message-ID: <20110826092632.GB3926@pulham.picochip.com>
References: <1314315824-9687-1-git-send-email-swarren@nvidia.com>
 <1314315824-9687-12-git-send-email-swarren@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314315824-9687-12-git-send-email-swarren@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 25, 2011 at 05:43:42PM -0600, Stephen Warren wrote:
> This patch adds macros for_each_u32_property_value and
> for_each_string_property_value, which iterate over an array of values
> within a device-tree property. Usage is for example:
> 
> struct of_iter_string_prop iter;
> for_each_string_property_value(iter, np, "pins")
>         printk("Got value %s\n", iter.value);
> 
> Signed-off-by: Stephen Warren <swarren@nvidia.com>

Nicely implemented!  For the !CONFIG_OF case, I *think* that 
of_iter_u32_prop and of_iter_string_prop can be empty struct's, but I 
wouldn't want to bet money on that!

Reviewed-by: Jamie Iles <jamie@jamieiles.com>
