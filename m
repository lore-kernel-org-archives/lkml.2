Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758999Ab2DYMs5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 08:48:57 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:35101 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754680Ab2DYMoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 08:44:04 -0400
Message-ID: <4F97F18E.4000600@vflare.org>
Date: Wed, 25 Apr 2012 08:43:58 -0400
From: Nitin Gupta <ngupta@vflare.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/6] zsmalloc: use PageFlag macro instead of [set|test]_bit
References: <1335334994-22138-1-git-send-email-minchan@kernel.org> <1335334994-22138-2-git-send-email-minchan@kernel.org>
In-Reply-To: <1335334994-22138-2-git-send-email-minchan@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2012 02:23 AM, Minchan Kim wrote:

> MM code always uses PageXXX to handle page flags.
> Let's keep the consistency.
> 
> Signed-off-by: Minchan Kim <minchan@kernel.org>
> ---
>  drivers/staging/zsmalloc/zsmalloc-main.c |    9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
>



Acked-by: Nitin Gupta <ngupta@vflare.org>

Thanks,
Nitin
