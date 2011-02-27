Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271Ab1B0PiV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 10:38:21 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:41733 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076Ab1B0PiS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 10:38:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=B2hocqzPAUD97kleqjwHtRruT9eOTqiSuE9LTv6BDacfPkm/qZ7YnkPKimmwiJmaxj
         p6zOHQq+qmuDROptPTBCsmIKKlyiWxjROZ53OSQD/YT6L1yb2OYdx6dU6Sx9KUqnZ0ze
         SJbVOz+0QyTlsQJOr6JUPQuEDwQrTonXVqJnc=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <87fwr9jxya.fsf@cruithne.co.teklibre.org>
References: <20110225222210.GA3618@tuxdriver.com>
	<AANLkTingkcc-dvs_8Nr0vYXdXvuDHEn6sz14tnHzLp8W@mail.gmail.com>
	<87fwr9jxya.fsf@cruithne.co.teklibre.org>
Date: Sun, 27 Feb 2011 16:38:17 +0100
Message-ID: <AANLkTinpG-xAC-VV-j7EBJB522+BqCyyFd_6N3KEr2Cf@mail.gmail.com>
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

On Sun, Feb 27, 2011 at 4:31 PM, Dave Täht <d@taht.net> wrote:
>
> Sedat Dilek <sedat.dilek@googlemail.com> writes:
>
>> On Fri, Feb 25, 2011 at 11:22 PM, John W. Linville
>> <linville@tuxdriver.com> wrote:
>>> Announcement
>>>
>>> The bufferbloat project [1] is pleased to announce the availability
>>> of the debloat-testing Linux kernel git tree:
>>>
>>>   git://git.infradead.org/debloat-testing.git
>
> ----snip----
>
>> Hi,
>>
>> it should be "localversion-debloat" in the commit-subject in [1] (not
>> "localversion-wireless") :-).  "-db" as suffix is IMHO not very
>> meaningful... Why not add simply a suffix called "-debloat"?  (Anyway,
>> I will revert this patch because I don't want to have any suffix added
>> automatically.)
>>
>> I have several other questions, but I start compiling first and test
>> this debloat kernel.
>
> Excellent. At moment I would recommend building "low latency preempt
> desktop" kernels with a high HZ value (400 or 1000), enabling highres
> timers, and compiling in SFB as a module. (I'd like the default for SFB
> to be "m" rather than "n", too)
>
>>
>> Regards,
>> - Sedat -
>>
>> [1] "Add localversion-wireless to identify builds from this tree."
>> http://git.infradead.org/debloat-testing.git/commit/3f9bdb4f44b076feda72d353d8ad717831416f36
>> _______________________________________________
>> Bloat-devel mailing list
>> Bloat-devel@lists.bufferbloat.net
>> https://lists.bufferbloat.net/listinfo/bloat-devel
>
> --
> Dave Taht
> http://nex-6.taht.net
>

These "debloat guys" are fast :-).
I was just preparing my build-system (which I normally use to
debianize linux-next kernels).
Any other recommendation for kernel-config options?
For example:
linux-next has already CONFIG_NET_SCH_CHOKE (but I have unset it).
Which commits are in debloat-testing GIT but not in linux-next tree?
Are you planning debloat feature for 2.6.39?

- Sedat -
