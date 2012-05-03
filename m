Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380Ab2ECNc5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 09:32:57 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:63680 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687Ab2ECNc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 09:32:56 -0400
Message-ID: <4FA28907.9020300@vflare.org>
Date: Thu, 03 May 2012 09:32:55 -0400
From: Nitin Gupta <ngupta@vflare.org>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH 3/4] zsmalloc use zs_handle instead of void *
References: <1336027242-372-1-git-send-email-minchan@kernel.org> <1336027242-372-3-git-send-email-minchan@kernel.org>
In-Reply-To: <1336027242-372-3-git-send-email-minchan@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/3/12 2:40 AM, Minchan Kim wrote:
> We should use zs_handle instead of void * to avoid any
> confusion. Without this, users may just treat zs_malloc return value as
> a pointer and try to deference it.
>
> Cc: Dan Magenheimer<dan.magenheimer@oracle.com>
> Cc: Konrad Rzeszutek Wilk<konrad.wilk@oracle.com>
> Signed-off-by: Minchan Kim<minchan@kernel.org>
> ---
>   drivers/staging/zcache/zcache-main.c     |    8 ++++----
>   drivers/staging/zram/zram_drv.c          |    8 ++++----
>   drivers/staging/zram/zram_drv.h          |    2 +-
>   drivers/staging/zsmalloc/zsmalloc-main.c |   28 ++++++++++++++--------------
>   drivers/staging/zsmalloc/zsmalloc.h      |   15 +++++++++++----
>   5 files changed, 34 insertions(+), 27 deletions(-)

This was a long pending change. Thanks!

Acked-by: Nitin Gupta <ngupta@vflare.org>


  - Nitin

