Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965443Ab2EWTTw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 15:19:52 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:57235 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965426Ab2EWTTt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 15:19:49 -0400
Message-ID: <4FBD373A.5030109@linux.vnet.ibm.com>
Date: Wed, 23 May 2012 14:15:06 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Nitin Gupta <ngupta@vflare.org>
Subject: Re: [PATCH 1/2 v2] zsmalloc: zsmalloc: use unsigned long instead
 of void *
References: <1337737402-16543-1-git-send-email-minchan@kernel.org>
In-Reply-To: <1337737402-16543-1-git-send-email-minchan@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12052319-8974-0000-0000-000009617330
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2012 08:43 PM, Minchan Kim wrote:

> We should use unsigned long as handle instead of void * to avoid any
> confusion. Without this, users may just treat zs_malloc return value as
> a pointer and try to deference it.
> 
> This patch passed compile test(zram, zcache and ramster) and zram is
> tested on qemu.
> 
> changelog
>   * from v1
>  	- change zcache's zv_create return value
>         - baesd on next-20120522
> 
> Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>
> Cc: Dan Magenheimer <dan.magenheimer@oracle.com>
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Cc: Nitin Gupta <ngupta@vflare.org>
> Signed-off-by: Minchan Kim <minchan@kernel.org>


Acked-by: Seth Jennings <sjenning@linux.vnet.ibm.com>

Thanks,
Seth

