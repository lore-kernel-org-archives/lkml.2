Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236Ab0GLQ6k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 12:58:40 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62091 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756122Ab0GLQ6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 12:58:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=nHFEqhStBehZXERoO9rfvBTqctLKt2dZR0MduGc/b038tBd+cfOLBaoMbeh0AyR5+m
         QMKTIbbEzRl6Xyp5In+aeX/IZe144Ed0YXdd1k4Izj3K4UpMdiLoBDaqOjlmj4wGjSrO
         g+pE0VqwfNzeUpUfL6K7tuKECp5Rk34/TNsVY=
Message-ID: <4C3B49B4.20300@panasas.com>
Date: Mon, 12 Jul 2010 19:58:28 +0300
From: Benny Halevy <bhalevy@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.35-rc4 - CONFIG_LOCALVERSION ignored?
References: <AANLkTikoCiIoo4nfmoFGBMOkc4lNKTU_ouE15EmV1j-h@mail.gmail.com> <201007052325.56971.rjw@sisk.pl>
In-Reply-To: <201007052325.56971.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul. 06, 2010, 0:25 +0300, "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> On Monday, July 05, 2010, Linus Torvalds wrote:
>> Hey everybody, there's finally a new -rc out there..
>>
>> I've been back online for a week, and at least judging by the kinds of
>> patches and pull requests I've been getting, I have to say that I
>> think that having been strict for -rc3 ended up working out pretty
>> well. The diffstat of rc3..rc4 looks quite reasonable, despite the
>> longer window between rc's. And while there were certainly some things
>> that needed fixing, I'm hoping that we'll have a timely 2.6.35 release
>> despite my vacation (my longest time away from the kernel in many
>> years, I do believe - I followed email on a cellphone, but did not a
>> single kernel compile, and had a great time under water).
>>
>> So go out and test -rc4. It fixes a number of regressions, a couple of
>> them harking back to from before 2.6.34. Networking, cfq, i915 and
>> radeo. And filesystem writeback performance issues, etc. It's all
>> good.
> 
> Hmm.  Am I dong anything particularly wrong, or is CONFIG_LOCALVERSION ignored
> now, as it seems?

Not working for me either in 2.6.35-rc4.

Note that I have a localversion-xxxx file in my root directory
which is also ignored, regardless of CONFIG_LOCALVERSION
and CONFIG_LOCALVERSION_AUTO.

Benny

> 
> Rafael
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

