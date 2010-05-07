Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932208Ab0EGTtA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 15:49:00 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:49156 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932193Ab0EGTs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 15:48:58 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4BE46E7D.1040906@s5r6.in-berlin.de>
Date: Fri, 07 May 2010 21:48:13 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100415 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Florian Mickler <florian@mickler.org>
CC: Joe Perches <joe@perches.com>, Andrew Morton <akpm@linux-foundation.org>,
       Stephen Hemminger <shemminger@vyatta.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] get_maintainer.pl: ignore non-maintainer tags
References: <1273179148.1537.145.camel@Joe-Laptop.home> <1273214095-23396-1-git-send-email-florian@mickler.org> <1273214367.1540.21.camel@Joe-Laptop.home> <20100507070218.GA6574@home.mickler.org>
In-Reply-To: <20100507070218.GA6574@home.mickler.org>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Florian Mickler wrote:
> On Thu, May 06, 2010 at 11:39:26PM -0700, Joe Perches wrote:
>> On Fri, 2010-05-07 at 08:34 +0200, florian@mickler.org wrote:
>>> Using --git to determine who to send a patch to, it is not
>>> reasonable to include people that only reported an issue or tested a
>>> patch.
>> I think this is a questionable assumption.
>>
>> People that test or otherwise sign a patch are also good
>> candidates to review new patches.
>>
>> cheers, Joe
> 
> Our views differ then.
> 
> It is unreasonable to assume, that someone who is listed via
> Tested-By: in a random patch is able to review another patch to the same
> file. More likely will he be annoyed, because he see's a patch, dig's
> in and then thinks: "wtf? why were i cc'ed on this. I don't know this
> code. I don't have time for this!"
> 
> Thats just broken.

Indeed.  Three points:

  - Reported-by: and Tested-by: signed commits were most likely about
    something radically different from what the new patch submission is
    about.

  - get_maintainer.pl is supposed to list maintainer addresses.
    Reporters and testers are not maintainers.

  - If a get_maintainer.pl user expects to get not only maintainer
    addresses but also addresses of potential reviewers, then he shall
    use the mailinglist addresses for that.
    People who /want/ to review patches subscribe to that mailinglist
    or register themselves in MAINTAINERS.

Pushing patches to people of whom it is unknown whether they want or can
review the patches may actually be rude.  If it can be avoided that
get_maintainer.pl lists addresses of people who are likely of that
category, then please teach it to.
-- 
Stefan Richter
-=====-==-=- -=-= --===
http://arcgraph.de/sr/
