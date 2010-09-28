Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759634Ab0I1Hgw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 03:36:52 -0400
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119]:35466 "EHLO
	eu1sys200aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753121Ab0I1Hgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 03:36:51 -0400
Message-ID: <4CA1959F.8050806@stericsson.com>
Date: Tue, 28 Sep 2010 09:13:35 +0200
From: =?ISO-8859-1?Q?Per_F=F6rlin?= <per.friden@stericsson.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: "Ira W. Snyder" <iws@ovro.caltech.edu>
Cc: Linus Walleij <linus.ml.walleij@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dan Williams <dan.j.williams@intel.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH RFCv2 1/2] dmaengine: add support for scatterlist to scatterlist
 transfers
References: <1285370032-16937-1-git-send-email-iws@ovro.caltech.edu> <1285370032-16937-2-git-send-email-iws@ovro.caltech.edu> <AANLkTimzdEhAZ=oXbbB3Ge5=YY7OXq3fjaRH4roPNB-k@mail.gmail.com> <20100927172356.GA805@ovro.caltech.edu>
In-Reply-To: <20100927172356.GA805@ovro.caltech.edu>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, Sep 27, 2010 at 05:23:34PM +0200, Linus Walleij wrote:
>> 2010/9/25 Ira W. Snyder <iws@ovro.caltech.edu>:
>>
>>> This adds support for scatterlist to scatterlist DMA transfers.
>>
>> This is a good idea, we have a local function to do this in DMA40 already,
>> stedma40_memcpy_sg().
>>
> 
> I think that having two devices that want to implement this
> functionality as part of the DMAEngine API is a good argument for making
> it available as part of the core API. I think it would be good to add
> this to struct dma_device, and add a capability (DMA_SG?) for it as
> well.
> 
> I have looked at the stedma40_memcpy_sg() function, and I think we would
> want to extend it slightly for the generic API. Is there any good reason
> to prohibit scatterlists with different numbers of elements?
No

/Per
