Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754278Ab2GYAMW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 20:12:22 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:56603 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200Ab2GYAMV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 20:12:21 -0400
MIME-Version: 1.0
In-Reply-To: <500F18E7.2040809@suse.cz>
References: <CA+qZnSRNAAN6erat3Umuk6U9VYuc5SiQYK6PL8bHYAOcQ+SnAw@mail.gmail.com>
	<CA+qZnSS2N4QZ13qATNFCbhJ6BRy4ZfpEBur45OUkuggPxYe4qA@mail.gmail.com>
	<20120724115300.070d0ef7@pyramind.ukuu.org.uk>
	<CA+qZnSSazFWLKq5ao51JX=H-NCbwLD=6ypGXOeqQF72s7ZbTVA@mail.gmail.com>
	<500F18E7.2040809@suse.cz>
Date: Wed, 25 Jul 2012 08:12:20 +0800
Message-ID: <CA+qZnSQ5N2pE1F8gvJuNP1dkxcBvfVehAD9qb81yV+2pZRwQ3A@mail.gmail.com>
Subject: Re: Suse 11 SP1 kernel panic on HP hardware
From: tingwei liu <tingw.liu@gmail.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        dhillf@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2012 at 5:51 AM, Jiri Slaby <jslaby@suse.cz> wrote:
> On 07/24/2012 12:56 PM, tingwei liu wrote:
>> On Tue, Jul 24, 2012 at 6:53 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>>> On Tue, 24 Jul 2012 18:39:20 +0800
>>> tingwei liu <tingw.liu@gmail.com> wrote:
>>>
>>>> Suse 11 SP1 kernel panic。
>>>>
>>>> I can't debug it without debuginfo. Who can give me a link of sels
>>>> 2.6.32.12-0.7.default.debug or give some advise.
>>>
>>> For distribution kernels (which tend to contain lots of other patches)
>>> it is best to talk to your distribution support as a starter and/or their
>>> forums.
>>>
>> I have report bug on suse website, but I haven't got any response until now!
>
> Well, where exactly?
>
I report a bug in this page
http://support.novell.com/additional/bugreport.html with username
tingweiliu.
>> Can you give some advice?
>> I thought this maybe a kernel bug.
>
> Yes, first upgrade to the latest kernel provided by Suse (2.6.32.59).
But I want to find the reason.
Thanks!
>
> You can also try to reproduce with -vanilla flavour. This is a pure
> upstream version with no suse patches (you will lose apparmor for example):
> http://download.opensuse.org/repositories/Kernel:/SLE11-SP1/SUSE_SLE-11_SP1/
>
> thanks,
> --
> js
> suse labs
