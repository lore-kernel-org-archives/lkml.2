Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061Ab1DGMOQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 08:14:16 -0400
Received: from smtp.nokia.com ([147.243.1.48]:25396 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755832Ab1DGMOO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 08:14:14 -0400
Subject: Re: MTD: atmel_nand.c: bug in the DMA support
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
To: ext Igor Plyatov <plyatov@gmail.com>
Cc: Hong Xu <hong.xu@atmel.com>, linux-kernel@vger.kernel.org,
        David Woodhouse <David.Woodhouse@intel.com>,
        Andreas =?ISO-8859-1?Q?Bie=DFmann?= <biessmann@corscience.de>,
        Ryan Mallon <ryan@bluewatersys.com>
In-Reply-To: <4D9DA8EC.7070604@gmail.com>
References: <4D9DA8EC.7070604@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Nokia
Date: Thu, 07 Apr 2011 15:11:17 +0300
Message-ID: <1302178277.2407.36.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 8bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-07 at 16:07 +0400, ext Igor Plyatov wrote:
> Dear Hong,
> 
> My machine is a Stamp9G20 module, from Taskit company, based on the 
> AT91SAM9G20 chip.
> More details is here 
> http://armbedded.eu/documentation/pdf/stamp9g20technicalreference.pdf
> 
> I have try to use Linux-2.6.39-rc2 (from Linus GIT) and discovered a bug 
> in the atmel_nand.c after yours patch.
> 
> With the Linux-2.6.38.2 everything operate fine and here is a console 
> output shown:

There were some fixes which are scheduled to be merged soon. Try 

git://git.infradead.org/mtd-2.6.git master

which contains the fixes. This is the web view of that repository:
http://git.infradead.org/mtd-2.6.git

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

