Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756536Ab1IIGnL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 02:43:11 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:60549 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753695Ab1IIGnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 02:43:08 -0400
Subject: Re: linux-next: manual merge of the l2-mtd tree with the at91 tree
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Nico Erfurth <ne@erfurth.eu>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Date: Fri, 09 Sep 2011 09:45:28 +0300
In-Reply-To: <20110909132920.3696fbb6c1b90cded9727d30@canb.auug.org.au>
References: <20110909132920.3696fbb6c1b90cded9727d30@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1315550734.7905.14.camel@sauron>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-09 at 13:29 +1000, Stephen Rothwell wrote:
> Hi Artem,
> 
> Today's linux-next merge of the l2-mtd tree got a conflict in
> arch/arm/mach-at91/board-usb-a9260.c between commit 6939fd49787e ("at91:
> merge board USB-A9260 and USB-A9263 together") from the at91 tree and
> commit 29921652b159 ("mtd: ATMEL, AVR32: inline nand partition table
> access") from the l2-mtd tree.
> 
> The former removed the file modified by the latter, so I did that.

OK, thanks, I guess you'll carry this modification so far, we'll need to
take care of the conflict when merging.

-- 
Best Regards,
Artem Bityutskiy

