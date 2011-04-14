Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758955Ab1DNOsV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 10:48:21 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:46953 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758816Ab1DNOsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 10:48:20 -0400
Message-ID: <4DA7094D.9070002@metafoo.de>
Date: Thu, 14 Apr 2011 16:48:45 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110307 Icedove/3.0.11
MIME-Version: 1.0
To: dedekind1@gmail.com
CC: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Holger Freyther <zecke@openmoko.org>
Subject: Re: [PATCH 1/2] MTD: s3c2410_nand: Add option to disable hw ECC at
 runtime
References: <1302637672-25339-1-git-send-email-lars@metafoo.de> <1302782911.2796.21.camel@localhost>
In-Reply-To: <1302782911.2796.21.camel@localhost>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14/2011 02:08 PM, Artem Bityutskiy wrote:
> On Tue, 2011-04-12 at 21:47 +0200, Lars-Peter Clausen wrote:
>> From: Holger Freyther <zecke@openmoko.org>
>>
>> This patch adds a flag to the s3c2410_nand platform data, which configures
>> whether hardware ECC is used.
>>
>> Currently it is only possible to decide whether hw ECC should be used or not at
>> compile time through a config option. But if you want to build a kernel which
>> runs on multiple devices you might have a configuration where some devices
>> require hw ECC and some devices which want software ECC.
>>
>> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> 
> Extending platform data is kind of vetoed in arm tree, I do not think
> the MTD tree can take these changes.
> 
That is not my understanding of the situation. But what do you suggest as an
alternative for fixing this issue?

- Lars
