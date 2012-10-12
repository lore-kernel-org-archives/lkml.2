Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091Ab2JLGUb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 02:20:31 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:43062 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161Ab2JLGUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 02:20:30 -0400
MIME-Version: 1.0
In-Reply-To: <20121001152501.GA7978@kroah.com>
References: <1349095840-26450-1-git-send-email-christian.gmeiner@gmail.com> <20121001152501.GA7978@kroah.com>
From: Christian Gmeiner <christian.gmeiner@gmail.com>
Date: Fri, 12 Oct 2012 08:20:07 +0200
Message-ID: <CAH9NwWdtai6uPCAZZuQt_n4sb7rounSa_UHCHoncBAAS2TmwBA@mail.gmail.com>
Subject: Re: [PATCH] leds-ot200: Fix error caused by shifted mask
To: Greg KH <greg@kroah.com>
Cc: akpm@linux-foundation.org, stable@vger.kernel.org, rpurdie@rpsys.net,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/10/1 Greg KH <greg@kroah.com>:
> On Mon, Oct 01, 2012 at 02:50:40PM +0200, Christian Gmeiner wrote:
>> During the development of this driver an in-house register
>> documentation was used. The last weeks some integration tests
>> were done and this problem was found. It turned out that
>> the released register documentation is wrong.
>>
>> The fix is very simple: shift all mask by one.
>>
>> Signed-off-by: Christian Gmeiner <christian.gmeiner@gmail.com>
>> ---
>>  drivers/leds/leds-ot200.c | 14 +++++++-------
>>  1 file changed, 7 insertions(+), 7 deletions(-)
>
> <formletter>
>
> This is not the correct way to submit patches for inclusion in the
> stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
> for how to do this properly.
>
> </formletter>

Thanks... I will inform stable team again if this patch gets into
mainline - hopefully soon.
--
Christian Gmeiner, MSc
