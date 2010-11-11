Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756628Ab0KKUU6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 15:20:58 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:55932 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756149Ab0KKUU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 15:20:57 -0500
Date: Thu, 11 Nov 2010 13:20:48 -0700
From: "Mark A. Greer" <mgreer@mvista.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        "Mark A. Greer" <mgreer@mvista.com>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] rtc: rtc-omap - fix a memory leak
Message-ID: <20101111202048.GB12704@mag.az.mvista.com>
References: <1289356640.13311.1.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289356640.13311.1.camel@mola>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 10:37:20AM +0800, Axel Lin wrote:
> request_mem_region() will call kzalloc to allocate memory for struct resource.
> release_resource() unregisters the resource but does not free the allocated
> memory, thus use release_mem_region() instead to fix the memory leak.
> 
> Also add a missing iounmap() in omap_rtc_remove().
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

FWIW,

Acked-by: Mark A. Greer <mgreer@mvista.com>
