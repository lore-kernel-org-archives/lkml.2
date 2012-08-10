Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757599Ab2HJTbx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 15:31:53 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:37028 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832Ab2HJTbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 15:31:51 -0400
Date: Fri, 10 Aug 2012 21:32:10 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: sumit.semwal@linaro.org, rob.clark@linaro.org,
        linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Subject: Re: [Linaro-mm-sig] [PATCH 1/4] dma-buf: remove fallback for
 !CONFIG_DMA_SHARED_BUFFER
Message-ID: <20120810193210.GG5738@phenom.ffwll.local>
Mail-Followup-To: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
	sumit.semwal@linaro.org, rob.clark@linaro.org,
	linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
References: <20120810145728.5490.44707.stgit@patser.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120810145728.5490.44707.stgit@patser.local>
X-Operating-System: Linux phenom 3.4.0-rc3+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 10, 2012 at 04:57:43PM +0200, Maarten Lankhorst wrote:
> Documentation says that code requiring dma-buf should add it to
> select, so inline fallbacks are not going to be used. A link error
> will make it obvious what went wrong, instead of silently doing
> nothing at runtime.
> 
> Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>

I've botched it more than once to update these when creating new dma-buf
code. Hence

Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
