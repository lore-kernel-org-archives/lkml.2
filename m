Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752282Ab0G0Twc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 15:52:32 -0400
Received: from mx02.infracom.it ([62.196.48.10]:43148 "EHLO mx02.infracom.it"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751665Ab0G0Twb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 15:52:31 -0400
Message-ID: <4C4F38F1.105@gmail.com>
Date: Tue, 27 Jul 2010 21:52:17 +0200
From: Roberto Oppedisano <roberto.oppedisano@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.4) Gecko/20100710 Thunderbird/3.1
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.35 suspend regression (bisected)
References: <4C4C9E40.7070209@infracom.it> <20100725223508.GA9885@merkur.ravnborg.org> <4C4F27C2.6050001@gmail.com> <201007272103.38448.rjw@sisk.pl>
In-Reply-To: <201007272103.38448.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 27/07/2010 21:03, Rafael J. Wysocki wrote:
>> I did bisect again and I did get a different result:
>>
>> c1518f12bab97a6d409a25aaccb02dc8895800f3 is the first bad commit
>>
>> Trying to revert that commit gives:
>>
>> $ git bisect reset
>> $ git revert c1518f12bab97a6d409a25aaccb02dc8895800f3
>> fatal: Commit c1518f12bab97a6d409a25aaccb02dc8895800f3 is a merge but no
>> -m option was given.
>>
>> How am I supposed to proceed now ? (sorry I'm a git newbie)
> The bisect turned up a merge, which means it probably didn't really converge
> for you.
>
> Do you use a camera driver?
Yes, this laptop has an integrated webcam.

Bus 001 Device 004: ID 04f2:b059 Chicony Electronics Co., Ltd


which i think is driven by uvcvideo.ko. I've tryed to rmmod uvcvideo, 
videodev and

v4l1_compat but on current git suspend still hangs in the same way 
(screen black,
backlight on, fans at full speed, no response to ping and... nothing in 
the logs).


R


