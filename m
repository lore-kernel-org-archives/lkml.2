Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757587Ab2BIOGz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 09:06:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35196 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753372Ab2BIOGy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 09:06:54 -0500
Message-ID: <4F33D2F1.5000606@redhat.com>
Date: Thu, 09 Feb 2012 09:06:41 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Johannes Stezenbach <js@sig21.net>
CC: Hillf Danton <dhillf@gmail.com>,
        =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: swap storm since kernel 3.2.x
References: <201202041109.53003.toralf.foerster@gmx.de> <201202051107.26634.toralf.foerster@gmx.de> <CAJd=RBCvvVgWqfSkoEaWVG=2mwKhyXarDOthHt9uwOb2fuDE9g@mail.gmail.com> <201202080956.18727.toralf.foerster@gmx.de> <20120208115244.GA24959@sig21.net> <CAJd=RBDbYA4xZRikGtHJvKESdiSE-B4OucZ6vQ+tHCi+hG2+aw@mail.gmail.com> <20120209113606.GA8054@sig21.net> <CAJd=RBDzUpUgZLVU+WSfb8grzMAbi3fcyyZkpX8qpaxu6zYe1g@mail.gmail.com> <20120209132155.GA15147@sig21.net> <20120209135407.GA15492@sig21.net>
In-Reply-To: <20120209135407.GA15492@sig21.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/2012 08:54 AM, Johannes Stezenbach wrote:
> On Thu, Feb 09, 2012 at 02:21:55PM +0100, Johannes Stezenbach wrote:
>> it looks good.  Neither do I get the huge debug_objects_cache
>> nor does it swap, after running a crosstool-ng toolchain build.
>> Well, last time I also had one kvm -m 1G instance running.  I'll
>> try if that triggers the issue.  So far:
>
> The kvm produced a bunch of page allocation failures
> on the host:

> (repeats a few times)
>
> I guess that is expected with your patch?

That is indeed why my patch series was significantly larger
than Hillf's little test patch :)

-- 
All rights reversed
