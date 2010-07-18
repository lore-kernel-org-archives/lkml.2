Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756763Ab0GRRCp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jul 2010 13:02:45 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:41913 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756669Ab0GRRCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jul 2010 13:02:44 -0400
Message-ID: <4C43338E.7030706@metafoo.de>
Date: Sun, 18 Jul 2010 19:02:06 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100329)
MIME-Version: 1.0
To: dedekind1@gmail.com
CC: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        linux-mtd@lists.infradead.org
Subject: Re: [PATCH v3] MTD: Nand: Add JZ4740 NAND driver
References: <1276924111-11158-18-git-send-email-lars@metafoo.de>         <1279368929-21193-1-git-send-email-lars@metafoo.de> <1279472048.16247.63.camel@localhost.localdomain>
In-Reply-To: <1279472048.16247.63.camel@localhost.localdomain>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Artem Bityutskiy wrote:
> On Sat, 2010-07-17 at 14:15 +0200, Lars-Peter Clausen wrote:
>> This patch adds support for the NAND controller on JZ4740 SoCs.
>>
>> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
>> Cc: David Woodhouse <dwmw2@infradead.org>
>> Cc: linux-mtd@lists.infradead.org
>>
> 
> Do you expect this patch to go in via the MTD tree? I guess it might be
> better if it was MIPS tree?

Hi

Yes, letting it go through the MIPS tree is the plan.

- Lars
