Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757345Ab0GHOTP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 10:19:15 -0400
Received: from smtp.nokia.com ([192.100.105.134]:43240 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754512Ab0GHOTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 10:19:14 -0400
Subject: Re: [PATCH v2 17/26] MTD: Nand: Add JZ4740 NAND driver
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
       David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org
In-Reply-To: <4C35DA6C.2060405@metafoo.de>
References: <1276924111-11158-1-git-send-email-lars@metafoo.de>
	 <1276924111-11158-18-git-send-email-lars@metafoo.de>
	 <1278569214.12733.38.camel@localhost>  <4C35D084.7050605@metafoo.de>
	 <1278595142.20321.26.camel@localhost>  <4C35DA6C.2060405@metafoo.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 08 Jul 2010 17:14:57 +0300
Message-ID: <1278598497.20321.29.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-1.fc13) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 08 Jul 2010 14:18:52.0419 (UTC) FILETIME=[7DCE1D30:01CB1EA8]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-08 at 16:02 +0200, Lars-Peter Clausen wrote:
> Artem Bityutskiy wrote:
> > On Thu, 2010-07-08 at 15:20 +0200, Lars-Peter Clausen wrote:
> >> On the other hand I'm wondering where on would put headers for non platform specific
> >> drivers?
> > 
> > If we are talking about MTD, then drivers/mtd ?
> > 
> No, what I meant was header defining platform data structs and such.
> And what I wanted to get at is an answer to why driver header files are put in
> different directories while the driver files themselves are all keep in the same
> directory. (drivers of the same subsystem that is)

To be frank I do not know, I did not look at the whole picture, just at
the MTD part :-)

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

