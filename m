Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757231Ab3AIKuJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 05:50:09 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39847 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755762Ab3AIKuH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 05:50:07 -0500
Date: Wed, 9 Jan 2013 11:50:03 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Javi Merino <javi.merino@arm.com>
Cc: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] of: add missing documentation for
 of_platform_populate()
In-Reply-To: <1353687908-17215-1-git-send-email-javi.merino@arm.com>
Message-ID: <alpine.LNX.2.00.1301091149541.12134@pobox.suse.cz>
References: <1353687908-17215-1-git-send-email-javi.merino@arm.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Nov 2012, Javi Merino wrote:

> 15c3597d (dt/platform: allow device name to be overridden) added a
> lookup parameter to of_platform_populate() but did not update the
> documentation.  This patch adds the missing documentation entry.
> 
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Jiri Kosina <trivial@kernel.org>
> Signed-off-by: Javi Merino <javi.merino@arm.com>
> ---
>  drivers/of/platform.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/of/platform.c b/drivers/of/platform.c
> index b80891b..e0a6514 100644
> --- a/drivers/of/platform.c
> +++ b/drivers/of/platform.c
> @@ -436,6 +436,7 @@ EXPORT_SYMBOL(of_platform_bus_probe);
>   * of_platform_populate() - Populate platform_devices from device tree data
>   * @root: parent of the first level to probe or NULL for the root of the tree
>   * @matches: match table, NULL to use the default
> + * @lookup: auxdata table for matching id and platform_data with device nodes
>   * @parent: parent to hook devices from, NULL for toplevel
>   *
>   * Similar to of_platform_bus_probe(), this function walks the device tree

Applied.

-- 
Jiri Kosina
SUSE Labs
