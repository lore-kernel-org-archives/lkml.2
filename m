Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932134Ab1DHDjI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 23:39:08 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:59735 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757453Ab1DHDjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 23:39:07 -0400
Message-ID: <4D9E834E.2030705@ahsoftware.de>
Date: Fri, 08 Apr 2011 05:38:54 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.38.b3pre.fc13 Lightning/1.0b3pre Thunderbird/3.1.9
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Nico Erfurth <ne@erfurth.eu>, Eric Cooper <ecc@cmu.edu>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Nicolas Pitre <nico@fluxnic.net>
Subject: Re: [PATCH 0/2] ARM: Unify setup for Marvell SheevaPlugs and	Seagate
 DockStars
References: <1302122121-3652-1-git-send-email-holler@ahsoftware.de> <4D9CEE24.1080501@erfurth.eu> <4D9D81ED.7090809@ahsoftware.de> <4D9D85E4.2040606@erfurth.eu> <4D9D8762.3080207@ahsoftware.de> <20110407173912.GA17049@n2100.arm.linux.org.uk>
In-Reply-To: <20110407173912.GA17049@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 07.04.2011 19:39, schrieb Russell King - ARM Linux:

> We have an established API and convention in the kernel which you claim
> is "from outerspace".  It's not "from outerspace" but a designed API to
> allow platforms to live together in the same kernel image.  So I find
> your arguments totally unreasonable.

I've claimed that the specific machine ID is from outerspace not the 
API. This one (ID) got invented just because of a different usage of two 
GPIOs (and not even by the manufacturerer). And I still think using the 
(fixed) memory size here is totally reasonable. There is nothing else to 
differentiate these HWs, it's extremely unlikely that this difference 
will get proved wrong, and if that would really happen, than one could 
still add some code to fix this specific problem. _Always_ dealing with 
"what happens when" is (imho) fruitless and no solution or API can deal 
with everything.

> I fully support Nicolas in rejecting your patches outright on this point
> alone.

Which I fully understand. And I wouldn't have started to defend me, if 
that would have happened in a more civil language.

But because I don't want to get involved in more discussions with people 
who are missing the needed manners (at least how I learned them) to talk 
with other people without offending them (not you), I better try to stay 
away posting patches.

Maybe I'm getting too old and lacking the needed enthusiasm needed to 
discuss such stuff (and with everyone who thinks he must enter this 
discussion too, again, not you). ;)

I wish you all a nice day,

Alexander
