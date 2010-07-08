Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756754Ab0GHOCm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 10:02:42 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:62682 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754434Ab0GHOCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 10:02:41 -0400
Message-ID: <4C35DA6C.2060405@metafoo.de>
Date: Thu, 08 Jul 2010 16:02:20 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100329)
MIME-Version: 1.0
To: dedekind1@gmail.com
CC: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
       David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org
Subject: Re: [PATCH v2 17/26] MTD: Nand: Add JZ4740 NAND driver
References: <1276924111-11158-1-git-send-email-lars@metafoo.de>	 <1276924111-11158-18-git-send-email-lars@metafoo.de>	 <1278569214.12733.38.camel@localhost>  <4C35D084.7050605@metafoo.de> <1278595142.20321.26.camel@localhost>
In-Reply-To: <1278595142.20321.26.camel@localhost>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Artem Bityutskiy wrote:
> On Thu, 2010-07-08 at 15:20 +0200, Lars-Peter Clausen wrote:
>> On the other hand I'm wondering where on would put headers for non platform specific
>> drivers?
> 
> If we are talking about MTD, then drivers/mtd ?
> 
No, what I meant was header defining platform data structs and such.
And what I wanted to get at is an answer to why driver header files are put in
different directories while the driver files themselves are all keep in the same
directory. (drivers of the same subsystem that is)

- Lars
