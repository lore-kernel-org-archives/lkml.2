Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933860Ab1IONoa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 09:44:30 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51393 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933125Ab1IONo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 09:44:29 -0400
MIME-Version: 1.0
In-Reply-To: <CAE2SPAatxqkFUExiNc3EAP3T4EiHQiPxVcd7vPZG23xycy4QLw@mail.gmail.com>
References: <201109151441.15015.leo@alaxarxa.net>
	<CAE2SPAatxqkFUExiNc3EAP3T4EiHQiPxVcd7vPZG23xycy4QLw@mail.gmail.com>
Date: Thu, 15 Sep 2011 15:44:27 +0200
Message-ID: <CAE2SPAaSOMCeyS=ED+VWKeoUwHSL=8BUGe8UXUaMKEUr0EtHSQ@mail.gmail.com>
Subject: Re: [PATCH/RFC] parport_pc: remove ancient, overeager quirk that
 disables EPP support on many chipsets
From: Bastien ROUCARIES <roucaries.bastien@gmail.com>
To: Leopold Palomo-Avellaneda <leo@alaxarxa.net>
Cc: linux-kernel@vger.kernel.org, Adam Baker <linux@baker-net.org.uk>,
        linux-parport@lists.infradead.org, 630593@bugs.debian.org,
        Nicos Gollan <gollan@informatik.uni-kl.de>, Greg KH <greg@kroah.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Alexander Gordeev <lasaine@lvk.cs.msu.su>,
        Jonathan Nieder <jrnieder@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 15, 2011 at 3:41 PM, Bastien ROUCARIES
<roucaries.bastien@gmail.com> wrote:
> On Thu, Sep 15, 2011 at 2:41 PM, Leopold Palomo-Avellaneda
> <leo@alaxarxa.net> wrote:
>> Hi again,
>>
>> sorry for the noise and my mistake. The patch...
>>
>> there's a bug in the parport module that have been reported (in another
>> places) some time ago [1]. Also, this bug was reported at Redhat [2], but
>> nobody follow the report and it was closed.

Moreover they are more detail about this bug here you should contact
davbid campell

http://lists.infradead.org/pipermail/linux-parport/2004-March/000048.html

Bastien

>> As Adam Baker said [1] :
>>
>> <quote>
>> A long time ago (~ 10 years), Intel produced a chipset that
>
> Why not check dmi years for this test and do the test only for board
> before 2000 ? Better safe than sorry
>
> Bastien
>
>
>
>> included broken EPP support. The Linux parport driver was written to detect
>> such a chipset and disable EPP support on it. Unfortunately the test that was
>> written gives false positives for many current chipsets and no-one seems to
>> know exactly what the problem hardware was, let alone have a sample of it to
>> see if a better test can be written. After such a long time it is probably
>> appropriate to just remove the test (on average it does more harm than good)
>> however you are correct in asserting the driver is unmaintained so no-one is
>> bothering to fix it.
>> </quote>
>>
>> I have applied the patch to the standard debian kernel and vanilla kernels and
>> runs perfectly. The patch simply erases a check. Applied to some Dell
>> hardware, now the EPP mode is detected and, after some initial tests it's
>> working.
>>
>> Please, apply the patch.
>>
>> Best regards,
>>
>> Leo
>>
>> [1] http://lists.infradead.org/pipermail/linux-parport/2008-March/000628.html
>> [2] https://bugzilla.redhat.com/show_bug.cgi?id=284471
>>
>>
>> Signed-off-by: Adam Baker <linux at baker-net.org.uk>
>> Signed-off-by: Leopold Palomo-Avellaneda <leo@alaxarxa.net>
>>
>>
>> ---
>>
>
