Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363Ab1EBPhJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 11:37:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39993 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751146Ab1EBPhF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 11:37:05 -0400
Message-ID: <4DBECF6A.6060203@zytor.com>
Date: Mon, 02 May 2011 08:36:10 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Hans Rosenfeld <hans.rosenfeld@amd.com>, brgerst@gmail.com,
        tglx@linutronix.de, mingo@elte.hu, suresh.b.siddha@intel.com,
        eranian@google.com, robert.richter@amd.com, Andreas.Herrmann3@amd.com,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] fork: avoid weak function arch_dup_task_struct
References: <2be7032a-e4b6-4ce7-af53-532d77dbfb48@email.android.com>	<1303914395-841373-2-git-send-email-hans.rosenfeld@amd.com>	<20110501122559.bbf91079.akpm@linux-foundation.org>	<4DBDE5C0.1030907@zytor.com> <20110501171149.9a9342fc.akpm@linux-foundation.org>
In-Reply-To: <20110501171149.9a9342fc.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2011 05:11 PM, Andrew Morton wrote:
> On Sun, 01 May 2011 15:59:12 -0700 "H. Peter Anvin"<hpa@zytor.com>  wrote:
>
>> On 05/01/2011 12:25 PM, Andrew Morton wrote:
>>> On Wed, 27 Apr 2011 16:26:35 +0200 Hans Rosenfeld<hans.rosenfeld@amd.com>  wrote:
>>>
>>>> Avoid potential gcc bug by not using a weak function for
>>>> arch_dup_task_struct. Use an #ifdef'ed static function for
>>>> archs that don't have a special arch_dup_task_struct implementation.
>>>
>>> The patch is unreviewable (and hence unusable) if you don't describe
>>> this "potential gcc bug".
>>
>> http://lkml.indiana.edu/hypermail/linux/kernel/0804.3/3202.html
>>
>
> gcc-4.1.0 and 4.1.1 were explicitly banned via a test in
> include/linux/compiler-gcc4.h for this reason.
>

OK, no issue then.  Sorry for the noise.

	-hpa
