Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252Ab2KUQS5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 11:18:57 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:52107 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755005Ab2KUQS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 11:18:56 -0500
Message-ID: <50ACFEBF.4070906@ahsoftware.de>
Date: Wed, 21 Nov 2012 17:18:07 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20121002 Thunderbird/15.0.1
MIME-Version: 1.0
To: richard -rw- weinberger <richard.weinberger@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: memtest: make it a bit faster
References: <1352466758-4596-1-git-send-email-holler@ahsoftware.de> <CAFLxGvzKJBA7VtzvafBry874GCiwVVWxtcktdQ=7BcVT3K2E_A@mail.gmail.com> <509D12DF.9000506@ahsoftware.de>
In-Reply-To: <509D12DF.9000506@ahsoftware.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Am 09.11.2012 15:27, schrieb Alexander Holler:
> Am 09.11.2012 15:21, schrieb richard -rw- weinberger:
>> On Fri, Nov 9, 2012 at 2:12 PM, Alexander Holler <holler@ahsoftware.de> wrote:
>>> While implementing the same functionality for arm, I've noticed that
>>> memtest does an unnecessary round to zero the memory. Just reversing the
>>> order so that the last round writes 0s spares that round.
>>>
>>> While there, I've also changed the message if bad memory is found from
>>> informational to emergency.
>>>
>>> And last I've removed some warnings from checkpatch.
>>
>> Please send these as additional patch.
> 
> Than it might be better to wait for an answer from some ARM-people.
> 
> Maybe it will make sense to move the whole file to mm/ or similar where
> I could be used and modified for usage by ARM too.

As I don't know if version for ARM (or the move) will ever happen, I've
now made 2 patches as requested. They will follow.

Regards,

Alexander
