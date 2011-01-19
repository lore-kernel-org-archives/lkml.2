Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686Ab1ASPQv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 10:16:51 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:38877 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754214Ab1ASPQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 10:16:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=cc:message-id:from:to:in-reply-to:content-type
         :content-transfer-encoding:mime-version:subject:date:references
         :x-mailer;
        b=X8tHSHhXb1PEcQvZg8nDu03d83/f0Hp4QDT5rMONsH02V5D7pPChxR2FcbSq2AygCI
         OU8Lb8Al+W4smxGOXgZq45DnDy9Sn9vPaAagsQIoC6qBWj13yh/stKq6rRdUwcxMYDbW
         wKdVkokSkqzJxxp5FbihiJk7/squk0i/Y3fCA=
Cc: dan.j.williams@intel.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-usb@vger.kernel.org
Message-Id: <FD016761-9581-4730-BC79-CBEFEB9ED3EC@gmail.com>
From: Justin Mattock <justinmattock@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
In-Reply-To: <alpine.LNX.2.00.1101191537280.26685@pobox.suse.cz>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v936)
Subject: Re: [PATCH 1/7] dma/shdma.c Typo change desciptor to descriptor.
Date: Wed, 19 Jan 2011 07:16:43 -0800
References: <1293817097-7945-1-git-send-email-justinmattock@gmail.com> <alpine.LNX.2.00.1101191537280.26685@pobox.suse.cz>
X-Mailer: Apple Mail (2.936)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 19, 2011, at 6:38 AM, Jiri Kosina wrote:

> On Fri, 31 Dec 2010, Justin P. Mattock wrote:
>
>> Below is a patch, that changes a typo from "desciptor" to  
>> "descriptor".
>> Let me know if I missed anything.
>>
>> Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
>>
>> ---
>> drivers/dma/shdma.c |    2 +-
>> 1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/dma/shdma.c b/drivers/dma/shdma.c
>> index 85ffd5e..72d25d9 100644
>> --- a/drivers/dma/shdma.c
>> +++ b/drivers/dma/shdma.c
>> @@ -740,7 +740,7 @@ static void sh_chan_xfer_ld_queue(struct  
>> sh_dmae_chan *sh_chan)
>> 		return;
>> 	}
>>
>> -	/* Find the first not transferred desciptor */
>> +	/* Find the first not transferred descriptor */
>> 	list_for_each_entry(desc, &sh_chan->ld_queue, node)
>> 		if (desc->mark == DESC_SUBMITTED) {
>> 			dev_dbg(sh_chan->dev, "Queue #%d to %d: %u@%x -> %x\n",
>
> I have folded the whole series into one patch and applied, thanks.
>
> -- 
> Jiri Kosina
> SUSE Labs, Novell Inc.



alright... I think there was one that needed adjusting, but given the  
situation Im in I wont be able to get to that
until other things in my life get sorted out.. Thanks for taking these

Justin P. Mattock
