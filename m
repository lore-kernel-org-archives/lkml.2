Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757686Ab0ICPad (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 11:30:33 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39528 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756858Ab0ICPab convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 11:30:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=RhLVxR8id7x4KRxZBY4TLhafwZWF+Q4u44ML68ezJHdoZQBoeAy1C/IjpDjyZI68hD
         9bgHAYVW5XrzXri4ireAmLn3xexj+eEYusWVtKUqbF/7hxT6famgi9EIQa1dm8JZlk06
         q7FYRaf7a08nhNrqPRsDzdMCyUk4uyS5q/s/s=
MIME-Version: 1.0
In-Reply-To: <4C80F2CD.2040708@euromail.se>
References: <1283516247-11624-1-git-send-email-rydberg@euromail.se>
	<1283516247-11624-4-git-send-email-rydberg@euromail.se>
	<6753EB6004AFF34FAA275742C104F952022BB10E@wacom-nt10.wacom.com>
	<4C80F2CD.2040708@euromail.se>
Date: Fri, 3 Sep 2010 17:30:27 +0200
Message-ID: <AANLkTinUxPMezfSHjfPPJ6PoZ1Put26ZAMrzQ36K2fjV@mail.gmail.com>
Subject: Re: [PATCH 3/5] input: wacom: Add support for the Bamboo Touch
 trackpad (rev3)
From: Ping Cheng <pinglinux@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Ping Cheng <pingc@wacom.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Chris Bagwell <chris@cnpbagwell.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 3, 2010 at 3:06 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
> On 09/03/2010 03:01 PM, Ping Cheng wrote:
> [...]
>
>> +     input_report_key(input, BTN_LEFT, (data[1] & 0x08) != 0);
>> +     input_report_key(input, BTN_MIDDLE, (data[1] & 0x04) != 0);
>> +     input_report_key(input, BTN_4, (data[1] & 0x02) != 0);
>> +     input_report_key(input, BTN_RIGHT, (data[1] & 0x01) != 0);
>>
>> Since you are assigning meaningful defaults to three of the tablet
>> buttons instead of using BTN_#, can we move one more step to make the
>> fourth button useful out-of-box too? I am thinking of something like
>> BTN_FORWARD and BTN_BACK while getting rid of the BTN_MIDDLE. So, it
>> would be:
>>
>>       input_report_key(input, BTN_LEFT, (data[1] & 0x08) != 0);
>>       input_report_key(input, BTN_FORWARD, (data[1] & 0x04) != 0);
>>       input_report_key(input, BTN_BACK, (data[1] & 0x02) != 0);
>>       input_report_key(input, BTN_RIGHT, (data[1] & 0x01) != 0);
>>
>> Does this make sense to you?
>
>
> Well, this is all a matter of taste, isn't it. If middle-button emulation works
> out of the box, for the benefit of us old X users who seem unwilling to ever let
> go of the click-to-paste functionality, then I would not mind terribly.

I agree and I use middle click more than right click myself ;). I just
wanted to give BTN_4 a life. If no one has a good suggestion for that,
I can live with it.

Ping
