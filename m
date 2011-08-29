Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885Ab1H2WjK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 18:39:10 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:47771 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754317Ab1H2WjH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 18:39:07 -0400
MIME-Version: 1.0
In-Reply-To: <20110829221922.GQ2203@ZenIV.linux.org.uk>
References: <1314634419-24766-1-git-send-email-richard@nod.at>
	<1314634419-24766-9-git-send-email-richard@nod.at>
	<20110829142705.5be82d7c.akpm@linux-foundation.org>
	<4E5C06DF.60508@nod.at>
	<20110829221230.GP2203@ZenIV.linux.org.uk>
	<4E5C0F9F.5000405@nod.at>
	<20110829221922.GQ2203@ZenIV.linux.org.uk>
Date: Mon, 29 Aug 2011 18:39:06 -0400
Message-ID: <CACqU3MV_6_KZ0n3cEdP3oCxREjQ4yKmdBbEV8-he7Fn1M5jqaQ@mail.gmail.com>
Subject: Re: [PATCH 8/9] um: fix strrchr problems
From: Arnaud Lacombe <lacombar@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Richard Weinberger <richard@nod.at>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        user-mode-linux-devel@lists.sourceforge.net,
        Al Viro <viro@ftp.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Aug 29, 2011 at 6:19 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Tue, Aug 30, 2011 at 12:15:59AM +0200, Richard Weinberger wrote:
>> Am 30.08.2011 00:12, schrieb Al Viro:
>> >On Mon, Aug 29, 2011 at 11:38:39PM +0200, Richard Weinberger wrote:
>> >>>
>> >>>ok, I give up.  How does this work?
>> >>
>> >>*grrr*, you can drop this patch.
>> >>To my excuse, I've dropped it already from my queue but after
>> >>pulling a second time from Al's git branch it made it again into my
>> >>queue and I forgot about it, sorry!
>> >
>> >That gets you link errors with libc-2.11...
>>
>> Not here.
>> I'm using 2.11.3.
>
> Try to build it static...
>
maybe you can just include the full error message you are getting, and
the context in which it is triggered.

[Not to say this is the first things we ask newbs to add in the commit
log, ie *what* problem does it fix. ;-)]

Thanks,
 - Arnaud
