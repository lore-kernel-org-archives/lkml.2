Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752358Ab1IUHLg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 03:11:36 -0400
Received: from rs35.luxsci.com ([66.216.127.90]:50585 "EHLO rs35.luxsci.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750873Ab1IUHLf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 03:11:35 -0400
Message-ID: <4E798E16.6060308@firmworks.com>
Date: Tue, 20 Sep 2011 21:11:18 -1000
From: Mitch Bradley <wmb@firmworks.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0.2) Gecko/20110902 Thunderbird/6.0.2
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: grant.likely@secretlab.ca, dave.martin@linaro.org, linux@arm.linux.org.uk,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        rob.herring@calxeda.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/3] GIC OF bindings
References: <20110920.224910.1996429830782124690.davem@davemloft.net> <CACxGe6t7Mdr+w+aGFPM2-FEAQaYHuG8Za9dybLgMo-5-whLyNQ@mail.gmail.com> <4E796EE4.6070704@firmworks.com> <20110921.012158.2252182592946972727.davem@davemloft.net>
In-Reply-To: <20110921.012158.2252182592946972727.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/20/2011 7:21 PM, David Miller wrote:
> From: Mitch Bradley<wmb@firmworks.com>
> Date: Tue, 20 Sep 2011 18:58:12 -1000
>
>> interrupt-parent has been part of the interrupt mapping spec from the
>> inception of same.
>>
>> http://www.openfirmware.info/docs/rec.intmap.d09.pdf
>
> Thanks for the link.
>
> In my vast collection of Sun OF dumps, I cannot find a single instance
> where they've made use of this property, which is why I've never seen
> it before.

I can't say I'm surprised at that.  Sun hardware tends to be rather more 
hierarchical than is the norm in, for example, the PC space.  This 
particular document came into being during the CHRP era, when IBM and 
Apple were trying to glue a Macintosh legacy I/O system onto the side of 
a PC legacy I/O system.  The result was not pretty.

Sun had at least the semblance of a coherent architectural design and 
review process.
