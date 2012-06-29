Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932943Ab2F2U0M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 16:26:12 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:60645 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932268Ab2F2U0K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 16:26:10 -0400
Message-ID: <4FEE0F2C.40407@linaro.org>
Date: Fri, 29 Jun 2012 13:25:16 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: LKML <linux-kernel@vger.kernel.org>, Russell King <linux@arm.linux.org.uk>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
Subject: Re: [PATCH 00/15][RFC] Android ETM driver changes
References: <1339552887-17204-1-git-send-email-john.stultz@linaro.org> <CACRpkdamJ1+YpJmkihy3M79wDmHFrbyJ9n9WjG98rOip8c2j2w@mail.gmail.com>
In-Reply-To: <CACRpkdamJ1+YpJmkihy3M79wDmHFrbyJ9n9WjG98rOip8c2j2w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12062920-5112-0000-0000-0000099A9171
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2012 09:13 AM, Linus Walleij wrote:
> On Wed, Jun 13, 2012 at 4:01 AM, John Stultz <john.stultz@linaro.org> wrote:
>
>> The Android kernel tree has a number of changes to the ETM driver.
>> Arve sent the first 9 of these to the list over a year ago and
>> got very little response.
>>
>> I didn't want these to get lost, so I pinged Alexander about
>> these privately and he stated that he wasn't actively
>> maintaining the driver, but after skimming the entire set
>> acked the series and suggested I send it on to Russel for
>> review and possible inclusion.
>>
>> So here they are. Please let me know if there are any
>> objections to merging these, or if further changes are
>> needed.
> I finally reviewed them, sorry for the lag.
>
> In all this is very useful stuff, maybe people just don't realize how
> useful it really is. I suggest you to write a small doc in
> Documentation/arm/etm.txt on how to get started etc.
>
> Thanks for your efforts!
Thanks for the review!  I'll try to work with Arve to see if I can help 
address some of the issues you pointed out and to improve the documentation.

thanks
-john


