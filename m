Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758512Ab0EYBCa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 21:02:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28391 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758083Ab0EYBC2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 21:02:28 -0400
Message-ID: <4BFB218F.6030800@redhat.com>
Date: Mon, 24 May 2010 22:02:07 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: Jonathan Corbet <corbet@lwn.net>
CC: linux-kernel@vger.kernel.org, Harald Welte <laforge@gnumonks.org>,
       linux-fbdev@vger.kernel.org, JosephChan@via.com.tw,
       ScottFang@viatech.com.cn,
       =?ISO-8859-1?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>,
       Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
       linux-media@vger.kernel.org
Subject: Re: [PATCH 5/5] Add the viafb video capture driver
References: <1273098884-21848-1-git-send-email-corbet@lwn.net>	<1273098884-21848-6-git-send-email-corbet@lwn.net>	<4BF924E3.5020702@redhat.com> <20100524172237.7c17cd57@bike.lwn.net>
In-Reply-To: <20100524172237.7c17cd57@bike.lwn.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Corbet wrote:
> On Sun, 23 May 2010 09:51:47 -0300
> Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
> 
>> The driver is OK to my eyes. I just found 2 minor coding style issues.
>> it is ok to me if you want to sent it via your git tree.
>>
>> Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> Great, thanks for taking a look!
> 
> All of the precursor stuff is in mainline now, so it can go via whatever
> path.  I'll just go ahead and request a pull in the near future unless
> somebody objects.

OK.

>>> +	.sizeimage	= VGA_WIDTH*VGA_HEIGHT*2,
>> CodingStyle: please use spaces between values/operators. Not sure why, but
>> newer versions of checkpatch.pl don't complain anymore on some cases.
> 
> Interesting...for all of my programming life I've left out spaces around
> multiplicative operators - a way of showing that they bind more tightly
> than the additive variety.  I thought everybody else did that too.
> CodingStyle agrees with you, though; I'll append a patch fixing these up.

We all have some sort of different CodingStyle that were inherited from previous
programming practices... I used to just not add any space at all at expressions, 
as C is a compact language, and I was a bit lazy ;)

Yet, when reviewing lots of code, those spaces help to read a code quicker
than without. Not sure why, but my guess is that the brain can do a faster
parsing when the words are separated from operators. Or maybe it is just because
it is easier to parse patches when everybody uses the same Coding Style.

> Learn something every day...

Very true ;)

-- 

Cheers,
Mauro
