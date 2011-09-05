Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751870Ab1IEItd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 04:49:33 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:46142 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470Ab1IEIt2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 04:49:28 -0400
MIME-Version: 1.0
In-Reply-To: <CAF1ivSZxAuVaivJyoZ=gnMu-YY7AcnBwCWtD74DqPuYAASxTxA@mail.gmail.com>
References: <4E5B4AAF.2040101@samsung.com>
	<CAF1ivSaveqVs8dGF+HZBytJpUpTJPysUox=qmHDTFQvqBmm+rw@mail.gmail.com>
	<4E5B65C6.6070300@samsung.com>
	<CAH9JG2Xfh7JcdBdaCUuD9wFyNPTXg_0JbvVZkEWK5jT2=W3ybA@mail.gmail.com>
	<CAF1ivSZxAuVaivJyoZ=gnMu-YY7AcnBwCWtD74DqPuYAASxTxA@mail.gmail.com>
Date: Mon, 5 Sep 2011 17:49:27 +0900
X-Google-Sender-Auth: 5JQ3kK1nvdTw3iZsdKDCfGGoNFA
Message-ID: <CAH9JG2W+wEfpL6baQmvigcH9LRn6p0wTszK+urPKxpNfHsjUCQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2] support ioctl for tunable user request
From: Kyungmin Park <kmpark@infradead.org>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Jaehoon Chung <jh80.chung@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Lin Ming <lxy@ss.pku.edu.cn>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

Any comments on tunable user request concept for flash based storage?

Thank you,
Kyungmin Park

On Tue, Aug 30, 2011 at 12:17 AM, Lin Ming <lxy@ss.pku.edu.cn> wrote:
> On Mon, Aug 29, 2011 at 10:01 PM, Kyungmin Park <kmpark@infradead.org> wrote:
>> On Mon, Aug 29, 2011 at 7:11 PM, Jaehoon Chung <jh80.chung@samsung.com> wrote:
>>> Hi
>>>
>>> Lin Ming wrote:
>>>> On Mon, Aug 29, 2011 at 4:15 PM, Jaehoon Chung <jh80.chung@samsung.com> wrote:
>>>>> This patch is added the ioctl for tunable user request.
>>>>
>>>> Hi,
>>>>
>>>> What's the use case for this new ioctl?
>>
>> The below is the just mmc example.
>>
>> The main reason is that there's no way to know system or I/O idle, so
>> user provides the hint. Using user based I/O, device can TUNE the
>> device itself. In case of MMC, background operation can be used.
>>
>> and another difference from other user request, it's just trigger the
>> device tune request, no need to wait the request is done.
>
> OK.
>
> After read the previous patch at:
> http://marc.info/?l=linux-mmc&m=131407402925988&w=2
>
> I now get better understanding what "tunable user request" mean.
>
> Thanks.
>
>>
>> Thank you,
>> Kyungmin Park
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
