Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815Ab1CKWwv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 17:52:51 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50607 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129Ab1CKWwu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 17:52:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=acBYQ35ks1xlSNn4XbXD25QE12T30/GepSMh3U7egDaocWy/Ds9H0mZ4HvVvMVe0gZ
         xxIhBVJPZSdVhxFQ536eHn3stGhjEM8/dJImD3Mws4xUEGJLRHenUKI6iVeUXk79Vyxk
         pS6jElKYcfybmVf5TcbMcoxXMuwJi6ZYRkznE=
MIME-Version: 1.0
In-Reply-To: <1299112955.6974.155.camel@vkoul-udesk3>
References: <1298975579-1594-1-git-send-email-per.forlin@stericsson.com>
	<1299112955.6974.155.camel@vkoul-udesk3>
Date: Fri, 11 Mar 2011 14:52:49 -0800
X-Google-Sender-Auth: p_TmZktVDAn-dEPSdrQh3eO5sfY
Message-ID: <AANLkTinPHzHBGNtOmV_Ze9whbN8zNN0+Z0oge-DwFCbu@mail.gmail.com>
Subject: Re: [PATCH] ste_dma40: assign device_prep_dma_sg for dma_memcpy
From: Dan Williams <dan.j.williams@intel.com>
To: Per Forlin <per.forlin@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>
Cc: Per Forlin <per.forlin@stericsson.com>, linux-kernel@vger.kernel.org,
        "Koul, Vinod" <vinod.koul@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 2, 2011 at 4:42 PM, Koul, Vinod <vinod.koul@intel.com> wrote:
> On Tue, 2011-03-01 at 11:32 +0100, Per Forlin wrote:
>> From: Per Forlin <per.forlin@linaro.org>
>>
>> Signed-off-by: Per Forlin <per.forlin@linaro.org>
>> Acked-by: Linus Walleij <linus.walleij@linaro.org>
>> ---
>>  drivers/dma/ste_dma40.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
>> index 6e1d46a..1dd8ea3 100644
>> --- a/drivers/dma/ste_dma40.c
>> +++ b/drivers/dma/ste_dma40.c
>> @@ -2496,7 +2496,7 @@ static int __init d40_dmaengine_init(struct d40_base *base,
>>       base->dma_memcpy.device_alloc_chan_resources = d40_alloc_chan_resources;
>>       base->dma_memcpy.device_free_chan_resources = d40_free_chan_resources;
>>       base->dma_memcpy.device_prep_dma_memcpy = d40_prep_memcpy;
>> -     base->dma_slave.device_prep_dma_sg = d40_prep_sg;
>> +     base->dma_memcpy.device_prep_dma_sg = d40_prep_sg;
>>       base->dma_memcpy.device_prep_slave_sg = d40_prep_slave_sg;
>>       base->dma_memcpy.device_tx_status = d40_tx_status;
>>       base->dma_memcpy.device_issue_pending = d40_issue_pending;
>
> Please copy the MAINTAINERS, or your patches can get missed...
>
> Applied, Thanks
>

While preparing the 2.6.39 tree this patch no longer applies, it looks
like it is not needed after the pending conversion patches from Rabin.
 Ok to drop, or was this urgent for 2.6.38-final?  If the latter the
changelog did not indicate.

--
Dan
