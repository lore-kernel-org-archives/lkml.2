Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752263Ab1B0PmU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 10:42:20 -0500
Received: from toutatis.isc.org ([149.20.54.64]:32930 "EHLO
	mainmail.teklibre.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161Ab1B0PmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 10:42:17 -0500
X-Greylist: delayed 601 seconds by postgrey-1.27 at vger.kernel.org; Sun, 27 Feb 2011 10:42:17 EST
From: d@taht.net (Dave =?utf-8?Q?T=C3=A4ht?=)
To: sedat.dilek@gmail.com
Cc: "John W. Linville" <linville@tuxdriver.com>,
        bloat-devel@lists.bufferbloat.net, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: ANNOUNCE: debloat-testing kernel git tree
Organization: Teklibre - http://www.teklibre.com
References: <20110225222210.GA3618@tuxdriver.com>
	<AANLkTingkcc-dvs_8Nr0vYXdXvuDHEn6sz14tnHzLp8W@mail.gmail.com>
Date: Sun, 27 Feb 2011 08:31:41 -0700
In-Reply-To: <AANLkTingkcc-dvs_8Nr0vYXdXvuDHEn6sz14tnHzLp8W@mail.gmail.com>
	(Sedat Dilek's message of "Sun, 27 Feb 2011 16:23:59 +0100")
Message-ID: <87fwr9jxya.fsf@cruithne.co.teklibre.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Sedat Dilek <sedat.dilek@googlemail.com> writes:

> On Fri, Feb 25, 2011 at 11:22 PM, John W. Linville
> <linville@tuxdriver.com> wrote:
>> Announcement
>>
>> The bufferbloat project [1] is pleased to announce the availability
>> of the debloat-testing Linux kernel git tree:
>>
>>   git://git.infradead.org/debloat-testing.git

----snip----

> Hi,
>
> it should be "localversion-debloat" in the commit-subject in [1] (not
> "localversion-wireless") :-).  "-db" as suffix is IMHO not very
> meaningful... Why not add simply a suffix called "-debloat"?  (Anyway,
> I will revert this patch because I don't want to have any suffix added
> automatically.)
>
> I have several other questions, but I start compiling first and test
> this debloat kernel.

Excellent. At moment I would recommend building "low latency preempt
desktop" kernels with a high HZ value (400 or 1000), enabling highres
timers, and compiling in SFB as a module. (I'd like the default for SFB
to be "m" rather than "n", too)

>
> Regards,
> - Sedat -
>
> [1] "Add localversion-wireless to identify builds from this tree."
> http://git.infradead.org/debloat-testing.git/commit/3f9bdb4f44b076feda72d353d8ad717831416f36
> _______________________________________________
> Bloat-devel mailing list
> Bloat-devel@lists.bufferbloat.net
> https://lists.bufferbloat.net/listinfo/bloat-devel

-- 
Dave Taht
http://nex-6.taht.net
