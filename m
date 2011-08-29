Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500Ab1H2KLv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 06:11:51 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:45779 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753387Ab1H2KLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 06:11:44 -0400
X-AuditID: cbfee61a-b7cf1ae00000208e-1b-4e5b65dfd959
Date: Mon, 29 Aug 2011 19:11:18 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
Subject: Re: [RFC PATCH v2] support ioctl for tunable user request
In-reply-to: <CAF1ivSaveqVs8dGF+HZBytJpUpTJPysUox=qmHDTFQvqBmm+rw@mail.gmail.com>
To: Lin Ming <lxy@ss.pku.edu.cn>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jens Axboe <jaxboe@fusionio.com>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <4E5B65C6.6070300@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; ko; rv:1.9.2.4)
 Gecko/20100608 Thunderbird/3.1
References: <4E5B4AAF.2040101@samsung.com>
 <CAF1ivSaveqVs8dGF+HZBytJpUpTJPysUox=qmHDTFQvqBmm+rw@mail.gmail.com>
X-OriginalArrivalTime: 29 Aug 2011 10:12:20.0605 (UTC)
 FILETIME=[23742AD0:01CC6634]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Lin Ming wrote:
> On Mon, Aug 29, 2011 at 4:15 PM, Jaehoon Chung <jh80.chung@samsung.com> wrote:
>> This patch is added the ioctl for tunable user request.
> 
> Hi,
> 
> What's the use case for this new ioctl?
> 
In my case, this ioctl is used the background operation for eMMC.
In eMMC's case, background operation(BKOPS) is supported.
(but that is running with only card notifier, so i added new ioctl for user request)

if we send the BKOPS request, card is notified to need the BKOPS. 
then running background operation. (Then user's responsibility is done)

In future, i think that other block device should be used this ioctl.
(if supported like BKOPS)

Regard,
Jaehoon Chung

