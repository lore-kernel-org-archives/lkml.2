Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752512Ab1B0QBf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 11:01:35 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:54543 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327Ab1B0QB3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 11:01:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=nEcPV6HJ6ISgE2dRiihIbrQPKPPa17LYh/3uSemjE2PR6wQIFWqLrumNkkIyGSemtA
         6W5nZO2KLZHA40Y68jZ0+6k86wdcGkClBLMJnFrlqLzTtDN70BAnr0BB34BrZ9tJP+ed
         3sUj6nWy1Wv/yB0KNyt9Gs+49B9XCbvqq8TTs=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <8739n9ii7z.fsf@cruithne.co.teklibre.org>
References: <20110225222210.GA3618@tuxdriver.com>
	<AANLkTingkcc-dvs_8Nr0vYXdXvuDHEn6sz14tnHzLp8W@mail.gmail.com>
	<87fwr9jxya.fsf@cruithne.co.teklibre.org>
	<AANLkTinpG-xAC-VV-j7EBJB522+BqCyyFd_6N3KEr2Cf@mail.gmail.com>
	<8739n9ii7z.fsf@cruithne.co.teklibre.org>
Date: Sun, 27 Feb 2011 17:01:27 +0100
Message-ID: <AANLkTi=Cp7N4xqPyU6KWF6DOzFytxaA2BeoXhnhsZ6dp@mail.gmail.com>
Subject: Re: ANNOUNCE: debloat-testing kernel git tree
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: =?UTF-8?Q?Dave_T=C3=A4ht?= <d@taht.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        bloat-devel@lists.bufferbloat.net, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 27, 2011 at 4:56 PM, Dave Täht <d@taht.net> wrote:
> Sedat Dilek <sedat.dilek@googlemail.com> writes:
>
>> On Sun, Feb 27, 2011 at 4:31 PM, Dave Täht <d@taht.net> wrote:
>>>
>>> Sedat Dilek <sedat.dilek@googlemail.com> writes:
>>>
>>>> On Fri, Feb 25, 2011 at 11:22 PM, John W. Linville
>>>> <linville@tuxdriver.com> wrote:
>>>>> Announcement
>>>>>
>>>>> The bufferbloat project [1] is pleased to announce the availability
>>>>> of the debloat-testing Linux kernel git tree:
>>>>>
>>>>>   git://git.infradead.org/debloat-testing.git
>>>
>>> ----snip----
>
>>> Excellent. At moment I would recommend building "low latency preempt
>>> desktop" kernels with a high HZ value (400 or 1000), enabling highres
>>> timers, and compiling in SFB as a module. (I'd like the default for SFB
>>> to be "m" rather than "n", too)
>>>
>
>> These "debloat guys" are fast :-).  I was just preparing my
>> build-system (which I normally use to debianize linux-next kernels).
>> Any other recommendation for kernel-config options?  For example:
>> linux-next has already CONFIG_NET_SCH_CHOKE (but I have unset it).
>
> Enable CHOKe.
>
> The HZ value change is due to my worry that we've smashed latency so
> much in the driver/mac layer that it's interacting with the higher
> layers somewhat badly... So we need to add more hooks to the servo loops
> involved in order to have a normal HZ.
>
>> Which commits are in debloat-testing GIT but not in linux-next tree?
>
> The current list was in the release announcement. More on the way
> (mostly embedded drivers at this point) git pull early and often!
>
>> Are you planning debloat feature for 2.6.39?
>
> Depends on how many testers we get and what the results are.
>
> I feel the eBDP stuff will not be ready during this release cycle. SFB
> and CHOKe are in net-next, so, probably. Various driver patches -
> particularly those that increase the available dynamic range via
> ethtool, (e.g lowering the bottommost TX queue limit to, like, 4,
> especially for home gateways) may make it out if people look harder into
> the issue.
>
>>
>> - Sedat -
>
> --
> Dave Taht
> http://nex-6.taht.net
>

OK, thanks for the explanations.

Concerning "more drivers":
What would I have to do to modify ath5k?
I looked into the ath9k patch in debloat-testing GIT and it was to mod
some (TX/BUF) values only.
Not sure if ath9k is/was "well" prepared or only a good choice by the
testers/committers as they own such a device.

- Sedat -
