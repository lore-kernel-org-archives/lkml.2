Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165Ab2ECNST (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 09:18:19 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:33800 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753807Ab2ECNSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 09:18:18 -0400
Message-ID: <4FA2859A.5050803@vflare.org>
Date: Thu, 03 May 2012 09:18:18 -0400
From: Nitin Gupta <ngupta@vflare.org>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/4] zsmalloc: rename zspage_order with zspage_pages
References: <1336027242-372-1-git-send-email-minchan@kernel.org>
In-Reply-To: <1336027242-372-1-git-send-email-minchan@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/3/12 2:40 AM, Minchan Kim wrote:
> zspage_order defines how many pages are needed to make a zspage.
> So_order_  is rather awkward naming. It already deceive Jonathan
> -http://lwn.net/Articles/477067/
> " For each size, the code calculates an optimum number of pages (up to 16)"
>
> Let's change from_order_  to_pages_  and some function names.
>
> Signed-off-by: Minchan Kim<minchan@kernel.org>
> ---
>   drivers/staging/zsmalloc/zsmalloc-main.c |   14 +++++++-------
>   drivers/staging/zsmalloc/zsmalloc_int.h  |    2 +-
>   2 files changed, 8 insertions(+), 8 deletions(-)

Acked-by: Nitin Gupta <ngupta@vflare.org>

Thanks,
Nitin
