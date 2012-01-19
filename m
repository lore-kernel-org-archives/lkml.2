Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932973Ab2ASUaV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 15:30:21 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37976 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932705Ab2ASUaU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 15:30:20 -0500
Message-ID: <4F187D54.602@zytor.com>
Date: Thu, 19 Jan 2012 12:30:12 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>,
        device-mapper development <dm-devel@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: dmsetup fails on latest kernel
References: <CALLzPKb6kimUjgj9qN9ehx8RO3-bXvGetFQgx48T1rMm22oD2g@mail.gmail.com> <CALLzPKbeXN5gdngo8uYYU8mAow=XhrwBFBhKfG811f37BubQOg@mail.gmail.com> <4F187980.2000306@zytor.com> <CA+55aFxNVaJ8AYXka8khUnkzr=tND9+SMpQ9CU0KFDbvxAJY0Q@mail.gmail.com>
In-Reply-To: <CA+55aFxNVaJ8AYXka8khUnkzr=tND9+SMpQ9CU0KFDbvxAJY0Q@mail.gmail.com>
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19/2012 12:17 PM, Linus Torvalds wrote:
> On Thu, Jan 19, 2012 at 12:13 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> Could you please send me:
>>
>> a) your full strace;
>> b) arch/x86/kernel/syscall_32.o from your build?
> 
> Btw, the strace before-and-after (working vs nonworking) would
> probably be useful. They aren't easily comparable (all the random
> pointers change depending on allocations etc), but some scripting and
> editing out pointer values might make the difference be obvious.
> 
>                          Linus

Possible.  I have actually reproduced it and reduced it to a small test
case already, so I hopefully will have it nailed down soon.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

