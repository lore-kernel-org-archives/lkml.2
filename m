Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932883Ab1IBBIS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 21:08:18 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36324 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932809Ab1IBBIQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 21:08:16 -0400
MIME-Version: 1.0
In-Reply-To: <CAH9JG2Xh6oWOOg85KEf+Di4aVS4Zd_O3LfaWKZ1ig7A6pffgEA@mail.gmail.com>
References: <1314359274-21585-1-git-send-email-inki.dae@samsung.com>
	<CAF6AEGu3ss-rJC28H1rm2GWLm1bAZnHLftXfMLJQNeqjBt3umQ@mail.gmail.com>
	<001001cc67aa$72760460$57620d20$%dae@samsung.com>
	<CAF6AEGsqbFcS_QwihrjpVLQK1Y+h1iJSyu+GFV0Govp3XHYbOw@mail.gmail.com>
	<003501cc68a7$e8935aa0$b9ba0fe0$%dae@samsung.com>
	<CAH9JG2Xh6oWOOg85KEf+Di4aVS4Zd_O3LfaWKZ1ig7A6pffgEA@mail.gmail.com>
Date: Thu, 1 Sep 2011 20:08:14 -0500
Message-ID: <CAF6AEGuSpsZ_LFWOk2fSR5=cqmFMf7iH+y_En5hpu+7iF4EecQ@mail.gmail.com>
Subject: Re: [RFC][PATCH v3] DRM: add DRM Driver for Samsung SoC EXYNOS4210.
From: Rob Clark <robdclark@gmail.com>
To: Kyungmin Park <kmpark@infradead.org>
Cc: Inki Dae <inki.dae@samsung.com>, airlied@linux.ie, sw0312.kim@samsung.com,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 1, 2011 at 8:02 PM, Kyungmin Park <kmpark@infradead.org> wrote:
>>> Just thinking hypothetically.. what if some future device had two hdmi
>>> controllers.  Then you'd want two instances of the same display
>>> object.
>>>
>>> Although it seems this API is just internal to the DRM driver (which I
>>> had not realized earlier), so it should be pretty easy to change later
>>> if needed.
>>>
>>
>> You are right. I guess we should consider multiple instances to display
>> object because the Exynos hardware has two display controllers and also each
>> display controller needs one display panel with sharing same driver. thank
>> you for your pointing. :)
>
> Two HDMI and two FIMD is different. even though exynos4 supports the
> two display controller. it has only one HDMI port and now there's no
> device to use it. Of course if new device uses it. it will support it.
> I mena currently make it simple and make it TODO list.

yeah.. since it is just an API internal to the driver, and not
external (as I initially mistakenly thought), I don't think it is an
immediate issue.  It should be easy enough to change later if you, for
example, later had hw w/ two HDMI ports.

BR,
-R

> Thank you,
> Kyungmin Park
