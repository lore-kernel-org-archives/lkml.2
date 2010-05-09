Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127Ab0EIImD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 04:42:03 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:57444 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722Ab0EIImA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 04:42:00 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4BE67539.8040805@s5r6.in-berlin.de>
Date: Sun, 09 May 2010 10:41:29 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100415 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: florian@mickler.org, Andrew Morton <akpm@linux-foundation.org>,
       Stephen Hemminger <shemminger@vyatta.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC] get_maintainer.pl: only list maintainers by default
References: <1273354364-6016-1-git-send-email-florian@mickler.org>	 <1273354778-6129-1-git-send-email-florian@mickler.org>	 <1273358674.704.77.camel@Joe-Laptop.home>	 <4BE5F286.1020503@s5r6.in-berlin.de>	 <1273362666.704.104.camel@Joe-Laptop.home>	 <4BE60045.3040600@s5r6.in-berlin.de> <1273366633.704.109.camel@Joe-Laptop.home> <4BE66FE1.3010608@s5r6.in-berlin.de>
In-Reply-To: <4BE66FE1.3010608@s5r6.in-berlin.de>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> Joe Perches wrote:
>> Supporting stats please.
...
>   $ git log drivers/firewire/ drivers/ieee1394/ |
>     grep -e "Tested-by: " -e "Reported-by: "
> lists 32 people of whom
>   - 0 need to be/ should be included in the address list of a patch
>     submission,
>   - 2 or 3 were active in firewire subsystem development (but not
>     anymore) but were perfectly fine to reach via MAINTAINERS' L: entry

PS:  And when they were still active, they also clearly showed up as
patch authors.

>   - 3 or 2 are still somewhat involved in firewire subsystem
>     development, but only in special application domains, and they are
>     reached via MAINTAINERS' L: entry

Think of mailinglists as a pull model to reach potential reviewers,
whereas personal mail constitute a push model which must be used with a
lot of care --- i.e. when you as a submitter _know_ that these people
are going to want to be directly informed about the patch submission.
-- 
Stefan Richter
-=====-==-=- -=-= -=--=
http://arcgraph.de/sr/
