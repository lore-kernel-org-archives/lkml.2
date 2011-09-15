Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934431Ab1IOSuP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 14:50:15 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37899 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934209Ab1IOSuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 14:50:13 -0400
MIME-Version: 1.0
In-Reply-To: <20110908132756.GT31717@ics.muni.cz>
References: <20110720082640.GZ7561@ics.muni.cz> <4E280964.6070000@ct.jp.nec.com>
 <20110721132627.GY7561@ics.muni.cz> <4E291F28.2040609@ct.jp.nec.com>
 <20110722081903.GB7561@ics.muni.cz> <4E2A7806.1060601@ce.jp.nec.com>
 <20110724221619.GM16487@ics.muni.cz> <4E367256.8020206@ct.jp.nec.com> <20110908132756.GT31717@ics.muni.cz>
From: Mike Snitzer <snitzer@redhat.com>
Date: Thu, 15 Sep 2011 14:49:52 -0400
X-Google-Sender-Auth: kH0xutcVdeyEulbE558kzQG1of4
Message-ID: <CAMM=eLd9fToJ5Kh+vf4WG1ZN-qTc2CX98-+BUkFWWQQ=tCG7LQ@mail.gmail.com>
Subject: Re: request baset device mapper in Linux
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>, agk@redhat.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/9/8 Lukas Hejtmanek <xhejtman@ics.muni.cz>:
> On Mon, Aug 01, 2011 at 06:31:02PM +0900, Kiyoshi Ueda wrote:
>> Hi Lukas,
>>
>> Lukas Hejtmanek wrote:
>> > On Sat, Jul 23, 2011 at 04:28:06PM +0900, Jun'ichi Nomura wrote:
>> >> As Kiyoshi suggested, it is important to know whether this
>> >> problem occurs with the latest kernel.
>> >> So if you could try 3.0, it would be very helpful.
>> >
>> > so, do I need to check recent kernel as the patch works for me?
>>
>> Yes, please.
>> (Unfortunately my storage has been broken today :-<)
>>
>> CPU usage seems to be one of the reasons for your case, but I
>> still cannot understand why memory pressure is needed.
>> I want to know your problem also occurs on 3.0 without the patch.
>
> Well, I tried 3.0.3 kernel. It is not so bad as 2.6.32.36, but it is not as
> good as the same kernel with your patch.
>
> CPU load is caused by ksoftirqd (30-40%) and kworker (30%).
>
> Overal speed is about 2.5GB/s. With your patch I can reach 2.8-2.9GB/s.

Does "with your patch" mean against 3.0.3 or the original 2.6.32 kernel?

If you apply the patch to the 3.0.3 kernel do you regain the performance?

Thanks,
Mike
