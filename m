Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933412Ab2KFBWk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 20:22:40 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36294 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933270Ab2KFBWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 20:22:38 -0500
Date: Mon, 5 Nov 2012 17:22:35 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Kees Cook <keescook@chromium.org>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Beulich <JBeulich@novell.com>, Mel Gorman <mel@csn.ul.ie>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>
Subject: Re: [PATCH 103/104] mm: remove depends on CONFIG_EXPERIMENTAL
In-Reply-To: <1352156701-4038-104-git-send-email-keescook@chromium.org>
Message-ID: <alpine.DEB.2.00.1211051721030.24937@chino.kir.corp.google.com>
References: <1352156701-4038-1-git-send-email-keescook@chromium.org> <1352156701-4038-104-git-send-email-keescook@chromium.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Nov 2012, Kees Cook wrote:

> diff --git a/mm/Kconfig b/mm/Kconfig
> index a3f8ddd..679945e 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -1,6 +1,5 @@
>  config SELECT_MEMORY_MODEL
>  	def_bool y
> -	depends on EXPERIMENTAL || ARCH_SELECT_MEMORY_MODEL
>  
>  choice
>  	prompt "Memory model"

I thought you agreed to only drop EXPERIMENTAL here in 
http://marc.info/?l=linux-kernel&m=135103415901094 and leave 
ARCH_SELECT_MEMORY_MODEL, which you've orphaned with the above, for phase 
two of your effort?
