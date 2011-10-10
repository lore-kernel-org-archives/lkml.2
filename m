Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585Ab1JJRcc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 13:32:32 -0400
Received: from mout1.freenet.de ([195.4.92.91]:54047 "EHLO mout1.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753183Ab1JJRcX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 13:32:23 -0400
Message-ID: <4E932BB1.2010008@01019freenet.de>
Date: Mon, 10 Oct 2011 19:30:25 +0200
From: Andreas Hartmann <andihartmann@01019freenet.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110928 Firefox/7.0.1 SeaMonkey/2.4.1
MIME-Version: 1.0
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
CC: Borislav Petkov <bp@amd64.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: AMD 970 chipset support in Linux?
References: <j6ehat$2qd$1@ID-44327.news.uni-berlin.de> <20111004105633.GA2985@gere.osrc.amd.com> <20111010101153.GY2138@amd.com>
In-Reply-To: <20111010101153.GY2138@amd.com>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roedel, Joerg schrieb:
> On Tue, Oct 04, 2011 at 06:56:33AM -0400, Borislav Petkov wrote:
>> On Tue, Oct 04, 2011 at 10:50:32AM +0200, Andreas Hartmann wrote:
>>> Hello!
>>>
>>> I'm wondering, if the new AMD 900 chipsets (970, 990X and 990FX) are
>>> already supported in Linux (since which kernel version?).
>>>
>>> I'm interested because these boards ship with a IOMMU, which I plan to use.
>>
>> Let's ask Jörg.
> 
> If any, only 990FX supports IOMMU (like 890FX does). Note that the BIOS
> also needs to support IOMMU.


Hmmm, according the manual from the mainboard GA-970A-UD3 (Gigabyte),
which uses the AMD 970 chipset, IOMMU is supported (page 43).

Or do you want to say, that linux just supports the IOMMU with the 990FX
chipset?

Could you please tell me, since which kernel this chipset is supported?


Thanks for your answer,
Andreas
