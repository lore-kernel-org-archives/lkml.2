Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691Ab2LKI53 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 03:57:29 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:41270 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591Ab2LKI51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 03:57:27 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH RFC 05/13] of: Add empty for_each_available_child_of_node() macro definition
To: Sylwester Nawrocki <s.nawrocki@samsung.com>, g.liakhovetski@gmx.de,
        linux-media@vger.kernel.org
Cc: rob.herring@calxeda.com, thomas.abraham@linaro.org, t.figa@samsung.com,
        sw0312.kim@samsung.com, kyungmin.park@samsung.com,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
In-Reply-To: <1355168499-5847-6-git-send-email-s.nawrocki@samsung.com>
References: <1355168499-5847-1-git-send-email-s.nawrocki@samsung.com> <1355168499-5847-6-git-send-email-s.nawrocki@samsung.com>
Date: Tue, 11 Dec 2012 08:57:07 +0000
Message-Id: <20121211085707.8D4F03E076D@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Dec 2012 20:41:31 +0100, Sylwester Nawrocki <s.nawrocki@samsung.com> wrote:
> Add this empty macro definition so users can be compiled without
> excluding this macro call with preprocessor directives when CONFIG_OF
> is disabled.
> 
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

What non-OF code is calling this function?

g.

> ---
>  include/linux/of.h |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/include/linux/of.h b/include/linux/of.h
> index 2fb0dbe..7df42cc 100644
> --- a/include/linux/of.h
> +++ b/include/linux/of.h
> @@ -332,6 +332,9 @@ static inline bool of_have_populated_dt(void)
>  #define for_each_child_of_node(parent, child) \
>  	while (0)
>  
> +#define for_each_available_child_of_node(parent, child) \
> +	while (0)
> +
>  static inline struct device_node *of_get_child_by_name(
>  					const struct device_node *node,
>  					const char *name)
> -- 
> 1.7.9.5
> 

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
