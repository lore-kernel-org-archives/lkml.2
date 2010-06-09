Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757072Ab0FIJWL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 05:22:11 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:33549 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756939Ab0FIJWK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 05:22:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=N3qgdEgkUNvaxN1yHKtCNCN2YIOrhORA7qmoKIU1rM4ftD1Kn7Rjv90o7+wquhPiem
         YqwJKJKm1zHFTKZIFaMSbHriil/Plt1j68meMeBuH8DMnFtnnQ068HXC+wIKsFulL3Bn
         A6l6URZLA477+ttI/S4B4G0acPg+s3fBFUPME=
MIME-Version: 1.0
In-Reply-To: <AANLkTik97svBnM-54zaFwKr9E0SFyq5fXeg2Y2aNO56H@mail.gmail.com>
References: <AANLkTik0UvRGmGeZOMaJVaoHk-lv2V8umAF3EIckh9CT@mail.gmail.com>
	<1276051329.13426.48.camel@localhost.localdomain>
	<AANLkTikSaMcKPh5GI3Tq2SZkVXsNKwE8pfR8me5IHDDv@mail.gmail.com>
	<AANLkTik4kdjh1Wmo704_3-jzxmMUd8vGce9Mdojveml1@mail.gmail.com>
	<AANLkTimkJjZ32kIl4rjikZqBrFCFPw0zCS7b9uh6gO2V@mail.gmail.com>
	<AANLkTik97svBnM-54zaFwKr9E0SFyq5fXeg2Y2aNO56H@mail.gmail.com>
Date: Wed, 9 Jun 2010 17:22:07 +0800
Message-ID: <AANLkTil3Fiv5G0nVgy64rwV2SNbNALrVgeGBPeB1kedw@mail.gmail.com>
Subject: Re: When and how to use ftrace?
From: Ryan Wang <openspace.wang@gmail.com>
To: wu zhangjin <wuzhangjin@gmail.com>
Cc: Neependra Khare <neependra.khare@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>, linux-kernel@vger.kernel.org,
       kernelnewbies@nl.linux.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/6/9 wu zhangjin <wuzhangjin@gmail.com>:
> Hi,
>
> On Wed, Jun 9, 2010 at 4:14 PM, Ryan Wang <openspace.wang@gmail.com> wrote:
> [...]
>>>>
>>>> --
>>>> To unsubscribe from this list: send an email with
>>>> "unsubscribe kernelnewbies" to ecartis@nl.linux.org
>>>> Please read the FAQ at http://kernelnewbies.org/FAQ
>>>>
>>>
>>>
>>
>> Seems ftrace is helpful to study the activities inside the kernel to me.
>> I wonder whether it can be useful to debug kernel bugs. And if so, will
>> you please give me some examples?
>
> Yeah, did you read this paper written by Steven: "Finding Origins of
> Latencies Using Ftrace" (please google to download it).
> If not, please read it. that paper will tell you what Ftrace really is
> and will show the demos how to play with it.
>
>> Or so far it's mainly used for
>> observing the running status of kernel?
>
> Ftrace is originally created for debugging and optimizing the
> preempt-rt, but of course, it becomes a tracing framework currently.
>
> It not only show you what the kernel space does when you do something
> in user space,
> but will show you the calling tree of kernel functions, time consuming
> of  every function and
> even allow you to filter the parts you care about.
>
> If you need more info about it, please refer to:
>
> [1] Debugging the kernel using Ftrace
> http://lwn.net/Articles/365835/
> http://lwn.net/Articles/366796/
> [2] Ftrace usage ....
> Documentation/trace/ftrace.txt
> Documentation/trace/ftrace-desgin.txt
> [3] Tools for Ftrace
> trace-cmd from readhat...
>
> Regards,
>
> --
> Studying engineer. Wu Zhangjin
> Lanzhou University      http://www.lzu.edu.cn
> Distributed & Embedded System Lab      http://dslab.lzu.edu.cn
> School of Information Science and Engeneering         http://xxxy.lzu.edu.cn
> wuzhangjin@gmail.com         http://falcon.oss.lzu.edu.cn
> Address:Tianshui South Road 222,Lanzhou,P.R.China    Zip Code:730000
> Tel:+86-931-8912025
>

Thanks all!
