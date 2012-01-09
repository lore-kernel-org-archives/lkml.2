Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751689Ab2AIFLM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 00:11:12 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:64749 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744Ab2AIFLK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 00:11:10 -0500
MIME-Version: 1.0
In-Reply-To: <NEXT-4f09438ac7d220.32208778@nextmail.ru>
References: <NEXT-4f09438ac7d220.32208778@nextmail.ru>
Date: Mon, 9 Jan 2012 10:41:08 +0530
Message-ID: <CAD2nsn2W0aodLfS8eBo1zTfN2kMFZ83=FtC3cH=Q4OrohQAyNQ@mail.gmail.com>
Subject: Re: ath9k crash 3.2-rc7
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: MR <g7af0ec1e3ea1e7b1@nextmail.ru>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/1/8 MR <g7af0ec1e3ea1e7b1@nextmail.ru>:
>  >  > *does the other patch which remove some suspicious looking code, to
>  >  > see if it improves the situation and avoids the warnings itself.
>  >
>  >I have built and loaded the kernel with this patch. I even have netconsole
>  >
>  > apparently working. But ten hours have not elapsed yet. So far so good.
>  >
>  > If it works till the 10th, I will test it with roaming, too.
>
> Around 23 hours have elapsed.
>
> WiFi seems to be working 100% of time. It is always at least lightly loaded.
>
> Speedtests seems to gve slightly better upload results than I remember with
> 2.6.* (and I have a good enough ISP for WiFi to be the weakest link), so it
> doesn't seem to be a performance regression, either.

great and thanks a lot for testing!
rather than removing the suspicious code
this is properly fixed by us with this patch.
http://marc.info/?l=linux-wireless&m=132595161516806&w=2
you can  download the raw message. please report back if you again
get the issue.

>
> As for roaming while connected - I will try not to forget to test it on the
> 10th.
>
>


-- 
shafi
