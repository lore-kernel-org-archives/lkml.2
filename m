Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113Ab0EIITb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 04:19:31 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:57360 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880Ab0EIIT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 04:19:26 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4BE66FE1.3010608@s5r6.in-berlin.de>
Date: Sun, 09 May 2010 10:18:41 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100415 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: florian@mickler.org, Andrew Morton <akpm@linux-foundation.org>,
       Stephen Hemminger <shemminger@vyatta.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC] get_maintainer.pl: only list maintainers by default
References: <1273354364-6016-1-git-send-email-florian@mickler.org>	 <1273354778-6129-1-git-send-email-florian@mickler.org>	 <1273358674.704.77.camel@Joe-Laptop.home>	 <4BE5F286.1020503@s5r6.in-berlin.de>	 <1273362666.704.104.camel@Joe-Laptop.home>	 <4BE60045.3040600@s5r6.in-berlin.de> <1273366633.704.109.camel@Joe-Laptop.home>
In-Reply-To: <1273366633.704.109.camel@Joe-Laptop.home>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> On Sun, 2010-05-09 at 02:22 +0200, Stefan Richter wrote:
>> But how does this indicate a need to include these addresses into
>> get_maintainer.pl output?  In no way at all.
> 
> Supporting stats please.
> 
> I gave you some that seem to differ from your
> position.

What do want with statistics here?  Look at semantics, not at
quantities.  Look at what this thread started.

You apparently overlooked what I wrote earlier, so I repeat it to be sure:

>>>
$ git log fs/eventpoll.c include/linux/wait.h |grep stefanr
    Reported-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
    Tested-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

Please do not Cc me on subsystems that I do not develop nor maintain.
My personal inbox is full enough and my todo-list growing.
When I have time to look at patches to subsystems that I don't work with
normally, I look into my inbox.lkml.

If you rely on scripts/get_maintainer.pl, then please use it more
carefully or improve the script to produce more qualified Cc lists.

Thanks.
<<<

>>>
Cc'ing a
reporter or tester would only make sense if the patch changes something
that directly affects the reporter's/ tester's setup, e.g. reworks a
provisional fix.
<<<
[which is highly unlikely, and in those special cases get_maintainer.pl
is not where we take that info from]

>>>
  - Reported-by: and Tested-by: signed commits were most likely about
    something radically different from what the new patch submission is
    about.
<<<

But wait, you want stats, you get stats.
  $ git log drivers/firewire/ drivers/ieee1394/ |
    grep -e "Tested-by: " -e "Reported-by: "
lists 32 people of whom
  - 0 need to be/ should be included in the address list of a patch
    submission,
  - 2 or 3 were active in firewire subsystem development (but not
    anymore) but were perfectly fine to reach via MAINTAINERS' L: entry
  - 3 or 2 are still somewhat involved in firewire subsystem
    development, but only in special application domains, and they are
    reached via MAINTAINERS' L: entry

You on the other had found e.g. Ingo among testers signatures.  Could
you show a single source file of which a patch should be Cc'd to Ingo
and get_maintainer.pl finds him only among testers or reporters but no
among the MAINTAINERS M: entries nor among the signed-off-bys?  (Or any
of the other maintainers that you found.)
-- 
Stefan Richter
-=====-==-=- -=-= -=--=
http://arcgraph.de/sr/
