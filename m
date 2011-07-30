Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675Ab1G3TD5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 15:03:57 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:63335 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572Ab1G3TDu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 15:03:50 -0400
MIME-Version: 1.0
In-Reply-To: <CAPXgP13=_UoOZnwBMordFxiMiyfu+nF685+qk01zoy4jDrv=Pw@mail.gmail.com>
References: <1311681033.1325.4.camel@mop> <20110728101755.GH2622@htj.dyndns.org>
 <CAPXgP13=_UoOZnwBMordFxiMiyfu+nF685+qk01zoy4jDrv=Pw@mail.gmail.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Sat, 30 Jul 2011 21:03:30 +0200
Message-ID: <CAPXgP113jUZnUEH9tWwzgY37wwfQebPnYbVmUpJx9Mfu=MRJ6A@mail.gmail.com>
Subject: Re: [PATCH] loop: add management interface for on-demand device allocation
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <jaxboe@fusionio.com>, Karel Zak <kzak@redhat.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 28, 2011 at 13:18, Kay Sievers <kay.sievers@vrfy.org> wrote:
> On Thu, Jul 28, 2011 at 12:17, Tejun Heo <tj@kernel.org> wrote:
>> On Tue, Jul 26, 2011 at 01:50:30PM +0200, Kay Sievers wrote:
>>> From: Kay Sievers <kay.sievers@vrfy.org>
>>> Subject: loop: add management interface for on-demand device allocation
>>>
>>> Loop devices today have a fixed pre-allocated number of usually 8.
>>> The number can only be changed at init time. To find a free device
>>> to use, /dev/loop%i needs to be scanned and all devices need to be
>>> opened.
>>
>> It generally looks good to me but I really hope it were split into
>> multiple patches.  I think it's a bit too big and doing too many
>> different things.  Can you please split it up?
>
> Hmm, split into what? Like splitting the loop-control stuff off? The
> rest can't really be split I guess, because all the linked lists need
> to be converted to idr at once.

Split it into 3 pieces, which I'll send now.

Thanks,
Kay
