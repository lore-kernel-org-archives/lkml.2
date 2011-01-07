Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755033Ab1AGRbW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 12:31:22 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:45689 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755002Ab1AGRbU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 12:31:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=otloH2EOgkfPmlqIA6yKvSTFYHH+Weijon3GGrmUo07xuqLaZrAeaUE9ikHc59w7d5
         yV+CqTwBjk8CnO1IBDkXQwzWdLhbcMuPn/y2Skkj6PnnIzT7uEegTNHi3urzerBRSsS6
         aBAOgxhp68gdiX63r/07Z4KN6X3plp27lsGls=
MIME-Version: 1.0
In-Reply-To: <20110107172707.GA6095@polaris.bitmath.org>
References: <1294248468-19979-1-git-send-email-benjamin.tissoires@enac.fr>
	<1294248468-19979-4-git-send-email-benjamin.tissoires@enac.fr>
	<20110106172528.GD1790@polaris.bitmath.org>
	<AANLkTimhk80b+jkqsNrxmFzSgmHX=_wdzbwE09NoFgV1@mail.gmail.com>
	<20110107122338.GB2312@polaris.bitmath.org>
	<AANLkTimYaZcvLyijtEm-iu+PzNXdozcNbFJQ6+PzD4vK@mail.gmail.com>
	<20110107155714.GA506@polaris.bitmath.org>
	<AANLkTimZ-VuvY8fEuPz7gzWVFvLHaJHG34gvkOuMMq2O@mail.gmail.com>
	<20110107172707.GA6095@polaris.bitmath.org>
Date: Fri, 7 Jan 2011 18:31:17 +0100
X-Google-Sender-Auth: cQFC-kGWQWWiUFJZBFIgdXET7gY
Message-ID: <AANLkTik1qZwrbOFO3cDB6YqnmF+-3BsGCUa3u1s5fRu2@mail.gmail.com>
Subject: Re: [RFC v2 03/10] hid-multitouch: support for PixCir-based panels
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Stephane Chatty <chatty@enac.fr>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 7, 2011 at 6:27 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
>> > But the mt_input_mapped function did not change - needs to change too.
>>
>> I can not see any differences between mt_input_mapped and those found
>> in 3m and egalax. Can you point me exactly what I should add please?
>
> My bad - it seems your tree does contain the right function. Another
> reason to have the patches in mail. :-)
>
>> >> - The Egalax problem: I am pretty sure that Stéphane took this driver
>> >> into account when writing the original patch. BTW I propose to
>> >> postpone the problem for 2.6.39.
>> >
>> > This driver is aiming at engulfing a larger set of drivers, and as
>> > such, should be prepared sensibly, IMO. Rushing things will only cause
>> > us grief further down the road.
>> >
>>
>> So, have you got any clue (or even better, can you test a solution)
>> for those devices?
>
> Yes I can, but I will not be available the coming couple of days, so
> the timing is a bit off. I agree with you that we do not need to solve
> every issue right now, but I know for a fact that the newer DWAV
> firmware has no touch frame indication, and does not assume the
> not-seen-means-up behavior. Perhaps it is enough to just add the
> quirks field to the class, define one or two quirks currently in use,
> and leave the rest for later. Sounds reasonable?
>

Sounds reasonable

Cheers,
Benjamin
