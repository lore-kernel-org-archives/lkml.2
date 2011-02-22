Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752263Ab1BVNWM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 08:22:12 -0500
Received: from compulab.co.il ([67.18.134.219]:34094 "EHLO compulab.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751170Ab1BVNWL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 08:22:11 -0500
Message-ID: <4D63B87D.8040107@compulab.co.il>
Date: Tue, 22 Feb 2011 15:22:05 +0200
From: Igor Grinberg <grinberg@compulab.co.il>
Organization: CompuLab Ltd.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en; rv:1.9.2.13) Gecko/20101211 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: axel.lin@gmail.com
CC: linux-kernel@vger.kernel.org, Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: pxa: support 806MHz operating points for PXA31x
 processors A2 stepping
References: <1297786849.2596.13.camel@phoenix> <4D5AB09C.9000106@compulab.co.il> <AANLkTino2vLisNgKeyXppuHwDyhLMMAcOOZjA0hgmkj6@mail.gmail.com> <4D637557.2070707@compulab.co.il> <AANLkTikTHnz+7C-QmXaHwFE0a+pw7U-t2JP11a0qdoyU@mail.gmail.com>
In-Reply-To: <AANLkTikTHnz+7C-QmXaHwFE0a+pw7U-t2JP11a0qdoyU@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-ACL-Warn: {
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - compulab.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/11 12:38, Axel Lin wrote:

> 2011/2/22 Igor Grinberg <grinberg@compulab.co.il>:
>> Another thing (which could be related to the patch) is the package marking.
>> We have PXA3xx SoCs marked A2 stepping, but C624, which means that the
>> highest running frequency should not exceed 624MHz.
> This means not all PXA310 A2 stepping supports 806Mhz.
> Can we differentiate the Cxxx option in software?

Some time ago I spoke with our local Marvell representative... and he said that this
information cannot be retrieved by software.

So this makes me think, that we may be need an option for the platform data
passed from the board (assuming that board should know what SoC is installed).

Or a kernel command line parameter... something much like Eric proposed:
http://www.spinics.net/lists/arm-kernel/msg92900.html

>> What is your PXA3xx A2 marking in respect to Cxxx option?
> Mine is 88AP310-A2-BGK2C806.

nice! :)

-- 
Regards,
Igor.

