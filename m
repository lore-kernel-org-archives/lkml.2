Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755695Ab1AaTOz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 14:14:55 -0500
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:55510 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752143Ab1AaTOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 14:14:55 -0500
Message-ID: <4D470A8B.70700@metafoo.de>
Date: Mon, 31 Jan 2011 20:16:27 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101226 Icedove/3.0.11
MIME-Version: 1.0
To: Anton Vorontsov <cbouatmailru@gmail.com>
CC: Grazvydas Ignotas <notasas@gmail.com>,
        Rodolfo Giometti <giometti@linux.it>, linux-kernel@vger.kernel.org,
        =?UTF-8?B?UGFsaSBSb2jDoXI=?= <pali.rohar@gmail.com>
Subject: Re: Fwd: [PATCH] bq27x00_battery: Some fixes
References: <20110131135417.GC3883@oksana.dev.rtsoft.ru> <4D46FC2A.6010402@metafoo.de> <20110131182704.GA13244@oksana.dev.rtsoft.ru>
In-Reply-To: <20110131182704.GA13244@oksana.dev.rtsoft.ru>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2011 07:27 PM, Anton Vorontsov wrote:
> On Mon, Jan 31, 2011 at 07:15:06PM +0100, Lars-Peter Clausen wrote:
>> On 01/31/2011 02:54 PM, Anton Vorontsov wrote:
>>> The same is for this patch.
>>>
>>> Comments, Reviewed-by or Acked-by?
>>>
>>> p.s. FWIW, I already asked Pali to factor out bq27x00_battery_time()
>>>      fix to a separate patch.
>>>
>>
>> Hi
>>
>> I have a larger series pending which adds support for the bq27000 chip and polling to
>> the bq27x00 driver. Since this series does some refactoring of the bq27x00 driver, it
>> might make sense to rebase this (and the other) patch ontop of that series instead of
>> the other way around.
> 
> Pali was first to send out his work, so I think that it would make
> sense to ask you to rebase your work on top. Especially since Pali's
> patches were somewhat reviewed already.

I suspect it to be substantial more work to rebase mine on top of his. That's why I'm
asking for a exception in this case. I would be willing to adjust his patches, so
they can be applied on top of mine.

> 
> I hope Pali will resend the fixed versions quickly enough so
> that I'll apply the patches asap and you'll easily use git
> for rebasing.
> 

git won't help in this case, because my patches basically rewrite the parts changed
by Palis patches. It would be one merge conflict after another, I guess.

> Thanks!
> 

