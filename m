Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077Ab2K3VVq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 16:21:46 -0500
Received: from mms3.broadcom.com ([216.31.210.19]:2304 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751645Ab2K3VVo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 16:21:44 -0500
X-Server-Uuid: B86B6450-0931-4310-942E-F00ED04CA7AF
Message-ID: <50B9235D.7050309@broadcom.com>
Date: Fri, 30 Nov 2012 22:21:33 +0100
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0
 Thunderbird/17.0
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
cc: linux-kernel@vger.kernel.org, tglx@linutronix.de,
        backports@vger.kernel.org, alexander.stein@systec-electronic.com,
        brudley@broadcom.com, rvossen@broadcom.com, frankyl@broadcom.com,
        kanyan@broadcom.com, linux-wireless@vger.kernel.org,
        brcm80211-dev-list@broadcom.com, kyungmin.park@samsung.com,
        s.nawrocki@samsung.com, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, daniel.vetter@ffwll.ch,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        srinidhi.kasagar@stericsson.com, linus.walleij@linaro.org,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 0/6] drivers: convert struct spinlock to spinlock_t
References: <1354221910-22493-1-git-send-email-mcgrof@do-not-panic.com>
 <50B87082.3020604@broadcom.com>
 <CAB=NE6UO8jPYOktteaLeihVqLp251-Q=jv5z_OThXoR+JtRKeg@mail.gmail.com>
 <CAB=NE6UVA1As_07HOvCbi4oK+CgbNNeeNMfz8agB-00ZRP973w@mail.gmail.com>
In-Reply-To: <CAB=NE6UVA1As_07HOvCbi4oK+CgbNNeeNMfz8agB-00ZRP973w@mail.gmail.com>
X-Enigmail-Version: 1.4.6
X-WSS-ID: 7CA7FDD539W2708228-01-01
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/30/2012 09:25 PM, Luis R. Rodriguez wrote:
> On Fri, Nov 30, 2012 at 11:18 AM, Luis R. Rodriguez
> <mcgrof@do-not-panic.com> wrote:
>> On Fri, Nov 30, 2012 at 12:38 AM, Arend van Spriel <arend@broadcom.com> wrote:
>>> So what is the rationale here. During mainlining our drivers we had to
>>> remove all uses of 'typedef struct foo foo_t;'. The Linux CodingStyle
>>> (chapter 5 Typedefs) is spending a number of lines explaining why.
>>>
>>> So is spinlock_t an exception to this rule simply because the kernel
>>> uses spinlock_t all over the place.
>>
>> Yes.
> 
> Let me provide a better explanation. In practice drivers should not be
> creating their own typedefs given that generally the reasons to create
> them do not exist for drivers. The kernel may provide their own though
> for reasons explained in CodingStyle and in such cases the drivers
> should use these supplied typedefs.

Ok. Fine by me. It just looked like a case of saying a and doing b.
Thanks for taking time giving the better explanation :-)

Gr. AvS


