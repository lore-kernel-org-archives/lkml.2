Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004Ab0GLXE2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 19:04:28 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:42404 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753758Ab0GLXE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 19:04:27 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4C3B9F56.5090806@s5r6.in-berlin.de>
Date: Tue, 13 Jul 2010 01:03:50 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100627 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Martin Steigerwald <Martin@lichtvoll.de>
CC: Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org
Subject: Re: stable? quality assurance?
References: <201007110918.42120.Martin@lichtvoll.de> <201007121744.05844.Martin@lichtvoll.de> <20100712173625.GE6953@1wt.eu> (sfid-20100712_202952_849487_F77B8D03) <201007122156.21725.Martin@lichtvoll.de>
In-Reply-To: <201007122156.21725.Martin@lichtvoll.de>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Steigerwald wrote:
> I think I wait for 2.6.34.2 or .3 and then try again. If it then happens 
> again, hopefully in a moment where I have nerve to deal with such bugs, I 
> fire up my second notebook and try to SSH into the machine. If that works I 
> at least could look into dmesg and X.org logs.

netconsole might be required.

...
> Is the Linux kernel development really in balance with feature work and 
> stabilization work? Currently at least from my personal perception it is 
> not. Development goes that fast - can you all cope with that speed? Maybe 
> its just time to *slow it down* a bit?

If those who added the regressions are found out and asked to debug and
fix them, the balance should be corrected and perhaps more precautions
being taken in the future.  Alas, finding the point in history at which
the kernel regressed might take a lot more time than to actually fix it
then.  In that case, maybe give the author of the bug an estimate of the
volunteered hours that were spent on reporting this bug, to put the
repercussions into it into perspective.  OTOH I suspect a lack of
responsibility at the developers is not so much an issue here, more so
that the number of people who take the time for -rc tests (not to
mention linux-next tests) _and_ to file reports is rather low.  Plus, a
good bug report often requires experience or good intuition, besides
patience and rigor.

There were discussions in the past on how more enthusiasts who are
willing and able to test prereleases could be attracted.  But maybe
(just maybe) there are more ways in which the developers themselves
could perform more extensive/ more systematic tests.
-- 
Stefan Richter
-=====-==-=- -=== -==-=
http://arcgraph.de/sr/
