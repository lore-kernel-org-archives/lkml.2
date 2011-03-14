Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837Ab1CNNKX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 09:10:23 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:65197 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979Ab1CNNKU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 09:10:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=D7enqVquhXo80jMtIbqYZ9vDnRfH7NklM5C+HApdtcNKnEMOImeTBxY/EX48qs4sD5
         bteN8QdT3JbL4PIHHoQWkyyJBkHkT66zEkk9j70F9lVSaATkxWAcfQeMsWfYfuijh5fu
         JhRt/0OG0ZfuxFO6sCAVyZ91aeBeU98hog+Zs=
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1103141307590.19969@pobox.suse.cz>
References: <1299686450-5475-1-git-send-email-benjamin.tissoires@enac.fr>
	<alpine.LNX.2.00.1103141307590.19969@pobox.suse.cz>
Date: Mon, 14 Mar 2011 14:10:19 +0100
X-Google-Sender-Auth: Hrf1CjWXCRoNruF7V-s_yJ_th20
Message-ID: <AANLkTiko4z7SJmObKsVCMHeqR2iAYdQ_j-aOhZWjssJ3@mail.gmail.com>
Subject: Re: [PATCH 0/4] Migrations to hid-multitouch, round 2
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

On Mon, Mar 14, 2011 at 13:08, Jiri Kosina <jkosina@suse.cz> wrote:
> On Wed, 9 Mar 2011, Benjamin Tissoires wrote:
>
>> Hi guys,
>>
>> This is the second version for this patch series.
>>
>> Since last time, I integrated Henrik's comments.
>>
>> Cheers,
>> Benjamin
>>
>>  drivers/hid/Kconfig          |   21 +---
>>  drivers/hid/Makefile         |    3 -
>>  drivers/hid/hid-3m-pct.c     |  305 ------------------------------------------
>>  drivers/hid/hid-cando.c      |  276 --------------------------------------
>>  drivers/hid/hid-multitouch.c |  110 +++++++++++++---
>>  drivers/hid/hid-stantum.c    |  286 ---------------------------------------
>>  6 files changed, 97 insertions(+), 904 deletions(-)
>>
>> ;-)
>
> Hi Benjamin,
>
> thanks a lot for this work you have done.
>
> Is there going to be second round of the patches with a few minor fixes
> coming out from Henrik's review?
>
> Thanks,

Hi Jiri,

yes of course. I don't know if I'll have the time to do it today, but
I'll do my best.

Cheers,
Benjamin

>
> --
> Jiri Kosina
> SUSE Labs, Novell Inc.
>
