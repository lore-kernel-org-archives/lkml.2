Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755052Ab2CXBLj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 21:11:39 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42220 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752345Ab2CXBLh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 21:11:37 -0400
MIME-Version: 1.0
In-Reply-To: <CAKaWdxafKU6+s-1-5jqw=JzvUE7ntYUh=T3JOooDWVoiHgq9NA@mail.gmail.com>
References: <CAKaWdxZGg-Xpw2E85bAr8BVgWtXxEitwsir=yXp5qS0FMUk1uQ@mail.gmail.com>
 <m1ehtd8qez.fsf@fess.ebiederm.org> <CAKaWdxbuwV6yQnX=4zcBZncL8f+7cXPFwx8ejw=6d=dX8NoZsw@mail.gmail.com>
 <87obshxt4w.fsf@xmission.com> <CAKaWdxa326eP47=nENh8_1NmRCadTB=o8jyWO2dAzZcn9yCwiA@mail.gmail.com>
 <87zkc1w6wp.fsf@xmission.com> <CAKaWdxa8yJJhnPj1th6GdYvn9+Lu7GUV1e=960gMQOdc8W47dQ@mail.gmail.com>
 <CAKaWdxaaKMiwnhP7R786mqHTPs+o=izerZDbUgPBaxyU+XL-2g@mail.gmail.com>
 <C141162D-9164-43D3-9A1F-93156DC7409B@jonmasters.org> <CAKaWdxafKU6+s-1-5jqw=JzvUE7ntYUh=T3JOooDWVoiHgq9NA@mail.gmail.com>
From: Ray Lee <ray-lk@madrabbit.org>
Date: Fri, 23 Mar 2012 18:11:07 -0700
X-Google-Sender-Auth: 0k32z6fQhtjhbUKRiKMfQ_e__gc
Message-ID: <CADU53JXYSz0sYg6fWjdj_ZjMbZoQVfmz_oD83pSqBL85_4-UmQ@mail.gmail.com>
Subject: Re: Hang on "echo b > /proc/sysrq-trigger"
To: Keith Chew <keith.chew@gmail.com>
Cc: Jon Masters <jonathan@jonmasters.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 18, 2012 at 11:45 PM, Keith Chew <keith.chew@gmail.com> wrote:
>> I've just been reviewing LKML for the past month…was there ever any followup?
>> Perhaps it's worth discussing a patch to change the below delay?
>>
>
> I was about to prepare a patch for this change last Friday, but the
> system hanged on Saturday, after a few weeks of smooth reboots. The
> other unit with reboot=p (as Eric suggested to be the most reliable
> way of rebooting) is still going without any issues, so maybe that is
> the best workaround for now.

Well, someone else may be hitting this and not know. If the situation
measurably improved by increasing the delay, then it seems like a good
idea to at least upstream that, regardless if it's perfect?
