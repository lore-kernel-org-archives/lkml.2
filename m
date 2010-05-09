Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641Ab0EIAWn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 May 2010 20:22:43 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:55885 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754328Ab0EIAWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 May 2010 20:22:41 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4BE60045.3040600@s5r6.in-berlin.de>
Date: Sun, 09 May 2010 02:22:29 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100415 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: florian@mickler.org, Andrew Morton <akpm@linux-foundation.org>,
       Stephen Hemminger <shemminger@vyatta.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC] get_maintainer.pl: only list maintainers by default
References: <1273354364-6016-1-git-send-email-florian@mickler.org>	 <1273354778-6129-1-git-send-email-florian@mickler.org>	 <1273358674.704.77.camel@Joe-Laptop.home>	 <4BE5F286.1020503@s5r6.in-berlin.de> <1273362666.704.104.camel@Joe-Laptop.home>
In-Reply-To: <1273362666.704.104.camel@Joe-Laptop.home>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> On Sun, 2010-05-09 at 01:23 +0200, Stefan Richter wrote:
>> Joe Perches wrote:
>> Reported-by and tested-by signatures in the git history commit /are/ in
>> fact random WRT getting a list of handlers/ reviewers of a new patch.
> 
> Supporting stats please.
...
> Look like mostly patch authors and maintainers to me.
> 
> Brian Cavagnolo isn't a patch author, but he's an active tester.

So you looked up signatures across the entire tree, found some people
who appear more often than an average reporter/tester, and one of these
is not a classic developer/maintainer.

But how does this indicate a need to include these addresses into
get_maintainer.pl output?  In no way at all.

To get your patch reviewed, Cc the relevant mailinglists.  To get your
patch into the submission pipeline, Cc the maintainer.

>> It is more likely that reporters and testers cannot or/and do not want to
>> do anything about such a patch.  Such a mailing is called UBE.
> 
> I doubt that's true of even half of the reporters and testers.
> 
> I also doubt such patch emails fit any reasonable definition
> of UBE.

The U, B, and E all describe such mail exactly.
-- 
Stefan Richter
-=====-==-=- -=-= -=--=
http://arcgraph.de/sr/
