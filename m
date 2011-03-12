Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224Ab1CLCOW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 21:14:22 -0500
Received: from smtp.nokia.com ([147.243.128.26]:35542 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753675Ab1CLCOV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 21:14:21 -0500
Date: Sat, 12 Mar 2011 04:10:22 +0200
From: Phil Carmody <ext-phil.2.carmody@nokia.com>
To: ext Andrew Morton <akpm@linux-foundation.org>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, sboyd@codeaurora.org
Subject: Re: [PATCH 3/4] calibrate: retry with wider bounds when converge
	seems to fail
Message-ID: <20110312021022.GC3823@esdhcp04044.research.nokia.com>
References: <1299768487-13200-1-git-send-email-ext-phil.2.carmody@nokia.com> <1299768487-13200-2-git-send-email-ext-phil.2.carmody@nokia.com> <1299768487-13200-3-git-send-email-ext-phil.2.carmody@nokia.com> <1299768487-13200-4-git-send-email-ext-phil.2.carmody@nokia.com> <20110311152744.ad5ef129.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110311152744.ad5ef129.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/03/11 15:27 -0800, ext Andrew Morton wrote:
> This is more informative, no?
>
> --- a/init/calibrate.c~calibrate-retry-with-wider-bounds-when-converge-seems-to-fail-fix
> +++ a/init/calibrate.c
> @@ -172,7 +172,7 @@ recalibrate:
>  	/*
>  	 * If we incremented every single time possible, presume we've
>  	 * massively underestimated initially, and retry with a higher
> -	 * start, and larger range. (Only seen on x86_64.)
> +	 * start, and larger range. (Only seen on x86_64, due to SMIs)
>  	 */
>  	if (lpj + loopadd * 2 == lpj_base + loopadd_base * 2) {
>  		lpj_base = lpj;
> _

Works for me. Thanks.

Phil

