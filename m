Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585Ab1CBQYU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 11:24:20 -0500
Received: from xenotime.net ([184.105.210.51]:53557 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752077Ab1CBQYS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 11:24:18 -0500
Date: Wed, 2 Mar 2011 08:24:12 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: Liu Yuan <namei.unix@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, jaxboe@fusionio.com,
        akpm@linux-foundation.org, fengguang.wu@intel.com
Subject: Re: [RFC PATCH 1/5] x86/Kconfig: Add Page Cache Accounting entry
Message-Id: <20110302082412.87f153ba.rdunlap@xenotime.net>
In-Reply-To: <1299055090-23976-1-git-send-email-namei.unix@gmail.com>
References: <no>
	<1299055090-23976-1-git-send-email-namei.unix@gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  2 Mar 2011 16:38:06 +0800 Liu Yuan wrote:

> From: Liu Yuan <tailai.ly@taobao.com>
> 
> Signed-off-by: Liu Yuan <tailai.ly@taobao.com>
> ---
>  arch/x86/Kconfig.debug |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
> index 615e188..f29e32d 100644
> --- a/arch/x86/Kconfig.debug
> +++ b/arch/x86/Kconfig.debug
> @@ -304,4 +304,13 @@ config DEBUG_STRICT_USER_COPY_CHECKS
>  
>  	  If unsure, or if you run an older (pre 4.4) gcc, say N.
>  
> +config PAGE_CACHE_ACCT
> +	bool "Page cache accounting"
> +	---help---
> +	  Enabling this options to account for page cache hit/missed number of
> +	  times. This would allow user space applications get better knowledge
> +	  of underlying page cache system by reading virtual file. The statitics
> +	  per partition are collected.
> +
> +	  If unsure, say N.
>  endmenu
> -- 

rewrite:

	  Enable this option to provide for page cache hit/miss counters.
	  This allows userspace applications to obtain better knowledge of the
	  underlying page cache subsystem by reading a virtual file.
	  Statistics are collect per partition.

questions:
	what virtual file?
	what kind of partition?

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
