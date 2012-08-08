Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758993Ab2HHRfm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 13:35:42 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39932 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755622Ab2HHRfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 13:35:40 -0400
Message-ID: <5022A369.5020304@vflare.org>
Date: Wed, 08 Aug 2012 10:35:37 -0700
From: Nitin Gupta <ngupta@vflare.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>
Subject: Re: [PATCH 0/7] zram/zsmalloc promotion
References: <1344406340-14128-1-git-send-email-minchan@kernel.org>
In-Reply-To: <1344406340-14128-1-git-send-email-minchan@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2012 11:12 PM, Minchan Kim wrote:
> This patchset promotes zram/zsmalloc from staging.
> Both are very clean and zram is used by many embedded product
> for a long time.
> 
> [1-3] are patches not merged into linux-next yet but needed
> it as base for [4-5] which promotes zsmalloc.
> Greg, if you merged [1-3] already, skip them.
> 
> Seth Jennings (5):
>   1. zsmalloc: s/firstpage/page in new copy map funcs
>   2. zsmalloc: prevent mappping in interrupt context
>   3. zsmalloc: add page table mapping method
>   4. zsmalloc: collapse internal .h into .c
>   5. zsmalloc: promote to mm/
> 
> Minchan Kim (2):
>   6. zram: promote zram from staging
>   7. zram: select ZSMALLOC when ZRAM is configured
> 

All the changes look good to me. FWIW, for the entire series:
Acked-by: Nitin Gupta <ngupta@vflare.org>

Thanks for all the work.
Nitin


