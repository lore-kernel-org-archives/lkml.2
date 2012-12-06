Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423849Ab2LFPUr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 10:20:47 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:40769 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423589Ab2LFPUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 10:20:46 -0500
Date: Thu, 6 Dec 2012 07:17:26 -0800
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        Jason Wessel <jason.wessel@windriver.com>,
        John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: Re: [PATCH resend 0/4] ARM: KDB FIQ debugger
Message-ID: <20121206151726.GA23394@lizard>
References: <20121123002957.GA31679@lizard.mcd25758.sjc.wayport.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20121123002957.GA31679@lizard.mcd25758.sjc.wayport.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 22, 2012 at 04:29:57PM -0800, Anton Vorontsov wrote:
> Hello Andrew, Russell,
> 
> The KDB/NMI core support has been merged into v3.7-rc1, so the only ARM
> bits are pending now.
> 
> I addressed all the comments ~two month ago, and since then just resending
> these patches. I know we're all busy, so no blaming. :) But then let's
> pass this via -mm?

Guys, could someone take a look at this?.. Considering the low impact of
this series (it mostly adds code, and the only modification part the one
that just moves things around), maybe it still has some chance to get into
3.9?

Thanks,
Anton.
