Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751389Ab2CGFkx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 00:40:53 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37580 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699Ab2CGFkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 00:40:52 -0500
MIME-Version: 1.0
In-Reply-To: <4F56F0A8.1000600@gmail.com>
References: <1331090098-25097-1-git-send-email-Barry.Song@csr.com>
 <4F56E0AC.8070501@gmail.com> <CAGsJ_4x4CwD+WAE9d+Xob_tfwqmE6SdBdBd5EbC64XBi4Uzvgg@mail.gmail.com>
 <4F56EA49.8070808@gmail.com> <CAGsJ_4xJoKGt3+b_3bteoMyeO615pCxFpMpsH4LtvufFNDv6bA@mail.gmail.com>
 <4F56EBA6.6000704@gmail.com> <CAGsJ_4ypegMQVf0Xet1T5sLaaEDGh5s1Vi6w4t_UQSZp7nYQuQ@mail.gmail.com>
 <4F56ED9D.3000504@gmail.com> <CAGsJ_4x9hGDh+PgrvtXqp-bdbPHABz1ErHGdvFQAr0m9RYM8Vw@mail.gmail.com>
 <4F56F0A8.1000600@gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Wed, 7 Mar 2012 13:40:32 +0800
Message-ID: <CAGsJ_4zPn=phmWw8qSed93QWnTdOF7peh71uom0i6idR1_jFSQ@mail.gmail.com>
Subject: Re: [PATCH v3] MM: CMA: add a simple kernel module as the helper to
 test CMA
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Barry Song <Barry.Song@csr.com>, linux-kernel@vger.kernel.org,
        workgroup.linux@csr.com, mina86@mina86.com,
        Barry Song <Baohua.Song@csr.com>, linux-arm-kernel@lists.infradead.org,
        m.szyprowski@samsung.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/3/7 Cong Wang <xiyou.wangcong@gmail.com>:
> On 03/07/2012 01:17 PM, Barry Song wrote:
>>
>> that is definitely trivial as we are talking about things in a test
>> module. and we are not talking about any bug in the test module as
>> well.
>
>
> I am quite sure *any* patches have bugs will not be merged, IOW, you seem
> don't want your patch merged. :) Fine. That is all.

Cong, i was not againest what you said as a techinical issue.
definitely, it can be a /proc, it is also able to be /sys if you like.
/proc is probably better than /dev from the original design thinking in kernel.

here i focused on people have this module to test CMA at runtime. i
also thought Michal also wants this module to show people the usage of
CMA as well.

i'll much appreciate if you have time to move it to /proc.

-barry
