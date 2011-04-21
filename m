Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752218Ab1DUMF7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 08:05:59 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51470 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750701Ab1DUMF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 08:05:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=MRNRZsBqozumXc0VBWw8YeyzHIr4BvatfesWPoW7OXcuxw8Ptj5up/mDhGTrzGwOEk
         A3WQTXOi8Jz4QJAxpYyidUL2a9K3AKHH1lhrHiMHzG8ci2M+a4fdjnrUM+koVE/q+svG
         rrFWWD2+SGVwRGyYQNuqs90DotH5jl5BhUXDk=
MIME-Version: 1.0
In-Reply-To: <20110421115843.GA7837@polaris.bitmath.org>
References: <1303291155-3148-1-git-send-email-salt@salt.com.tw>
	<20110420094700.GA2258@polaris.bitmath.org>
	<BANLkTin7Q3fD3vg90qCk12MGaVEvLBe0Mg@mail.gmail.com>
	<20110420100759.GA2436@polaris.bitmath.org>
	<alpine.LNX.2.00.1104211115570.12035@pobox.suse.cz>
	<BANLkTinND+uw=JYS4WbwNLAX8P5SF1VGqw@mail.gmail.com>
	<20110421115843.GA7837@polaris.bitmath.org>
Date: Thu, 21 Apr 2011 14:05:56 +0200
X-Google-Sender-Auth: q3TjPFBXPfT6J3ckccUM8QFxC3Y
Message-ID: <BANLkTimku6reQpkNZ9-WUvhvv0pm+gSrSg@mail.gmail.com>
Subject: Re: [PATCH] HID: add support for PenMount dual-touch panel
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Jiri Kosina <jkosina@suse.cz>,
        Richard Nauber <richard.nauber@googlemail.com>,
        PenMount <penmount.touch@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Stephane Chatty <chatty@lii-enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, PenMount <salt@salt.com.tw>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 21, 2011 at 13:58, Henrik Rydberg <rydberg@euromail.se> wrote:
>> > Once you are done with testing the last_field_index change, it'd be great
>> > if you could respin the patches so that the first one perfoms this change,
>> > and the second one adds PenMount support on top of it.
>> >
>> > I'll then apply it. Thanks,
>>
>> Hi Jiri,
>>
>> I'll do that as soon as Henrik tells me it is working.
>
> The 3M (0596:0502) and eGalax (0eef:720c) seem to work as expected.
>

Thanks a lot Henrik.

I'll respin the patches right now!

Cheers,
Benjamin
