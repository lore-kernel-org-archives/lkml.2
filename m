Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266Ab2DYMl3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 08:41:29 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:57988 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972Ab2DYMl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 08:41:28 -0400
Message-ID: <4F97F0F1.2000506@vflare.org>
Date: Wed, 25 Apr 2012 08:41:21 -0400
From: Nitin Gupta <ngupta@vflare.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 0/6] zsmalloc: clean up and fix arch dependency
References: <1335334994-22138-1-git-send-email-minchan@kernel.org>
In-Reply-To: <1335334994-22138-1-git-send-email-minchan@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Minchan,

On 04/25/2012 02:23 AM, Minchan Kim wrote:

> This patchset has some clean up patches(1-5) and remove 
> set_bit, flush_tlb for portability in [6/6].
> 
> Minchan Kim (6):
>   zsmalloc: use PageFlag macro instead of [set|test]_bit
>   zsmalloc: remove unnecessary alignment
>   zsmalloc: rename zspage_order with zspage_pages
>   zsmalloc: add/fix function comment
>   zsmalloc: remove unnecessary type casting
>   zsmalloc: make zsmalloc portable
> 
>  drivers/staging/zsmalloc/Kconfig         |    4 --
>  drivers/staging/zsmalloc/zsmalloc-main.c |   73 +++++++++++++++++-------------
>  drivers/staging/zsmalloc/zsmalloc_int.h  |    3 +-
>  3 files changed, 43 insertions(+), 37 deletions(-)
> 


Thanks for the fixes.


Your description is missing testing notes (especially since patch [6/6]
is not a cosmetic change). So, can you please add these either here in
patch 0 or as part of patch 6/6 description?

Thanks,
Nitin
