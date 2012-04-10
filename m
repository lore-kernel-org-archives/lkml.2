Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605Ab2DJIQX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 04:16:23 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:40402 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545Ab2DJIQV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 04:16:21 -0400
MIME-Version: 1.0
In-Reply-To: <1333553270-9040-1-git-send-email-swarren@wwwdotorg.org>
References: <1333553270-9040-1-git-send-email-swarren@wwwdotorg.org>
Date: Tue, 10 Apr 2012 10:16:20 +0200
Message-ID: <CACRpkdaU+bC4W=Vhuo5ygbNUZ9PJFETRPgkak9bHHcR+60crTA@mail.gmail.com>
Subject: Re: [PATCH V4 REPOST 1/5] dt: add property iteration helpers
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 4, 2012 at 5:27 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:

> From: Stephen Warren <swarren@nvidia.com>
>
> This patch adds macros of_property_for_each_u32() and
> of_property_for_each_string(), which iterate over an array of values
> within a device-tree property. Usage is for example:
>
> struct property *prop;
> const __be32 *p;
> u32 u;
> of_property_for_each_u32(np, "propname", prop, p, u)
>        printk("U32 value: %x\n", u);
>
> struct property *prop;
> const char *s;
> of_property_for_each_string(np, "propname", prop, s)
>        printk("String value: %s\n", s);
>
> Based on work by Rob Herring <robherring2@gmail.com>
>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> Acked-by: Rob Herring <rob.herring@calxeda.com>

Acked by DT maintainer, so applied to pinctrl tree now.

Thanks,
Linus Walleij
