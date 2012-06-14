Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755032Ab2FNBfh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 21:35:37 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:42214 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752963Ab2FNBfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 21:35:36 -0400
X-AuditID: 9c93016f-b7c3cae000001954-02-4fd93fe679b8
Message-ID: <4FD93FE8.1030102@kernel.org>
Date: Thu, 14 Jun 2012 10:35:36 +0900
From: Minchan Kim <minchan@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] staging: zsmalloc: fix uninit'ed variable warning
References: <1339621422-8449-1-git-send-email-sjenning@linux.vnet.ibm.com>
In-Reply-To: <1339621422-8449-1-git-send-email-sjenning@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Seth,

On 06/14/2012 06:03 AM, Seth Jennings wrote:

> This patch fixes an uninitialized variable warning in
> alloc_zspage().  It also fixes the secondary issue of
> prev_page leaving scope on each loop iteration.  The only
> reason this ever worked was because prev_page was occupying
> the same space on the stack on each iteration.
> 
> Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>


Nice catch!

Acked-by: Minchan Kim <minchan@kernel.org>

Nitpick:
I can't see the warning.
My gcc version is gcc (Ubuntu/Linaro 4.6.3-1ubuntu5) 4.6.3.

Please, Cced linux-mm, too.
Some guys in mm might have a interest in zsmalloc. :)

-- 
Kind regards,
Minchan Kim
