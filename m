Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757860Ab1LNSEg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 13:04:36 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:62662 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755373Ab1LNSEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 13:04:35 -0500
Message-ID: <4EE8E52C.1030506@gmail.com>
Date: Wed, 14 Dec 2011 12:04:28 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Dong Aisheng <b29396@freescale.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linus.walleij@stericsson.com, s.hauer@pengutronix.de,
        shawn.guo@freescale.com, kernel@pengutronix.de,
        grant.likely@secretlab.ca
Subject: Re: [RFC PATCH v2 1/4] dt: add of_get_child_number helper function
References: <1323878622-26602-1-git-send-email-b29396@freescale.com> <1323878622-26602-2-git-send-email-b29396@freescale.com>
In-Reply-To: <1323878622-26602-2-git-send-email-b29396@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dong,

On 12/14/2011 10:03 AM, Dong Aisheng wrote:
> From: Dong Aisheng <dong.aisheng@linaro.org>
> 
> Currently most code to get child number in kernel are almost same,
> add a helper to implement this function for dt to use.
>
> Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Rob Herring <rob.herring@calxeda.com>
> ---
>  include/linux/of.h |   17 +++++++++++++++++
>  1 files changed, 17 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/of.h b/include/linux/of.h
> index 4948552..09d53dc 100644
> --- a/include/linux/of.h
> +++ b/include/linux/of.h
> @@ -189,6 +189,18 @@ extern struct device_node *of_get_next_child(const struct device_node *node,
>  	for (child = of_get_next_child(parent, NULL); child != NULL; \
>  	     child = of_get_next_child(parent, child))
>  
> +static inline int of_get_child_number(struct device_node *np)

I would call this of_get_child_count instead.

Rob
