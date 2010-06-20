Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755064Ab0FTOcM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 10:32:12 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:51363 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754725Ab0FTOcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 10:32:09 -0400
Message-ID: <4C1E263E.1000903@metafoo.de>
Date: Sun, 20 Jun 2010 16:31:26 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100329)
MIME-Version: 1.0
To: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
CC: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org, Graham Gower <graham.gower@gmail.com>
Subject: Re: [PATCH v2 00/26] Add support for the Ingenic JZ4740	System-on-a-Chip
References: <1276924111-11158-1-git-send-email-lars@metafoo.de> <20100620092610.GA4950@alpha.franken.de>
In-Reply-To: <20100620092610.GA4950@alpha.franken.de>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Bogendoerfer wrote:
> On Sat, Jun 19, 2010 at 07:08:05AM +0200, Lars-Peter Clausen wrote:
>   
>> This patch series adds support for the Ingenic JZ4740 System-on-a-Chip.
>>     
>
> great stuff. I have a JZ4730 based netbook, for which I started magling
> the provided sources quite some time ago, but I didn't reach the
> point of submitting patches... there are a lot of common stuff between
> JZ4730 and JZ4740 so IMHO it would be a good thing not to nail
> everthing to JZ4740 namewise. It might also a good idea to select
> something like arch/mips/jzrisc as base directory, put the
> factored out code there and add JZ4730/JZ4740 in either seperate
> files or directories.
>
> Thomas.
>   
Hi

Graham Gower started working on JZ4730 support based on this series some
time ago, but had to put a hold on it because he was busy with other
things. You both should probably get in contact.

There are some parts on the JZ4730 which are similar those on the
JZ4740, others are different. So to put support for common parts into a
shared source directory is the right approach. But I think this is
something that can be done when somebody actually steps forward to
implement support for a different JZ47xx SoC. Luckily the code is not
set into stone and can be re-factored or renamed once it is required or
makes sense to do.
Another issue with naming is that while a component might be similar in
JZ4730 and JZ4740 it might be completely different in a different JZ47xx
SoC. So naming a driver 'jz47xx_driver' instead of 'jz4740_driver' wont
work either.

- Lars

