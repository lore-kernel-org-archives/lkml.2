Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751645Ab2CEFV6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 00:21:58 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:1681 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267Ab2CEFV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 00:21:57 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6639"; a="169100090"
Message-ID: <e33cc9a13154870859d26400b631f729.squirrel@www.codeaurora.org>
In-Reply-To: <CAKLKtzc68sa2df_vUquYdie0WpbckU0nci7rDc+rsESJ7YCLXw@mail.gmail.com>
References: <4934441a17d25c3249556f7bf281b1be.squirrel@www.codeaurora.org>
    <CAKYAXd_6OqQJ78mPJp11gRvGwwg88S_n_Auu=_HdP_ZXzCKrDg@mail.gmail.com>
    <6669559e86c1d13b27e941ff2acf89d2.squirrel@www.codeaurora.org>
    <CAKLKtzc68sa2df_vUquYdie0WpbckU0nci7rDc+rsESJ7YCLXw@mail.gmail.com>
Date: Sun, 4 Mar 2012 21:21:57 -0800 (PST)
Subject: Re: [PATCH v5 2/2] mmc: core: Support packed command for eMMC4.5 
     device
From: merez@codeaurora.org
To: "Saugata Das" <saugata.das@linaro.org>
Cc: merez@codeaurora.org, "Namjae Jeon" <linkinjeon@gmail.com>,
        "Seungwon Jeon" <tgih.jun@samsung.com>, linux-mmc@vger.kernel.org,
        "Chris Ball" <cjb@laptop.org>, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi Merez
>
> On 2 March 2012 19:56,  <merez@codeaurora.org> wrote:
>> Hi,
>>
>> Our tests showed that the write packing improved the performance of the
>> write sequential operations:
>>
>> Long write operation:
>> ----------------------
>> no-packing: 15.8 MB/s
>> packed commands patch (both READ and WRITE packing are enabled): 23.3
>> MB/s
>>
>> Several parallel write operations (sum of all the write throughputs):
>> ---------------------------
>> no-packing: 17.1 MB/s
>> packed commands patch(both READ and WRITE packing are enabled): 25 MB/s
>>
>> Parallel long read and long write operations (write throughput):
>> -----------------------------------------------------------------
>> no-packing: 12.2 MB/s
>> packed commands patch (both READ and WRITE packing are enabled): 16.3
>> MB/s
>>
>> Parallel short read and long write operations (write throughput):
>> -----------------------------------------------------------------
>> no-packing: 15.4 MB/s
>> packed commands patch (both READ and WRITE packing are enabled): 16.4
>> MB/s
>>
>> Several Parallel short read and short write operations (sum of all the
>> write throughputs):
>> --------------------------------------------------------------------------
>> no-packing: 12.5 MB/s
>> packed commands patch (both READ and WRITE packing are enabled): 15.5
>> MB/s
>>
>
> How did you perform the above tests ?
The sequential tests were performed with the lmdd application.
Thanks,
Maya Erez
Consultant for Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum


