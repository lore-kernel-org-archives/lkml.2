Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935617Ab1ETKc0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 06:32:26 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53240 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935523Ab1ETKcY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 06:32:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=xqwtJTt5YnppQc3asNIwX7hnDW00SDTJfznXt3KN7bZ/CrPmuMn/cGYSEkkszlLQbR
         Ud8IbuingYVG5m+jzW2u0ipQXUhzGay9WNNBrWeh7P+YKzijujXTxF6vEk86WWYAPXPI
         3WSG9EEX5CA6Bt3CpVd401hmC2z4cJhmwU/o0=
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1105201031560.28291@pobox.suse.cz>
References: <1305807498-8785-1-git-send-email-benjamin.tissoires@enac.fr>
	<1305807498-8785-7-git-send-email-benjamin.tissoires@enac.fr>
	<alpine.LNX.2.00.1105201031560.28291@pobox.suse.cz>
Date: Fri, 20 May 2011 12:32:23 +0200
X-Google-Sender-Auth: R9wpKE0YdqwzxcCuFQx2_7Tc5iY
Message-ID: <BANLkTim1nGEbBo2Zf6gfTzAAZJK5vmpy6A@mail.gmail.com>
Subject: Re: [PATCH 6/6] hid-multitouch: class MT_CLS_STANTUM is redundant
 with MT_CLS_CONFIDENCE
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Stephane Chatty <chatty@lii-enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 20, 2011 at 10:35, Jiri Kosina <jkosina@suse.cz> wrote:
> On Thu, 19 May 2011, Benjamin Tissoires wrote:
>
>> Stantum devices used to work with MT_CLS_STANTUM but MT_CLS_CONFIDENCE
>> is exactly the same. This patch switches them to this generic class,
>> and remove the unused MT_CLS_STANTUM.
>>
>> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
>> ---
>>  drivers/hid/hid-multitouch.c |    9 +++------
>>  1 files changed, 3 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
>> index feeb0b7..65b92d2 100644
>> --- a/drivers/hid/hid-multitouch.c
>> +++ b/drivers/hid/hid-multitouch.c
>> @@ -88,7 +88,6 @@ struct mt_class {
>>  #define MT_CLS_DUAL_INRANGE_CONTACTNUMBER    3
>>  #define MT_CLS_CYPRESS                               4
>>  #define MT_CLS_EGALAX                                5
>> -#define MT_CLS_STANTUM                               6
>>  #define MT_CLS_3M                            7
>>  #define MT_CLS_CONFIDENCE                    8
>>  #define MT_CLS_CONFIDENCE_MINUS_ONE          9
>
> Benjamin,
>
> is it intentional that you are leaving the hole in the numbering here?
>
> I don't think there would be any issue with re-numbering 7-10, would it?

Well, the first time I tried to renumber those classes (to keep them
alphabetically sorted), I've been told not to do it. That's why I let
the hole in this case.
There won't be any issue in renumbering those classes (and we could sort them).
Maybe I can just send a new patch on top of this to sort them.

Cheers,
Benjamin

PS: and thank you very much for applying so quickly the last patches I sent.

>
> --
> Jiri Kosina
> SUSE Labs
>
