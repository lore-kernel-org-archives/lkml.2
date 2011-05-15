Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220Ab1EOXU0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 19:20:26 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42435 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753578Ab1EOXUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 19:20:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=N+ZcGlASKCaZuRXbByQ/7NM/yP2A0v4k5ZFnJRtXu/iBW+Ybru8W5rsh+KYwfC2Svw
         4/mTwo2POYMsBk7aCtD1CZb0kvipn0hlvo6fSSBcQjIutcA+3KOnEaQELHZcJWLXTmgv
         0kr+KUkPyeNAEt8kAQ1p4HplhhLXTc/74HimU=
MIME-Version: 1.0
In-Reply-To: <20110511144119.GC23897@sortiz-mobl>
References: <1304687090-23401-1-git-send-email-linus.walleij@stericsson.com>
	<BANLkTikHwd-Nsoq9eVwf1jTfSAUiA59R5g@mail.gmail.com>
	<20110511144119.GC23897@sortiz-mobl>
Date: Mon, 16 May 2011 01:20:24 +0200
X-Google-Sender-Auth: _oSbV3nguMgpoXi6nuFowJcAKQ0
Message-ID: <BANLkTimSpzavQruy1AT2JEh4g1ULdwZPOA@mail.gmail.com>
Subject: Re: [PATCH 00/10] Ux500 PRCMU into MFD and update deps
From: Linus Walleij <linus.walleij@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/11 Samuel Ortiz <sameo@linux.intel.com>:
> On Wed, May 11, 2011 at 02:39:03PM +0200, Linus Walleij wrote:
>> 2011/5/6 Linus Walleij <linus.walleij@stericsson.com>:
>>
>> > I will attempt to slim this down a bit, mainly the set is a
>> > review point for the MFD maintainer to check out if the PRCMU
>> > driver fits within MFD.
>>
>> Sam will you be able to provide some feedback on this so I know
>> whether I shall plan to polish it up for the 2.6.40 merge window or
>> not?
>
> I quickly looked at this patchset, and I hope to be able to review it better
> next week. But overall I think this fits into the MFD mapped registers model.
> So please go ahead and prepare this stuff for the .40 merge window (I'd
> appreciate to see the "slimming this down a bit" part, while I expect to come
> back to you with some more comments by next week.

OK I have broken it into a *bit* smaller chunks by making a
(yet complex) movement patch to get the stuff out of the mach-ux500
which I then patch to an acceptable level.

I also pushed non-conflicting parts (all but 2 patches) to next
for testing, applying them in parallell in MFD should work just
fine, then I can take them off my branch.

Thanks,
Linus Walleij
