Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760667Ab2EIRwJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 13:52:09 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:62173 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759652Ab2EIRwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 13:52:06 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1205091637570.26736@pobox.suse.cz>
References: <1336136030-18503-1-git-send-email-benjamin.tissoires@gmail.com>
	<alpine.LNX.2.00.1205091637570.26736@pobox.suse.cz>
Date: Wed, 9 May 2012 19:52:04 +0200
Message-ID: <CAN+gG=HaQkO03whpuZFvBWTEe88TbM+uYUD8PsCa7bhO6v25uw@mail.gmail.com>
Subject: Re: [patch 0/5] Bug fix and win8 for hid-multitouch
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Stephane Chatty <chatty@enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jiri,

On Wed, May 9, 2012 at 4:39 PM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Fri, 4 May 2012, benjamin.tissoires wrote:
>
>> The first patch fixes the bug I discovered lately. This bug was related to the out
>> of bound bitfield test, so it concerns every known devices. Ideally, it should go
>> to upstream-fixes, but this would requires additional adaptations.
>> Jiri, How do you want to proceed?
>
> When did the bug get introduced, please? i.e. is it a regression?

Well, it's not exactly a regression: it's always been there... ;-)

More seriously, the bug was introduced in the commit
"HID: multitouch: fix handling of buggy reports descriptors for Dell
ST2220T" (in kernel 3.3)
The thing is that this bug fix was not good and was working by miracle.

>
> As we are getting close to 3.5 merge window being open, maybe the best
> thing to do would be just push it there once it's open, and then
> eventually backport it for stable@ if necessary.

That seems fair.

>
>> The last 4 patches are the beginning of the support of Win8 devices.
>> It's only the beginning as the specification is much more precise than
>> the Win7, and we will need to do more tuning in the future. However,
>> Win8 devices are retro-compatible with Win7, so they will work out of
>> the box though.
>
> I understand that Henrik had some valid concerns, so I will wait for a
> second respin and Henrik's ack, ok?

ok,
Thanks,
Benjamin

>
> Thanks,
>
> --
> Jiri Kosina
> SUSE Labs
