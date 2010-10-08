Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121Ab0JHE7r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 00:59:47 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:1568 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960Ab0JHE7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 00:59:46 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6129"; a="57036816"
Date: Thu, 07 Oct 2010 21:59:40 -0700
Subject: Re: [PATCH] serial: DCC(JTAG) serial and console emulation support
Message-ID: <6lwrd5r5bkngwsfbw998jv3h.1286513980329@email.android.com>
From: Daniel Walker <dwalker@codeaurora.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Greg KH <gregkh@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org, "Hyok S. Choi" <hyok.choi@samsung.com>,
        Tony Lindgren <tony@atomide.com>, Jeff Ohlstein <johlstei@quicinc.com>,
        Ben Dooks <ben-linux@fluff.org>, Alan Cox <alan@linux.intel.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Feng Tang <feng.tang@intel.com>,
        Tobias Klauser <tklauser@distanz.ch>,
        Jason Wessel <jason.wessel@windriver.com>,
        Philippe Langlais <philippe.langlais@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id o984xuDn001356

I'm not disputing the serial core part. I ok with converting it to tty.

Daniel

Mike Frysinger <vapier@gentoo.org> wrote:

>On Thu, Oct 7, 2010 at 18:11, Daniel Walker wrote:
>> On Thu, 2010-10-07 at 14:52 -0700, Greg KH wrote:
>>> On Thu, Oct 07, 2010 at 02:47:18PM -0700, Daniel Walker wrote:
>>> > On Thu, 2010-10-07 at 14:15 -0700, Greg KH wrote:
>>> > > On Thu, Oct 07, 2010 at 01:51:18PM -0700, Daniel Walker wrote:
>>> > > > > We've said no over a period of about ten years to a lot of attempts to
>>> > > > > just borrow the ttyS0 range. If we'd said yes it would have been a
>>> > > > > complete mess by now.
>>> > > > >
>>> > > > > So the answer is no.
>>> > > >
>>> > > > Nothing can be unilateral, there's always room for exceptions. You
>>> > > > should say something more like "it's possible, but unlikely".
>>> > >
>>> > > Hm, how about this, as the TTY and serial driver[1] maintainer, I will
>>> > > not accept this kind of patch at all.
>>> > >
>>> > > Is that final enough for you?
>>> >
>>> > So you don't like it, that's fair enough .. <thinks>I wonder what other
>>> > maintainers I can send this too</thinks> ;)
>>> >
>>> > Can you be more specific about your objections
>>>
>>> See everything that Mike and Alan wrote, do I need to repeat it?
>>
>> I'm not sure .. I would say "Yes" if I didn't get the feeling your
>> already to tear my head off.
>>
>> I think the only disputed issue is the use of ttyS as options part of
>> the driver ..
>
>and using "serial_core" at all in favor of HVC or tty_core (the latter
>might be easier for you as the former is a bit of unknown atm)
>-mike
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
