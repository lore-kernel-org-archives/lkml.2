Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752432Ab1LNGA0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 01:00:26 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:63686 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029Ab1LNGAX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 01:00:23 -0500
MIME-Version: 1.0
In-Reply-To: <20111214001847.GA26688@kroah.com>
References: <CAB4K4y74HtRxF6iMayonaSvc2Uoe9Fr+7Bwf9Fr05NwbrSDU8g@mail.gmail.com>
	<20111214001847.GA26688@kroah.com>
Date: Wed, 14 Dec 2011 11:30:22 +0530
Message-ID: <CAB4K4y62VuUYcrT_uVGR0SYP+vctJkuyC1GgCebHFhOBExNoeQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] Staging: zram: print the disk size in KB
From: Ajeet Yadav <ajeet.yadav.77@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Jerome Marchand <jmarchan@redhat.com>,
        Nitin Gupta <ngupta@vflare.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 5:48 AM, Greg KH <greg@kroah.com> wrote:
> On Tue, Dec 13, 2011 at 10:46:53AM +0530, Ajeet Yadav wrote:
>> >From a5d5ba92b5af9134e617986884856334c377e1d0 Mon Sep 17 00:00:00 2001
>> From: Ajeet Yadav <ajeet.yadav.77@gmail.com>
>> Date: Mon, 12 Dec 2011 18:42:30 +0530
>> Subject: [PATCH 1/1] Staging: zram: print the disk size in KB
>
> Why did you include the patch in an email instead of using
> git-send-email?  This would force me to edit the patch by hand, removing
> this useless stuff.
sorry for the discomfort, gmail SMTP port was not configured properly,
will take care of this next time.
>
>>
>> Total memory size is in KB, but the zram disk size was not
>> printed in KB, correct the figure in KB units.
>>
>> Signed-off-by: Ajeet Yadav <ajeet.yadav.77@gmail.com>
>> ---
>>  drivers/staging/zram/zram_drv.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
>> index 09de99f..ff591e3 100644
>> --- a/drivers/staging/zram/zram_drv.c
>> +++ b/drivers/staging/zram/zram_drv.c
>> @@ -126,7 +126,7 @@ static void zram_set_disksize(struct zram *zram,
>> size_t totalram_bytes)
>
> And your patch is line-wrapped, making it so I would have to edit it
> again.
>
> Please fix up, and get the acks from the zram maintainer (as this does
> change a kernel/user api) before I can accept this.
>
> greg k-h
