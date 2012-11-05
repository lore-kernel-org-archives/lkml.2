Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754322Ab2KENoU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 08:44:20 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:45014 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217Ab2KENoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 08:44:18 -0500
Date: Mon, 5 Nov 2012 14:44:13 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Pawel Moll <pawel.moll@arm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] virtio-mmio: Fix irq parsing in command line parameter
Message-ID: <20121105134413.GC5220@gmail.com>
References: <1352120454.10947.5.camel@hornet>
 <1352120572-16256-1-git-send-email-pawel.moll@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1352120572-16256-1-git-send-email-pawel.moll@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 05 Nov 2012, Pawel Moll wrote:

> On 64-bit machines resource_size_t is a 64-bit value, while
> sscanf() format for this argument was defined as "%u". Fixed
> by using an intermediate local value of a known length.
> 
> Also added cleaned up the resource creation and adde extra
> comments to make the parameters parsing easier to follow.
> 
> Reported-by: Lee Jones <lee.jones@linaro.org>
> Signed-off-by: Pawel Moll <pawel.moll@arm.com>
> ---
>  drivers/virtio/virtio_mmio.c |   26 ++++++++++++++++++--------
>  1 file changed, 18 insertions(+), 8 deletions(-)

Resorted to poaching now have we Pawel? ;)

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
