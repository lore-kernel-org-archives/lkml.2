Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826Ab1HQATf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 20:19:35 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:58461 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335Ab1HQATe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 20:19:34 -0400
MIME-Version: 1.0
In-Reply-To: <20110816214352.GK26027@shale.localdomain>
References: <1313454275-5604-1-git-send-email-me@akshayjoshi.com>
	<1313454275-5604-4-git-send-email-me@akshayjoshi.com>
	<CA+XFjir3W3kqin1mL5W_OEduUTyUDADwH6pL=kaS=wHpP=KMeQ@mail.gmail.com>
	<CAOJsxLGqc6khjGQMA=b1BwTv_4pv4ZgkdjJrgtMbRwuNDrN_iA@mail.gmail.com>
	<20110816214352.GK26027@shale.localdomain>
Date: Tue, 16 Aug 2011 20:19:33 -0400
Message-ID: <CAOJpy9vNkC2sz-Q+kpE+SbNKkSZXJS+HV_V9vLX4krK_hVH0Zg@mail.gmail.com>
Subject: Re: [PATCH 4/9] Staging: Winbond: Convert C99 style comments in Winbond.
From: Akshay Joshi <me@akshayjoshi.com>
To: Dan Carpenter <error27@gmail.com>, Pekka Enberg <penberg@kernel.org>,
        =?UTF-8?Q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>,
        devel@driverdev.osuosl.org, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-kernel@vger.kernel.org,
        Karthigan Srinivasan <karthigan.srinivasan2@gmail.com>,
        Pavel Machek <pavel@ucw.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p7H0JjNH031867

Sorry about that, everyone. I'll roll a fix in the next few hours.

Akshay

On Tue, Aug 16, 2011 at 5:43 PM, Dan Carpenter <error27@gmail.com> wrote:
> On Wed, Aug 17, 2011 at 12:24:06AM +0300, Pekka Enberg wrote:
>> 2011/8/16 GÃ¡bor Stefanik <netrolller.3d@gmail.com>:
>> >> -
>> >> -//====================================
>> >> -// Internal variable for module
>> >> -//====================================
>> >> +/*============================================================================
>> >> +/* wb35rx.h --
>> >> +/*============================================================================
>> >
>> > I'm pretty sure this is not an accepted kernel comment style.
>>
>> What's the problem? I think it's OK for this particular patch.
>
> There are a five start open comment "/*" marks in a row that don't
> have a matching close comment.
>
> regards,
> dan carpenter
>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
