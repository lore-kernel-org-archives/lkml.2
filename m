Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752489Ab2A3Lda (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 06:33:30 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:56650 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862Ab2A3Ld3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 06:33:29 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1201301125270.1934@localhost6.localdomain6>
References: <alpine.DEB.2.02.1201282026500.1973@hadrien>
	<CAPM=9twMwts87HLEKCMd68etvwyrS=rDxRcytCPU+7_7MonpZQ@mail.gmail.com>
	<alpine.DEB.2.02.1201301125270.1934@localhost6.localdomain6>
Date: Mon, 30 Jan 2012 06:33:29 -0500
Message-ID: <CAHdPZaM5XrTFHokscuxHMh=MXjBync4HnQUCGTCxP+W=9hAj=A@mail.gmail.com>
Subject: Re: question about drivers/gpu/drm/drm_ioc32.c
From: "devendra.aaru" <devendra.aaru@gmail.com>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: Dave Airlie <airlied@gmail.com>, airlied@linux.ie,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 30, 2012 at 5:28 AM, Julia Lawall <julia.lawall@lip6.fr> wrote:
> On Mon, 30 Jan 2012, Dave Airlie wrote:
>
>> On Sat, Jan 28, 2012 at 7:28 PM, Julia Lawall <julia.lawall@lip6.fr>
>> wrote:
>>>
>>> In the function compat_drm_getclient, I have the impression that the
>>> structure c32 is copied to user level with the field idx uninitialized?
>>
>>
>> Looks like it alright,
>>
>> care to send a patch?
>
>
> What should it be initialized to?  The idx value that was got and put
> earlier?
>
> thanks,
> julia
>
There was again a variable in drm_client32_t struct, idx which was
uninitialised.
c32.idx = idx is ok?

Thanks,
Dev.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
