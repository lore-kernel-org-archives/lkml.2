Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751409Ab1HQFmH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 01:42:07 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41649 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813Ab1HQFmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 01:42:03 -0400
Message-ID: <4E4B54A4.4040203@kernel.org>
Date: Wed, 17 Aug 2011 08:41:56 +0300
From: Pekka Enberg <penberg@kernel.org>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
CC: Akshay Joshi <me@akshayjoshi.com>, Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Karthigan Srinivasan <karthigan.srinivasan2@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/9] Staging: Winbond: Convert C99 style comments in Winbond.
References: <1313454275-5604-1-git-send-email-me@akshayjoshi.com> <1313454275-5604-4-git-send-email-me@akshayjoshi.com> <CA+XFjir3W3kqin1mL5W_OEduUTyUDADwH6pL=kaS=wHpP=KMeQ@mail.gmail.com> <CAOJsxLGqc6khjGQMA=b1BwTv_4pv4ZgkdjJrgtMbRwuNDrN_iA@mail.gmail.com> <CA+XFjiq01Ea4hivhMK=H3pgFeaoCgUWDUirD=-PzALzvOpdvvA@mail.gmail.com>
In-Reply-To: <CA+XFjiq01Ea4hivhMK=H3pgFeaoCgUWDUirD=-PzALzvOpdvvA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/17/11 12:38 AM, Gábor Stefanik wrote:
> 2011/8/16 Pekka Enberg<penberg@kernel.org>:
>> 2011/8/16 Gábor Stefanik<netrolller.3d@gmail.com>:
>>>> -
>>>> -//====================================
>>>> -// Internal variable for module
>>>> -//====================================
>>>> +/*============================================================================
>>>> +/* wb35rx.h --
>>>> +/*============================================================================
>>> I'm pretty sure this is not an accepted kernel comment style.
>> What's the problem? I think it's OK for this particular patch.
>>
> The comments are not even valid C. The only reason why they do not
> break is that they are immediately followed by another,
> correctly-formatted (but separate) comment.
Aah,  amazing how I was able to miss that!

Akshay, I suppose you didn't compile-test the patches? Please don't
send patches like that on LKML. It's a huge waste of time for reviewers.

                                 Pekka
