Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752091Ab0IDTYw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 15:24:52 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:50802 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811Ab0IDTYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 15:24:51 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4C829CFF.8080905@s5r6.in-berlin.de>
Date: Sat, 04 Sep 2010 21:24:47 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100627 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Martin Steigerwald <Martin@lichtvoll.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: stable? quality assurance?
References: <201007110918.42120.Martin@lichtvoll.de> <201007111651.42963.Martin@lichtvoll.de> <20100711172252.GA3379@1wt.eu> (sfid-20100711_193037_169001_8F8BE25C) <201009041839.09261.Martin@lichtvoll.de>
In-Reply-To: <201009041839.09261.Martin@lichtvoll.de>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Steigerwald wrote:
> I think main problem is that the current development process does not give 
> time for quality work and bug fixing.

This has little to do with process.

Put simply, the paid developers work on what they are paid for.  The
volunteers work on what they are interested in.

If you feel that too little work is spent on stabilization and bug fixing, pay
someone or take matters into your own hand.  I.e. report bugs and work with
the developers to get the bugs fixed.

The current development process OTOH gives plenty of time for quality work and
bug fixing:

  - There are several stages at which new code can be tested:
    When it lives in subsystem development trees,
    when it has been pulled into the linux-next tree,
    when it has been pulled into Linus' tree.

  - Bug fixes are pulled by Linus almost any time whenever they are ready.
    (Of course, since fixes can and do introduce regressions too, only
    critical fixes are accepted in later -rcs.)

  - New code submissions are pulled by Linus in a fairly reliable cycle
    with reasonable frequency (less than three months).  That way,
    developers know that if their stuff did not quite cut it for
    mainline merge in month N, they know they can try again in month
    N+2 or N+3.  They are not left to guess whether their next chance
    will be in half a year or two years or next week.  Hence, nobody
    needs to panic and rush things when a merge window draws near.
    Plus, the code and the repository are open, so anybody can ship
    features to customers at any time independently of Linus' release
    cycle.  Linux distributors do this all the time.

> But is that a *given* that no one actually has any influence to? Is 
> collecting changes for next kernel like rain that either pours down or not 
> - usually pours down in this case like in August in Germany ;)? Who feeds 
> Linus with new stuff during the merge window? From what I understand of the 
> Linux development process its mainly the subsystem maintainers and Andrew 
> Morton.
> 
> What if those people stop collecting new stuff for Linus except bugfixes 
> about two or three weeks before the next kernel is relased?

Most of the maintainers are responsible enough to put only stuff into
linux-next which belongs there, i.e. tested, release-ready stuff.  Likewise
with submissions to Linus during the merge window.

Only some maintainers do in fact try to submit rushed, untested crap.
Sometimes they get caught red-handed.

The release-ready submissions that come via responsible maintainers still
contain some regressions though.  This is inevitable.  There are less
regressions if there are more enthusiasts who test development trees and
linux-next.  There are less regressions in Linus' releases if there are more
enthusiasts who test -rc kernels.  (And submit good bug reports and work with
the developers on them.)  And vice versa.

Process does not do much to prevent bugs or fix bugs.  People do. :-)

However, you can hardly tell people to implement less features and fix more
bugs if they don't owe you anything.
-- 
Stefan Richter
-=====-==-=- =--= --=--
http://arcgraph.de/sr/
