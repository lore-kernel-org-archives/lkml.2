Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216Ab1IEMko (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 08:40:44 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:60677 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866Ab1IEMkj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 08:40:39 -0400
MIME-Version: 1.0
In-Reply-To: <20110905121840.GA4768@infradead.org>
References: <4E5B4AAF.2040101@samsung.com>
	<CAF1ivSaveqVs8dGF+HZBytJpUpTJPysUox=qmHDTFQvqBmm+rw@mail.gmail.com>
	<4E5B65C6.6070300@samsung.com>
	<CAH9JG2Xfh7JcdBdaCUuD9wFyNPTXg_0JbvVZkEWK5jT2=W3ybA@mail.gmail.com>
	<CAF1ivSZxAuVaivJyoZ=gnMu-YY7AcnBwCWtD74DqPuYAASxTxA@mail.gmail.com>
	<CAH9JG2W+wEfpL6baQmvigcH9LRn6p0wTszK+urPKxpNfHsjUCQ@mail.gmail.com>
	<20110905091540.GA22014@infradead.org>
	<CAH9JG2UevPYDOFycLGbh+zu9CyoDx8N8qnCzMy0Lq2b+06EatA@mail.gmail.com>
	<20110905121840.GA4768@infradead.org>
Date: Mon, 5 Sep 2011 21:40:39 +0900
X-Google-Sender-Auth: j5Wg_5QU_DSZgA_YDkXoExqUHwM
Message-ID: <CAH9JG2U9uWMQYVjyH1HOmefe2mdf79fpR5mkjPW9nj4v2MrcwQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2] support ioctl for tunable user request
From: Kyungmin Park <kmpark@infradead.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <jaxboe@fusionio.com>, Jaehoon Chung <jh80.chung@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Lin Ming <lxy@ss.pku.edu.cn>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 5, 2011 at 9:18 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Mon, Sep 05, 2011 at 08:47:58PM +0900, Kyungmin Park wrote:
>> The concept is similar with DISCARD request except no-wait for request complete
>>
>>  #define REQ_DISCARD            (1 << __REQ_DISCARD)
>> +#define REQ_TUNE               (1 << __REQ_TUNE)
>>
>> As it's hard to detect the idle time at device level, user send the
>> tune request to device when idle.
>
> But what does a "tune" request actually do?  It's an overly generic
> term, but I still can't even think of what it would do to a storage

Yes, tune is generic term, that's reason to send the RFC patch, we
consider the several names, but not found the proper name, if you
suggest the proper name, it can change the proper one.

and you can find the prototype at below URL
http://marc.info/?l=linux-mmc&m=131407402925988&w=2

In case of MMC, it supports the background operation (BKOPS) and these
features can be extended at Universal Flash Storage (UFS) later.

> device, nor why it would be a generic block layer concept.
Do you mean the mmc specific ioctl is proper or other place? in case
of ioctl, it's considered but hope to make it the generic request to
use other storage devices.

Thank you,
Kyungmin Park
