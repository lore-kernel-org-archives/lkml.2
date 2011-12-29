Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664Ab1L2ATc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 19:19:32 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:52844 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753560Ab1L2AT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 19:19:29 -0500
Message-ID: <4EFBB1F9.5050506@fb.com>
Date: Wed, 28 Dec 2011 16:19:05 -0800
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Kumar Sundararajan <kumar@fb.com>, <linux-kernel@vger.kernel.org>,
        john stultz <johnstul@us.ibm.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH 1/4] Add clock_gettime_ns syscall
References: <cover.1324831829.git.luto@amacapital.net> <16ecaa6abb8b7a25ef31970f71a42c7e2ba5416c.1324831829.git.luto@amacapital.net> <4EFB67AB.7060707@fb.com> <CALCETrVz1ADNxeLzPmeWXPU5ApfKURH2vnged2A2Vng8-hUxcw@mail.gmail.com> <20111228224536.GA1025@dev3310.snc6.facebook.com> <CALCETrW+9OoEQnP1+9MJX+JO5Ch42QhUeo8i=k9YdaCwWhg=Xw@mail.gmail.com>
In-Reply-To: <CALCETrW+9OoEQnP1+9MJX+JO5Ch42QhUeo8i=k9YdaCwWhg=Xw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.18.252]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.5.7110,1.0.211,0.0.0000
 definitions=2011-12-28_08:2011-12-28,2011-12-28,1970-01-01 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/28/11 3:42 PM, Andy Lutomirski wrote:

> Something like:
>
> u64 __vdso_clock_gettime_ns(clock_t clockid, struct timens_extra *extra)
> {
>    extra->padding = 0;
>    return<the time>;
> }
>
>
> might be okay.

I think you want s64 as the return type (for both 32 and 64 bit). This 
is what I was trying to suggest as well.

  -Arun (Clicks the virtually non-existent like button)
