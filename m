Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890Ab2LDOqK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 09:46:10 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:42958 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753844Ab2LDOqE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 09:46:04 -0500
Message-ID: <50BE0CC3.7060800@ti.com>
Date: Tue, 4 Dec 2012 20:16:27 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Cong Ding <dinggnu@gmail.com>, Benoit Cousson <b-cousson@ti.com>,
        Aneesh V <aneesh@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] memory: of_memory.c: remove unnecessary initialization
References: <1354620448-14317-1-git-send-email-dinggnu@gmail.com> <50BDE224.8000301@ti.com> <CACxGe6viwuyfYm2RBfcj233U6-xmJJTQgu=DUu_11iPAckUzqg@mail.gmail.com>
In-Reply-To: <CACxGe6viwuyfYm2RBfcj233U6-xmJJTQgu=DUu_11iPAckUzqg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 December 2012 07:25 PM, Grant Likely wrote:
> On Tue, Dec 4, 2012 at 11:44 AM, Santosh Shilimkar
> <santosh.shilimkar@ti.com> wrote:
>> On Tuesday 04 December 2012 04:56 PM, Cong Ding wrote:
>>>
>>> the initialization of variable ret is unnecessary, we can remove it while
>>> save
>>> one time "or" operation.
>>>
>>> Signed-off-by: Cong Ding <dinggnu@gmail.com>
>>> ---
>>
>> Looks ok.
>> Acked-by: Santosh Shilimkar<santosh.shilimkar@ti.com>
>>
>
> Thanks for the patch, but I don't think it matters enough to apply it.
> The existing code isn't wrong.
>
The patch was removing an additional operation and hence i didn't
contest it. I agree with your comment though.

Regards
Santosh


