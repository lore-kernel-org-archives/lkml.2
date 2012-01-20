Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485Ab2ATOqP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 09:46:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41275 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751815Ab2ATOqL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 09:46:11 -0500
Message-ID: <4F197E1F.20206@zytor.com>
Date: Fri, 20 Jan 2012 06:45:51 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
CC: device-mapper development <dm-devel@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: dmsetup fails on latest kernel
References: <CALLzPKb6kimUjgj9qN9ehx8RO3-bXvGetFQgx48T1rMm22oD2g@mail.gmail.com> <CALLzPKbeXN5gdngo8uYYU8mAow=XhrwBFBhKfG811f37BubQOg@mail.gmail.com> <4F188817.3090104@zytor.com> <CALLzPKapudkuBxsF49jMAOtVpeu=hpa9SgY=WewtU6GYEm6M_Q@mail.gmail.com>
In-Reply-To: <CALLzPKapudkuBxsF49jMAOtVpeu=hpa9SgY=WewtU6GYEm6M_Q@mail.gmail.com>
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2012 05:35 AM, Kasatkin, Dmitry wrote:
> On Thu, Jan 19, 2012 at 11:16 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> Here is a patch which should fix this problem.  I will run a few more
>> tests and then push it with the rest of the urgent queue to Linus.
>>
>>        -hpa
> 
> Hi,
> 
> Yes. It solves the problem..
> Do you still want straces?
> 

No need, thanks!

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

