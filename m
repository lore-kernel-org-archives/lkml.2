Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136Ab1AGVGg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 16:06:36 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:49297 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801Ab1AGVGf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 16:06:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=umRva+n31hjdlto62o8CTfbdPUmR/xC6Uhf2fu/2hMpGDJ1jVDTqBHfIPgk0Z6A6rT
         uCBS+fu5OSE2rAEVJ6liX+cf/X57KDb9Li9GIrpJwRpXYb789i2z5Z2X8oVLxLqDDwfG
         SQ/dhI15sUjbIRNKfUGE2Kr7wsEtL+gt5D1PM=
MIME-Version: 1.0
In-Reply-To: <20110107200850.GE29913@polaris.bitmath.org>
References: <1294425762-29730-1-git-send-email-benjamin.tissoires@enac.fr>
	<20110107200850.GE29913@polaris.bitmath.org>
Date: Fri, 7 Jan 2011 22:06:34 +0100
X-Google-Sender-Auth: DaIlwXWHK8l2txFS6yRz4ThE0jM
Message-ID: <AANLkTim1qw_=9Z23wtU5BxTUrzfGiEJRdR3naQUrTrpK@mail.gmail.com>
Subject: Re: [RFC v3 0/5] hid-multitouch: a first step towards multitouch unification
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

On Fri, Jan 7, 2011 at 9:08 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
> Hi Benjamin,
>
>> here is the v3.
>>
>> all changes are coming from the mails with Henrik:
>>
>> - restricted to new drivers only
>> - delete mt_buffer struct
>> - replace/adapt prev_valid in favor of seen_in_this_frame
>> - integrated fuzz
>> - introduce MT_QUIRKS
>> - other small fixes
>
> A lot of progress in one day - thank you very much for making the
> changes. I will be online for quite a bit longer in case there is more
> coming this way. With some testing over the weekend (I will be
> traveling, sorry), it doesn't look impossible to have this ready early
> next week.

For my part, I'm a bit tired, and I don't have any device at home to
test. I wont publish anything for the evening as I will for sure
introduce bugs.

Good night,
Benjamin

>
> Cheers,
> Henrik
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
