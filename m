Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992Ab2GQNPq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 09:15:46 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:39726 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824Ab2GQNPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 09:15:44 -0400
MIME-Version: 1.0
In-Reply-To: <CAMuHMdXFfMv-DV-89nueyDJ5AvFN3AXR_6ysWOfCMDFL46s-Cg@mail.gmail.com>
References: <1341784614-2797-1-git-send-email-dh.herrmann@googlemail.com>
	<1341784614-2797-12-git-send-email-dh.herrmann@googlemail.com>
	<CAMuHMdX_aC1hzKf1eRqoSsQ4oALBev8p77v7++aoB2KrkOUaEw@mail.gmail.com>
	<CANq1E4RyFpqxH=uG+dDA1=kfc3r8rCoEesZ31op9rCLjxyk6mQ@mail.gmail.com>
	<CAMuHMdXFfMv-DV-89nueyDJ5AvFN3AXR_6ysWOfCMDFL46s-Cg@mail.gmail.com>
Date: Tue, 17 Jul 2012 15:15:43 +0200
Message-ID: <CANq1E4SmdRaN5YEVdGrJohD2ZdXrhzAar6VmM6RyErKXjadN5A@mail.gmail.com>
Subject: Re: [PATCH v2 11/11] MAINTAINERS: add fblog entry
From: David Herrmann <dh.herrmann@googlemail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        florianschandinat@gmx.de, linux-fbdev@vger.kernel.org,
        gregkh@linuxfoundation.org, alan@lxorguk.ukuu.org.uk,
        bonbons@linux-vserver.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert

On Tue, Jul 17, 2012 at 2:57 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> On Mon, Jul 9, 2012 at 8:38 PM, David Herrmann
> <dh.herrmann@googlemail.com> wrote:
>>>> diff --git a/MAINTAINERS b/MAINTAINERS
>>>> index ae8fe46..249b02a 100644
>>>> --- a/MAINTAINERS
>>>> +++ b/MAINTAINERS
>>>> @@ -2854,6 +2854,12 @@ F:       drivers/video/
>>>>  F:     include/video/
>>>>  F:     include/linux/fb.h
>>>>
>>>> +FRAMEBUFFER LOG DRIVER
>>>> +M:     David Herrmann <dh.herrmann@googlemail.com>
>>>> +L:     linux-serial@vger.kernel.org
>>>
>>> Why linux-serial, and not linux-fbdev?
>>
>> I thought fbcon was maintained on linux-serial as it is very related
>
> It has always been maintained on linux-fbdev.

Thanks! Then I will change this to linux-fbdev.

Regards
David
