Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903Ab0KBUVY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 16:21:24 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:47901 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758Ab0KBUVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 16:21:22 -0400
MIME-Version: 1.0
X-Originating-IP: [66.187.233.202]
In-Reply-To: <20101102162429.GB14198@core.coreip.homeip.net>
References: <tkrat.980deadea593e9ed@s5r6.in-berlin.de>
	<201010311518.42998.dmitry.torokhov@gmail.com>
	<AANLkTi=AGWGv2WPuGQ4bF7N4TSAbU5YMjry9beXyvspk@mail.gmail.com>
	<20101102162429.GB14198@core.coreip.homeip.net>
Date: Tue, 2 Nov 2010 16:21:22 -0400
Message-ID: <AANLkTinpjb4W3irzrrXtK14v9GhVt_UP+-=ioadJezY6@mail.gmail.com>
Subject: Re: drivers/media/IR/ir-keytable.c::ir_getkeycode - 'retval' may be
 used uninitialized
From: Jarod Wilson <jarod@wilsonet.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        mchehab@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 2, 2010 at 12:24 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> On Tue, Nov 02, 2010 at 12:04:56PM -0400, Jarod Wilson wrote:
>> On Sun, Oct 31, 2010 at 6:18 PM, Dmitry Torokhov
>> <dmitry.torokhov@gmail.com> wrote:
>> > On Sunday, October 31, 2010 10:51:21 am Stefan Richter wrote:
>> >> Commit 9f470095068e "Input: media/IR - switch to using new keycode
>> >> interface" added the following build warning:
>> >>
>> >> drivers/media/IR/ir-keytable.c: In function 'ir_getkeycode':
>> >> drivers/media/IR/ir-keytable.c:363: warning: 'retval' may be used uninitialized in this function
>> >>
>> >> It is due to an actual bug but I don't know the fix.
>> >>
>> >
>> > The patch below should fix it. I wonder if Linus released -rc1 yet...
>>
>> Looks like it missed rc1.
>>
>
> Nope, I see it there, 47c5ba53bc5e5f88b5d1bbb97acd25afc27f74eb ;)

Oh, damn. Sorry for the noise... I blame it on my cold... :)

-- 
Jarod Wilson
jarod@wilsonet.com
