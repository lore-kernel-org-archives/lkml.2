Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751335Ab0KHFsu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 00:48:50 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:45484 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860Ab0KHFst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 00:48:49 -0500
Date: Mon, 8 Nov 2010 14:48:28 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] rtc: rtc-sh - fix a memory leak
Message-ID: <20101108054828.GA11991@linux-sh.org>
References: <1289194510.682.5.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289194510.682.5.camel@mola>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 08, 2010 at 01:35:10PM +0800, Axel Lin wrote:
> request_mem_region() will call kzalloc to allocate memory for struct resource.
> release_resource() unregisters the resource but does not free the allocated
> memory, thus use release_mem_region() instead to fix the memory leak.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Good catch! Applied, thanks.
