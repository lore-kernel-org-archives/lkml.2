Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753727Ab1LWFo6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 00:44:58 -0500
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:40419 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750718Ab1LWFo4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 00:44:56 -0500
MIME-Version: 1.0
In-Reply-To: <CAF6AEGt9Ae_zVmhBmmtfyKrqC4EyBgAAO1RWdK_UhY-1RLfOSQ@mail.gmail.com>
References: <1324283611-18344-1-git-send-email-sumit.semwal@ti.com>
 <20111220193117.GD3883@phenom.ffwll.local> <CAPM=9tzi5MyCBMJhWBM_ouL=QOaxX3K6KZ8K+t7dUYJLQrF+yA@mail.gmail.com>
 <CAF6AEGt9Ae_zVmhBmmtfyKrqC4EyBgAAO1RWdK_UhY-1RLfOSQ@mail.gmail.com>
From: "Semwal, Sumit" <sumit.semwal@ti.com>
Date: Fri, 23 Dec 2011 11:14:34 +0530
Message-ID: <CAB2ybb-CN9-APAqGBjm7tzHDfpuih0vN2Wry1_RqxujxVOy=OA@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] [RFC v3 0/2] Introduce DMA buffer sharing mechanism
To: Rob Clark <rob@ti.com>
Cc: Dave Airlie <airlied@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
        linaro-mm-sig@lists.linaro.org, dri-devel@lists.freedesktop.org,
        linux-media@vger.kernel.org, linux@arm.linux.org.uk, arnd@arndb.de,
        jesse.barker@linaro.org, m.szyprowski@samsung.com,
        t.stanislaws@samsung.com, patches@linaro.org, daniel@ffwll.ch
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 21, 2011 at 3:56 AM, Rob Clark <rob@ti.com> wrote:
> On Tue, Dec 20, 2011 at 2:20 PM, Dave Airlie <airlied@gmail.com> wrote:
>>>>
<snip>
>>>
>>> I think this is a really good v1 version of dma_buf. It contains all the
>>> required bits (with well-specified semantics in the doc patch) to
>>> implement some basic use-cases and start fleshing out the integration with
>>> various subsystem (like drm and v4l). All the things still under
>>> discussion like
>>> - userspace mmap support
>>> - more advanced (and more strictly specified) coherency models
>>> - and shared infrastructure for implementing exporters
>>> are imo much clearer once we have a few example drivers at hand and a
>>> better understanding of some of the insane corner cases we need to be able
>>> to handle.
>>>
>>> And I think any risk that the resulting clarifications will break a basic
>>> use-case is really minimal, so I think it'd be great if this could go into
>>> 3.3 (maybe as some kind of staging/experimental infrastructure).
>>>
>>> Hence for both patches:
>>> Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
>>
>> Yeah I'm with Daniel, I like this one, I can definitely build the drm
>> buffer sharing layer on top of this.
>>
>> How do we see this getting merged? I'm quite happy to push it to Linus
>> if we don't have an identified path, though it could go via a Linaro
>> tree as well.
>>
>> so feel free to add:
>> Reviewed-by: Dave Airlie <airlied@redhat.com>
>
> fwiw, patches to share buffers between drm and v4l2 are here:
>
> https://github.com/robclark/kernel-omap4/commits/drmplane-dmabuf
>
> (need a bit of cleanup before the vb2 patches are submitted.. but that
> is unrelated to the dmabuf patches)
>
> so,
>
> Reviewed-and-Tested-by: Rob Clark <rob.clark@linaro.org>
Thanks Daniel, Dave, and Rob!
BR,
Sumit.
>
>> Dave.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
