Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751992Ab1LZGwT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Dec 2011 01:52:19 -0500
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:38106 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751340Ab1LZGwI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Dec 2011 01:52:08 -0500
MIME-Version: 1.0
In-Reply-To: <CAF6AEGs-Xgi_kmz5oag76=4v20RP5PfAM2-pyt_PyvWizgdW8Q@mail.gmail.com>
References: <1324283611-18344-1-git-send-email-sumit.semwal@ti.com>
 <20111220193117.GD3883@phenom.ffwll.local> <CAPM=9tzi5MyCBMJhWBM_ouL=QOaxX3K6KZ8K+t7dUYJLQrF+yA@mail.gmail.com>
 <CAB2ybb-+VTR=V1hwhF1GKxgkhTrssZ1JVOwcP6spO5O3AXqivA@mail.gmail.com> <CAF6AEGs-Xgi_kmz5oag76=4v20RP5PfAM2-pyt_PyvWizgdW8Q@mail.gmail.com>
From: "Semwal, Sumit" <sumit.semwal@ti.com>
Date: Mon, 26 Dec 2011 12:21:45 +0530
Message-ID: <CAB2ybb-iAN_GPoUkPaEgUyhZmm9mZfoC9cf6oeaPehhCnHGu4g@mail.gmail.com>
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

On Fri, Dec 23, 2011 at 10:50 PM, Rob Clark <rob@ti.com> wrote:
> On Fri, Dec 23, 2011 at 4:08 AM, Semwal, Sumit <sumit.semwal@ti.com> wrote:
>> On Wed, Dec 21, 2011 at 1:50 AM, Dave Airlie <airlied@gmail.com> wrote:
>> <snip>
>>>>
>>>> Hence for both patches:
>>>> Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
>>>
>>> Yeah I'm with Daniel, I like this one, I can definitely build the drm
>>> buffer sharing layer on top of this.
>>>
>>> How do we see this getting merged? I'm quite happy to push it to Linus
>>> if we don't have an identified path, though it could go via a Linaro
>>> tree as well.
>>>
>>> so feel free to add:
>>> Reviewed-by: Dave Airlie <airlied@redhat.com>
>> Thanks Daniel and Dave!
>>
>> I guess we can start with staging for 3.3, and see how it shapes up. I
>> will post the latest patch version pretty soon.
>
> not sure about staging, but could make sense to mark as experimental.
Thanks, I will mark it experimental for the first version; we can
remove that once it is more widely used and tested.
>
>> Arnd, Dave: do you have any preference on the path it takes to get
>> merged? In my mind, Linaro tree might make more sense, but I would
>> leave it upto you gentlemen.
>
> Looks like Dave is making some progress on drm usage of buffer sharing
> between gpu's.. if that is ready to go in at the same time, it might
> be a bit logistically simpler for him to put dmabuf in the same pull
> req.  I don't have strong preference one way or another, so do what is
> collectively simpler ;-)
:) Right - I am quite happy for it to get merged in either ways :)
>
> BR,
> -R
Best regards,
~Sumit.
