Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526Ab2E2KPR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 06:15:17 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61168 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753082Ab2E2KPP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 06:15:15 -0400
MIME-Version: 1.0
In-Reply-To: <1338285973.2840.1.camel@edumazet-glaptop>
References: <1338285078-17785-1-git-send-email-devendra.aaru@gmail.com>
	<1338285973.2840.1.camel@edumazet-glaptop>
Date: Tue, 29 May 2012 15:45:14 +0530
Message-ID: <CAHdPZaOkFa-=boq6eXVZUyhGN80TXg+iWoE7sQKbnyxBjej44A@mail.gmail.com>
Subject: Re: [PATCH V2] [staging] bcm: Replace the BCM_DEBUG_* and BCM_SHOW_*
 macros with functions
From: "devendra.aaru" <devendra.aaru@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Eric,

On Tue, May 29, 2012 at 3:36 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> On Tue, 2012-05-29 at 15:21 +0530, Devendra Naga wrote:
>> This patch is made by following the improvements told by Joe Perches,
>> replaced the BCM_DEBUG* and BCM_SHOW* macros into functions and added them
>> in a file and added macros in the Debug.h file. This patch also improves the if
>> check in bcm_show_debug_bitmap,
>>
>> the check was
>>       if ((i == 1) || (i == 2) || (i == 4) || (i == 8));
>> anyway its a check to find whether its a power of two, and replaces
>> it like the following,
>>       if ((i != 0) && !(i & (i - 1)))
>
> So why not using is_power_of_2() ?
>
I really dont know its there. Thanks for letting me know, :), will do
and submit the change.
>

Thanks,
Devendra.
