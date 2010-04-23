Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696Ab0DWUIE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 16:08:04 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:43148 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756053Ab0DWUH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 16:07:59 -0400
Date: Fri, 23 Apr 2010 13:07:36 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] bcache: ver 3
Message-Id: <20100423130736.79db708a.randy.dunlap@oracle.com>
In-Reply-To: <20100423194107.GA20322@moria>
References: <20100423194107.GA20322@moria>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090207.4BD1FE1C.0082:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Apr 2010 11:41:07 -0800 Kent Overstreet wrote:

> diff --git a/block/Kconfig b/block/Kconfig
> index f9e89f4..85adf8d 100644
> --- a/block/Kconfig
> +++ b/block/Kconfig
> @@ -100,6 +100,11 @@ config DEBUG_BLK_CGROUP
>  	in the blk group which can be used by cfq for tracing various
>  	group related activity.
>  
> +config BLK_CACHE
> +	tristate "Block device as cache"
> +	select SLOW_WORK
> +	default m

	help
	  <some explanatory help text>
please.  The tristate prompt didn't do anything for me.

> +
>  endif # BLOCK


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
