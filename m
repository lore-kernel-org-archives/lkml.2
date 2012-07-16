Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753749Ab2GPVJL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 17:09:11 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64213 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693Ab2GPVJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 17:09:09 -0400
MIME-Version: 1.0
In-Reply-To: <20120716220743.61cf21d4@pyramind.ukuu.org.uk>
References: <alpine.DEB.2.00.1207162041400.28607@skynet.skynet.ie>
	<CA+55aFypB-Tn+6WQCZauU16QuVGBfr-TjDZrxuxL5SU_bbJTVw@mail.gmail.com>
	<20120716220743.61cf21d4@pyramind.ukuu.org.uk>
Date: Tue, 17 Jul 2012 07:09:09 +1000
Message-ID: <CAPM=9ty4LWwetAL0UL2m1WJDu7UZQDwLEdOkfKJXLv=qEE4ULA@mail.gmail.com>
Subject: Re: [git pull] drm gma500 fixes
From: Dave Airlie <airlied@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2012 at 7:07 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Mon, 16 Jul 2012 13:44:32 -0700
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
>> On Mon, Jul 16, 2012 at 12:42 PM, Dave Airlie <airlied@linux.ie> wrote:
>> >
>> > Sorry been travelling and a bit neglectful of some of Alan's
>> > patches,
>>
>> I actually took the three Alan sent me already, exactly because they
>> seemed harmless and I didn't know your schedule.
>>
>> Your pull has a "gma500: Fix frequency detection" patch that I haven't
>> seen though, which makes me wonder if Alan wants that one too. He only
>> sent me a series of the three other patches..
>>
>> Alan?
>
> The frequency detect bug isn't a regression, indeed its not clear it's a
> path ever taken.

Cool then drop it, I just found it in my INBOX,

anyways I also sent a dodgy URL in the pull, since I wasn't on my
usual machine I hadn't updated stuff.

So yeah ignore this one and I'll add the extra patch into -next.

Thanks,
Dave.
