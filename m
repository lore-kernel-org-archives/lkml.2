Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442Ab1CGTZK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 14:25:10 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:49932 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194Ab1CGTZI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 14:25:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=rg1X4FV8b9SUff3GPNyNXaC5i1dLCJsyuTeOVeiSptppetgKcwlVI9yiD72ungegHY
         vGadOTIUxLg7a676Lo/Wod4iYv8av1tCZBzV+Z4hMytrfGWQB2ne+bFjk3SLsKHWmQgJ
         3mIoZwtktcPZc8+aMsBVuYV7wGzawnjDjJjp4=
MIME-Version: 1.0
In-Reply-To: <20110307155529.GV3416@bicker>
References: <1299486086-7325-1-git-send-email-marek.belisko@open-nandra.com>
	<1299486086-7325-12-git-send-email-marek.belisko@open-nandra.com>
	<20110307155529.GV3416@bicker>
Date: Mon, 7 Mar 2011 20:25:07 +0100
Message-ID: <AANLkTiknavmcagz63oFmqhgF5nV6xEMmLwU=i129LcVB@mail.gmail.com>
Subject: Re: [PATCH 11/21] staging: ft1000: Fix coding style in
 ft1000_usb_transmit_complete function.
From: Belisko Marek <marek.belisko@gmail.com>
To: Dan Carpenter <error27@gmail.com>,
        Marek Belisko <marek.belisko@open-nandra.com>, gregkh@suse.de,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 7, 2011 at 4:55 PM, Dan Carpenter <error27@gmail.com> wrote:
> On Mon, Mar 07, 2011 at 09:21:16AM +0100, Marek Belisko wrote:
>> -    if (urb->status)
>> -        printk("%s: TX status %d\n", ft1000dev->net->name, urb->status);
>> +     if (urb->status)
>> +             DEBUG("%s: TX status %d\n", ft1000dev->net->name, urb->status);
>>
>
> Why did you change the printk() to a DEBUG()?  That's a behavior change,
> and it should have been mentioned in the commit message.
Mea culpa. checkpatch.pl complain about no KERN_... prefix so just fix with
replace to DEBUG. Will return back to printk.
@Greg: should resend whole serie or just this patch?
>
> regards,
> dan carpenter
>
>> -    netif_wake_queue(ft1000dev->net);
>> +     netif_wake_queue(ft1000dev->net);
>>
>>      //DEBUG("Return from ft1000_usb_transmit_complete\n");
>>  }
>
>

thansk,

marek

-- 
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
icq: 290551086
web: http://open-nandra.com
