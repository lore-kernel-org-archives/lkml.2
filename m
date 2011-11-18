Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933Ab1KRCFU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 21:05:20 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:34216 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755565Ab1KRCFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 21:05:18 -0500
X-SpamScore: -12
X-BigFish: VS-12(zz936eK1432N98dKzz1202hzz8275bhz2dh2a8h668h839h93fh61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4EC5BE16.9080205@freescale.com>
Date: Fri, 18 Nov 2011 10:08:22 +0800
From: LiuShuo <b35362@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: <dedekind1@gmail.com>
CC: <dwmw2@infradead.org>, <Artem.Bityutskiy@nokia.com>,
        <linux-mtd@lists.infradead.org>, <linuxppc-dev@lists.ozlabs.org>,
        <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <leoli@freescale.com>, <scottwood@freescale.com>,
        Jerry Huang <Chang-Ming.Huang@freescale.com>,
        Tang Yuantian <b29983@freescale.com>
Subject: Re: [PATCH 2/3] mtd/nand : set Nand flash page address to FBAR and
 FPAR correctly
References: <1321349355-1639-1-git-send-email-b35362@freescale.com>	 <1321349355-1639-2-git-send-email-b35362@freescale.com> <1321568016.2272.29.camel@koala>
In-Reply-To: <1321568016.2272.29.camel@koala>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok and I want to add another patch before 3/3.

-LiuShuo
> On Tue, 2011-11-15 at 17:29 +0800, b35362@freescale.com wrote:
>> From: Liu Shuo<b35362@freescale.com>
>>
>> If we use the Nand flash chip whose number of pages in a block is greater
>> than 64(for large page), we must treat the low bit of FBAR as being the
>> high bit of the page address due to the limitation of FCM, it simply uses
>> the low 6-bits (for large page) of the combined block/page address as the
>> FPAR component, rather than considering the actual block size.
> Looks like this patch depends on the previous white-space clean-up patch
> - could you please refactor it (and 3/3 too) and resend?
Ok and I am going to add another new patch before 3/3.

-LiuShuo
> Artem.
>
>


