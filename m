Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026Ab0IEKuk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 06:50:40 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64974 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940Ab0IEKui convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 06:50:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=m5+SpCu+X+kXBU28Bn072J+e+N3GFQlEWiHUnNcul9/IP2H9tH/G8O0eX8jZMwOHyS
         7BHcT7C+fTI6cu55RLc8j4Nrk01xN5rF84AzKMxjcaw6souK+O8X9/6NrQlP9MJoTeL1
         RSZXz9Wc6fW6SGaFO/XaJ0Th8U9BUtZVsfFPY=
MIME-Version: 1.0
In-Reply-To: <20100902055907.GA3287@riccoc20.at.omicron.at>
References: <20100819174426O.fujita.tomonori@lab.ntt.co.jp>
 <m3sk1yzkjw.fsf@intrepid.localdomain> <20100901085738.GJ8142@n2100.arm.linux.org.uk>
 <20100902114937X.fujita.tomonori@lab.ntt.co.jp> <20100902055907.GA3287@riccoc20.at.omicron.at>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Sun, 5 Sep 2010 18:50:17 +0800
Message-ID: <AANLkTi=TfmFPSfw3iYUMzxdsCLC7keJxMbb7vZvQHoiO@mail.gmail.com>
Subject: Re: [PATCH] arm: fix pci_set_consistent_dma_mask for dmabounce devices
To: Richard Cochran <richardcochran@gmail.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux@arm.linux.org.uk,
        khc@pm.waw.pl, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 2, 2010 at 1:59 PM, Richard Cochran
<richardcochran@gmail.com> wrote:
> On Thu, Sep 02, 2010 at 11:50:33AM +0900, FUJITA Tomonori wrote:
>> btw, I can't compile ARCH_IXP4XX without the following patch:
>>
>> http://www.spinics.net/lists/arm-kernel/msg95933.html
>
> I have the same problem. Compilation of IXP4xx was broken by
>
>    commit 4fa5518c65df7a2c4b6c58061ac53d0b01228042
>    Author: Eric Miao <eric.y.miao@gmail.com>
>    Date:   Sat Jun 5 15:16:17 2010 +0800
>
>    [ARM] pxa: remove now unnecessary dma_needs_bounce()
>
> What is the correct way to do fix this? Is the above patch the
> solution, or is dma_needs_bounce() perhaps also unnecessary for ixp?
>

My bad to break this. If there is no quick proper fix, I'd prefer this
being reverted first.
