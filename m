Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755658Ab1BJMlR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 07:41:17 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:52540 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755227Ab1BJMlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 07:41:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=EBbYVD/nQCIB2qQhUBsKs7Walr6X89W34kzOiSUZsT0TyFbLw+TgB5tGTqDr/hX5wF
         mKe1Yq8iBcqKtfNjgW3TZZ/WkA6pY7KdxsaVR51K04UbRNEOOgBECa/dACWtctpRjEKM
         PWehHMHlRRhFO0+7QCaDY6A2a/FgIk4R2QDhI=
MIME-Version: 1.0
In-Reply-To: <4D53D7FE.9070206@codeaurora.org>
References: <1296568063-12010-1-git-send-email-aghayal@codeaurora.org>
 <1296568063-12010-2-git-send-email-aghayal@codeaurora.org>
 <AANLkTimZ9UwcQp5QQjyHVsRdEAcf6+rL18mCesishPoC@mail.gmail.com> <4D53D7FE.9070206@codeaurora.org>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Thu, 10 Feb 2011 20:40:54 +0800
Message-ID: <AANLkTi=MX0h-YU_Y_LSgZ1gLxS0iXSDGbRyHx4u4TVC1@mail.gmail.com>
Subject: Re: [RFC v2 PATCH 1/7] matrix_keypad: Increase the max limit of rows
 and columns
To: Trilok Soni <tsoni@codeaurora.org>
Cc: Anirudh Ghayal <aghayal@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, rtc-linux@googlegroups.com,
        linux-arm-msm@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 10, 2011 at 8:20 PM, Trilok Soni <tsoni@codeaurora.org> wrote:
> Hi Dmitry,
>
> On 2/9/2011 1:32 PM, Eric Miao wrote:
>> On Tue, Feb 1, 2011 at 9:47 PM, Anirudh Ghayal <aghayal@codeaurora.org> wrote:
>>> From: Trilok Soni <tsoni@codeaurora.org>
>>>
>>> Some keyboard controller have support for more than
>>> 16 columns and rows. Moving this value to 32.
>>>
>>> Cc: Eric Miao <eric.y.miao@gmail.com>
>>> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
>>> Signed-off-by: Trilok Soni <tsoni@codeaurora.org>
>>
>> This looks good to me, as long as the bits don't exceed 256, which
>> is used in the #KEY() macro. So far, 32 looks to be a sane number
>> to me, unless we have further requirement to get this larger.
>>
>> Acked-by: Eric Miao <eric.y.miao@gmail.com>
>>
>
> Are you going to pick up this patch only from the series you want us to get
> it submitted it separately?

I believe Dmitry will pick this series once all the patches are reviewed?
