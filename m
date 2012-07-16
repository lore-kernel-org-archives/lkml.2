Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702Ab2GPPG7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 11:06:59 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:41832 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751085Ab2GPPG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 11:06:56 -0400
Message-ID: <50042DDD.6050008@xenotime.net>
Date: Mon, 16 Jul 2012 08:06:05 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stefan Beller <stefanbeller@googlemail.com>
CC: Rob Landley <rob@landley.net>, Jeff Garzik <jgarzik@pobox.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Rewrite Documentation/SubmittingPatches.
References: <CALbm-EbggDYBwEDmo6bjEO_=p0YEmLHASNkfAN5J-P4-mT-vgg@mail.gmail.com>	<CAFtxgO5=oANwXJ34rkKjWFiOxgB1hvEDToZXt=9w5gKoVOsOBw@mail.gmail.com>	<CALbm-EY-4iQy3HYi4bYdLVsLyr+iDecTUsVt43+_Nf9v_rkTyw@mail.gmail.com>	<50032F24.8050903@landley.net> <CALbm-EbZg+BtW+BTokA2Xz+P1DSt3-WR+xV5DB_GrieLqR27NA@mail.gmail.com>
In-Reply-To: <CALbm-EbZg+BtW+BTokA2Xz+P1DSt3-WR+xV5DB_GrieLqR27NA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2012 11:20 PM, Stefan Beller wrote:

> Heh,
> It seems as if googlemail is not a suited interface to contribute to linux.
> 
> The raw patch (without clipped lines) can be found at
> http://pastebin.com/raw.php?i=3QKRZz2M
> 
> Stefan
> 
> 2012/7/15 Rob Landley <rob@landley.net>:
>> On 07/13/2012 09:45 AM, Stefan Beller wrote:
>>> This updates the documentation on how to create patches and send
>>> these to the kernel mailing list.
>>>
>>> The documentation before was written in times before git was there,
>>> so the crafting of the patch needed to be done manually by diff -up
>>> in the right directory.
>>>
>>> This patch aims at simplifying the patch sending process, without
>>> breaking the output results.
>>
>> This patch is whitespace damaged (wordwrapped at the @@ lines), which is
>> either ironic or unfortunate. (After Alanis Morisette, I can't tell
>> anymore.)
>>
>>> A discussion can be found at
>>> https://plus.google.com/111049168280159033135/posts/ekAxK9achsA
>>>
>>> Signed-off-by: Stefan Beller <stefanbeller@googlemail.com>
>>> Acked-by: Jeff Garzik jgarzik@pobox.com
>>
>> But other than that Jeff's objection was my big one, and that's
>> addressed in v2, so:
>>
>> Acked-by: Rob Landley <rob@landley.net>
>>
>> Rob
>> --


Q1.  Who is going to merge the patch?  Rob or someone else?

Q2.  Are you (Stefan) going to send a patch that is mergeable?



-- 
~Randy
