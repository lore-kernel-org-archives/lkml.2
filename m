Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064Ab2HKPRF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2012 11:17:05 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:41512 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661Ab2HKPRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2012 11:17:03 -0400
MIME-Version: 1.0
In-Reply-To: <20120810193210.GG5738@phenom.ffwll.local>
References: <20120810145728.5490.44707.stgit@patser.local>
	<20120810193210.GG5738@phenom.ffwll.local>
Date: Sat, 11 Aug 2012 10:17:02 -0500
X-Google-Sender-Auth: Y5a4NsZf0N6iD5COunk_hqGLyGQ
Message-ID: <CAF6AEGs8AzrQBhw523kFrJp-C_y3-TdL7HWy5FfYVUO2U-poOA@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] [PATCH 1/4] dma-buf: remove fallback for !CONFIG_DMA_SHARED_BUFFER
From: Rob Clark <rob.clark@linaro.org>
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        sumit.semwal@linaro.org, rob.clark@linaro.org,
        linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 10, 2012 at 2:32 PM, Daniel Vetter <daniel@ffwll.ch> wrote:
> On Fri, Aug 10, 2012 at 04:57:43PM +0200, Maarten Lankhorst wrote:
>> Documentation says that code requiring dma-buf should add it to
>> select, so inline fallbacks are not going to be used. A link error
>> will make it obvious what went wrong, instead of silently doing
>> nothing at runtime.
>>
>> Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
>
> I've botched it more than once to update these when creating new dma-buf
> code. Hence
>
> Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>

yeah, I think the fallbacks date back to when it was a user
configurable option, rather than something select'd by drivers using
dmabuf, and we just never went back to clean up.  Let's drop the
fallbacks.

Reviewed-by: Rob Clark <rob.clark@linaro.org>


> --
> Daniel Vetter
> Mail: daniel@ffwll.ch
> Mobile: +41 (0)79 365 57 48
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
