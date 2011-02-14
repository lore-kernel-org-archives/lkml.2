Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992Ab1BNQfq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 11:35:46 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:53954 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755202Ab1BNQfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 11:35:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type;
        b=oMFByZF1btGrRZ8/nFYRBU2yKS6O6botqdl/VgT7Ur8RvO/VPOzRyf64VsOjmCvisq
         GRh30P2vPFZJOD5TVqyMR1u9M3kZ1WDJc3UOsItwlrExZKCOWGHzPIbKDer4sTnzn0/l
         wZM6Zyy/Eg5OkWwlCv7kH4qqougQKKGhvWPTI=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20110214162057.GI9869@sequoia.sous-sol.org>
References: <AANLkTi=G5pLNqLw1RGNauD+9D76uJfEgNXuef1Po6km7@mail.gmail.com>
	<20110214162057.GI9869@sequoia.sous-sol.org>
Date: Mon, 14 Feb 2011 17:35:42 +0100
Message-ID: <AANLkTinFN6gmcNvoe=DQ3YPL=Bcj3pKCHO6ZzafE9uak@mail.gmail.com>
Subject: Re: Regression - Xorg start failed
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Chris Wright <chrisw@sous-sol.org>
Cc: DRI <dri-devel@lists.freedesktop.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 14, 2011 at 5:20 PM, Chris Wright <chrisw@sous-sol.org> wrote:
> * Sedat Dilek (sedat.dilek@googlemail.com) wrote:
>> [ As I am not subscribed to both MLs and lazy to pick up all involved people ]
>>
>> Hi Chris,
>>
>> The original patch had also this part (see the revert in [1]):
>> ...
>> +#include <linux/security.h>
>> ...
>>
>> Your new patch in [2] is missing it or is it not required?
>
> It was just a patch on top of the bad commit (47970b1b), the #include is
> required.
>
> thanks,
> -chris
>

OK, now I see.
Might be good to push a v2 as the initial patch was reverted in the meantime?
The explanations of the fixup patch were helpful (to me) and should be included.

- Sedat -
