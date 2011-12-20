Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752455Ab1LTSmQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 13:42:16 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:54682 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403Ab1LTSmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 13:42:08 -0500
Message-ID: <4EF0D6FD.8070406@gmail.com>
Date: Tue, 20 Dec 2011 12:42:05 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Dong Aisheng <b29396@freescale.com>
CC: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, grant.likely@secretlab.ca,
        shawn.guo@freescale.com
Subject: Re: [PATCH 1/1] dt: fix some code indent issue in of.h
References: <1324404609-3999-1-git-send-email-b29396@freescale.com>
In-Reply-To: <1324404609-3999-1-git-send-email-b29396@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2011 12:10 PM, Dong Aisheng wrote:
> From: Dong Aisheng <dong.aisheng@linaro.org>
> 
> Checkpatch script will report some warnings for the old coding style:
> WARNING: suspect code indent for conditional statements (8, 0)
>         for (child = of_get_next_child(parent, NULL); child != NULL; \
> [...]
> +static inline int of_get_child_count(const struct device_node *np)
> 
> Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Rob Herring <rob.herring@calxeda.com>
> ---
>  include/linux/of.h |   12 ++++++------
>  1 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/of.h b/include/linux/of.h
> index f1a490c..95dee0a 100644
> --- a/include/linux/of.h
> +++ b/include/linux/of.h
> @@ -163,22 +163,22 @@ extern struct device_node *of_find_node_by_name(struct device_node *from,
>  	const char *name);
>  #define for_each_node_by_name(dn, name) \
>  	for (dn = of_find_node_by_name(NULL, name); dn; \
> -	     dn = of_find_node_by_name(dn, name))
> +		dn = of_find_node_by_name(dn, name))
>  extern struct device_node *of_find_node_by_type(struct device_node *from,
>  	const char *type);
>  #define for_each_node_by_type(dn, type) \
>  	for (dn = of_find_node_by_type(NULL, type); dn; \
> -	     dn = of_find_node_by_type(dn, type))
> +		dn = of_find_node_by_type(dn, type))
>  extern struct device_node *of_find_compatible_node(struct device_node *from,
>  	const char *type, const char *compat);
>  #define for_each_compatible_node(dn, type, compatible) \
>  	for (dn = of_find_compatible_node(NULL, type, compatible); dn; \
> -	     dn = of_find_compatible_node(dn, type, compatible))
> +		dn = of_find_compatible_node(dn, type, compatible))
>  extern struct device_node *of_find_matching_node(struct device_node *from,
>  	const struct of_device_id *matches);
>  #define for_each_matching_node(dn, matches) \
>  	for (dn = of_find_matching_node(NULL, matches); dn; \
> -	     dn = of_find_matching_node(dn, matches))
> +		dn = of_find_matching_node(dn, matches))
>  extern struct device_node *of_find_node_by_path(const char *path);
>  extern struct device_node *of_find_node_by_phandle(phandle handle);
>  extern struct device_node *of_get_parent(const struct device_node *node);
> @@ -187,13 +187,13 @@ extern struct device_node *of_get_next_child(const struct device_node *node,
>  					     struct device_node *prev);
>  #define for_each_child_of_node(parent, child) \
>  	for (child = of_get_next_child(parent, NULL); child != NULL; \
> -	     child = of_get_next_child(parent, child))
> +		child = of_get_next_child(parent, child))
>  
>  extern struct device_node *of_find_node_with_property(
>  	struct device_node *from, const char *prop_name);
>  #define for_each_node_with_property(dn, prop_name) \
>  	for (dn = of_find_node_with_property(NULL, prop_name); dn; \
> -	     dn = of_find_node_with_property(dn, prop_name))
> +		dn = of_find_node_with_property(dn, prop_name))
>  
>  extern struct property *of_find_property(const struct device_node *np,
>  					 const char *name,

The old way looks fine to me and indenting like this is commonly used in
the kernel.

Rob
