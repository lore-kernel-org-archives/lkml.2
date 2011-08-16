Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753030Ab1HPVkg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 17:40:36 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:43354 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465Ab1HPVkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 17:40:35 -0400
MIME-Version: 1.0
In-Reply-To: <CA+XFjiq01Ea4hivhMK=H3pgFeaoCgUWDUirD=-PzALzvOpdvvA@mail.gmail.com>
References: <1313454275-5604-1-git-send-email-me@akshayjoshi.com>
 <1313454275-5604-4-git-send-email-me@akshayjoshi.com> <CA+XFjir3W3kqin1mL5W_OEduUTyUDADwH6pL=kaS=wHpP=KMeQ@mail.gmail.com>
 <CAOJsxLGqc6khjGQMA=b1BwTv_4pv4ZgkdjJrgtMbRwuNDrN_iA@mail.gmail.com> <CA+XFjiq01Ea4hivhMK=H3pgFeaoCgUWDUirD=-PzALzvOpdvvA@mail.gmail.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Tue, 16 Aug 2011 23:40:15 +0200
Message-ID: <CA+XFjiqa84J97CxRWPNr98O2cyocwNSq5ULaKfentJXrkpPf9w@mail.gmail.com>
Subject: Re: [PATCH 4/9] Staging: Winbond: Convert C99 style comments in Winbond.
To: Pekka Enberg <penberg@kernel.org>
Cc: Akshay Joshi <me@akshayjoshi.com>, Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Karthigan Srinivasan <karthigan.srinivasan2@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p7GLemnv031344

2011/8/16 Gábor Stefanik <netrolller.3d@gmail.com>:
> 2011/8/16 Pekka Enberg <penberg@kernel.org>:
>> 2011/8/16 Gábor Stefanik <netrolller.3d@gmail.com>:
>>>> -
>>>> -//====================================
>>>> -// Internal variable for module
>>>> -//====================================
>>>> +/*============================================================================
>>>> +/* wb35rx.h --
>>>> +/*============================================================================
>>>
>>> I'm pretty sure this is not an accepted kernel comment style.
>>
>> What's the problem? I think it's OK for this particular patch.
>>
>
> The comments are not even valid C. The only reason why they do not
> break is that they are immediately followed by another,
> correctly-formatted (but separate) comment.

BTW, my suggested style here is the following:

/*============================================================================
 * wb35rx.h --
 *============================================================================*/

>
> --
> Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
