Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751323Ab2C2EUw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 00:20:52 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51874 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859Ab2C2EUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 00:20:45 -0400
MIME-Version: 1.0
In-Reply-To: <20120328152859.GA21001@kroah.com>
References: <1332492784-10526-1-git-send-email-myungjoo.ham@samsung.com>
	<CAJ0PZbTScHq0MMjSWZ0X5qHChhS+6TL-xSnsqEwS34N2VFLaSw@mail.gmail.com>
	<20120328144450.GA19030@kroah.com>
	<201203281524.08021.arnd@arndb.de>
	<20120328152859.GA21001@kroah.com>
Date: Thu, 29 Mar 2012 13:20:44 +0900
X-Google-Sender-Auth: kMM5o_l6yO4QbHbWhk0qnK9zBVI
Message-ID: <CAH9JG2UyZQkYyRGTrKvSEX6e1a+nYLhmSgogs=a2d+aknij++A@mail.gmail.com>
Subject: Re: [PATCH v7 0/6] Introduce External Connector Class (extcon)
From: Kyungmin Park <kyungmin.park@samsung.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, MyungJoo Ham <myungjoo.ham@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, NeilBrown <neilb@suse.de>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Mike Lockwood <lockwood@android.com>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnevag?= <arve@android.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Morten CHRISTIANSEN <morten.christiansen@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        John Stultz <john.stultz@linaro.org>,
        Joerg Roedel <joerg.roedel@amd.com>, cw00.choi@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/29/12, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Wed, Mar 28, 2012 at 03:24:07PM +0000, Arnd Bergmann wrote:
>> On Wednesday 28 March 2012, Greg KH wrote:
>> >
>> > On Wed, Mar 28, 2012 at 06:39:08PM +0900, MyungJoo Ham wrote:
>> > > Dear Arnd,
>> > >
>> > > Could you please consider the EXTCON patchset for the current merge
>> > > window?
>> >
>> > Wait, no, the current merge window for new stuff closed a week or so
>> > before 3.3 came out.  This needs to be in linux-next before the merge
>> > window opens to ensure that things work properly there before it can be
>> > accepted into the mainline tree.
>> >
>> > So this could go into 3.5 at the earliest.
>>
>> Right. I'm also not convinced that arm-soc is the right place for this to
>> go, and I had not planned to add the patches there. Unfortunately I also
>> haven't followed the last few versions and will have to do at least one
>> more review round and Ack/Nak the interfaces. I should probably do that
>> once -rc1 is out, so please send me a reminder if you don't hear back from
>> me in time.
>>
>> Any opinions on which tree this should go through? I could take it into
>> arm-soc, but it's not really ARM-only. Maybe having it go through the
>> staging tree would be better, leaving MyungJoo in charge afterwards.
>> I guess we should also add a MAINTAINERS entry for the new subsystem.
>
> If acks come through, and I'll be glad to review it after -rc1 as well,
> I can take it through one of my trees to get merged to Linus for 3.5.

Okay, Thanks

Kyungmin Park
>
> thanks,
>
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
