Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014Ab1H2PRa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 11:17:30 -0400
Received: from mail.ss.pku.edu.cn ([211.101.48.138]:38612 "EHLO
	mail.ss.pku.edu.cn" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753654Ab1H2PR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 11:17:29 -0400
MIME-Version: 1.0
In-Reply-To: <CAH9JG2Xfh7JcdBdaCUuD9wFyNPTXg_0JbvVZkEWK5jT2=W3ybA@mail.gmail.com>
References: <4E5B4AAF.2040101@samsung.com>
	<CAF1ivSaveqVs8dGF+HZBytJpUpTJPysUox=qmHDTFQvqBmm+rw@mail.gmail.com>
	<4E5B65C6.6070300@samsung.com>
	<CAH9JG2Xfh7JcdBdaCUuD9wFyNPTXg_0JbvVZkEWK5jT2=W3ybA@mail.gmail.com>
Date: Mon, 29 Aug 2011 23:17:25 +0800
Message-ID: <CAF1ivSZxAuVaivJyoZ=gnMu-YY7AcnBwCWtD74DqPuYAASxTxA@mail.gmail.com>
Subject: Re: [RFC PATCH v2] support ioctl for tunable user request
From: Lin Ming <lxy@ss.pku.edu.cn>
To: Kyungmin Park <kmpark@infradead.org>
Cc: Jaehoon Chung <jh80.chung@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jens Axboe <jaxboe@fusionio.com>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 29, 2011 at 10:01 PM, Kyungmin Park <kmpark@infradead.org> wrote:
> On Mon, Aug 29, 2011 at 7:11 PM, Jaehoon Chung <jh80.chung@samsung.com> wrote:
>> Hi
>>
>> Lin Ming wrote:
>>> On Mon, Aug 29, 2011 at 4:15 PM, Jaehoon Chung <jh80.chung@samsung.com> wrote:
>>>> This patch is added the ioctl for tunable user request.
>>>
>>> Hi,
>>>
>>> What's the use case for this new ioctl?
>
> The below is the just mmc example.
>
> The main reason is that there's no way to know system or I/O idle, so
> user provides the hint. Using user based I/O, device can TUNE the
> device itself. In case of MMC, background operation can be used.
>
> and another difference from other user request, it's just trigger the
> device tune request, no need to wait the request is done.

OK.

After read the previous patch at:
http://marc.info/?l=linux-mmc&m=131407402925988&w=2

I now get better understanding what "tunable user request" mean.

Thanks.

>
> Thank you,
> Kyungmin Park
