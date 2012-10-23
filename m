Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933762Ab2JWWqL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 18:46:11 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61275 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754499Ab2JWWqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 18:46:09 -0400
Date: Tue, 23 Oct 2012 15:46:06 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Kees Cook <keescook@chromium.org>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Beulich <JBeulich@novell.com>, Mel Gorman <mel@csn.ul.ie>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>
Subject: Re: [PATCH 158/193] mm: remove CONFIG_EXPERIMENTAL
In-Reply-To: <1351022666-6960-159-git-send-email-keescook@chromium.org>
Message-ID: <alpine.DEB.2.00.1210231545030.1221@chino.kir.corp.google.com>
References: <1351022666-6960-1-git-send-email-keescook@chromium.org> <1351022666-6960-159-git-send-email-keescook@chromium.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Oct 2012, Kees Cook wrote:

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

This makes ARCH_SELECT_MEMORY_MODEL pointless, why keep it around?
