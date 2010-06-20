Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280Ab0FTQet (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 12:34:49 -0400
Received: from elvis.franken.de ([193.175.24.41]:38063 "EHLO elvis.franken.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754574Ab0FTQeq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 12:34:46 -0400
Date: Sun, 20 Jun 2010 18:34:37 +0200
From: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org, Graham Gower <graham.gower@gmail.com>
Subject: Re: [PATCH v2 00/26] Add support for the Ingenic JZ4740
	System-on-a-Chip
Message-ID: <20100620163437.GA8329@alpha.franken.de>
References: <1276924111-11158-1-git-send-email-lars@metafoo.de> <20100620092610.GA4950@alpha.franken.de> <4C1E263E.1000903@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C1E263E.1000903@metafoo.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 20, 2010 at 04:31:26PM +0200, Lars-Peter Clausen wrote:
> Another issue with naming is that while a component might be similar in
> JZ4730 and JZ4740 it might be completely different in a different JZ47xx
> SoC. So naming a driver 'jz47xx_driver' instead of 'jz4740_driver' wont
> work either.

so ? call it xx for the common part an exact number for special part.
It might be just jugglin with pieces, but getting it better in the first
run is always a plus.

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessary a
good idea.                                                [ RFC1925, 2.3 ]
