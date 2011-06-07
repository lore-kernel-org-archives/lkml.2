Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546Ab1FGUdS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 16:33:18 -0400
Received: from ulysses.noc.ntua.gr ([147.102.222.230]:60719 "EHLO
	ulysses.noc.ntua.gr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755441Ab1FGUdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 16:33:16 -0400
Message-ID: <4DEE8AD9.3050508@ece.ntua.gr>
Date: Tue, 07 Jun 2011 23:32:25 +0300
From: Stratos Psomadakis <psomas@ece.ntua.gr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110603 Lightning/1.0b3pre Lanikai/3.1.10
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: linux-kernel@vger.kernel.org,
        Frank Kingswood <frank@kingswood-consulting.co.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: ketchup script and 3.0
References: <4DEDD5F4.1070602@kingswood-consulting.co.uk>	 <1307451186.4204.953.camel@calx>  <4DEE808D.6020405@ece.ntua.gr> <1307477435.4204.968.camel@calx>
In-Reply-To: <1307477435.4204.968.camel@calx>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (ulysses.noc.ntua.gr [147.102.222.230]); Tue, 07 Jun 2011 23:32:27 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2011 11:10 PM, Matt Mackall wrote:
> On Tue, 2011-06-07 at 22:48 +0300, Stratos Psomadakis wrote:
>> On 06/07/2011 03:53 PM, Matt Mackall wrote:
>>> On Tue, 2011-06-07 at 08:40 +0100, Frank Kingswood wrote:
>>>> Hi!
>>>>
>>>> With Linux 3.0 approaching rapidly, is the ketchup script known to work?
>>>> It has this tempting <ver> parameter but I've always passed in "2.6" there.
>>> It's on its third maintainer now and I've already forgotten the name of
>>> the new guy.
>> It's me :P
>>
>> I uploaded the ketchup code at github, and added some code to handle 3.x
>> versions, but I've not tested it very much, so it's still in a separate
>> branch. [1]
>> You can check it out/test it, if you want. If it works without problems,
>> when linux-3.0 gets released, I'll tag a new version of ketchup and
>> notify distro maintainers to upgrade their packages.
> I took a brief glance at your changes. You'll probably want to teach it
> that 2.6.39++ == 3.0 so that people can seamlessly move back and forth
> between the two ranges. This wasn't something that made sense across the
> 2.4/2.6 transition.
>
> Oh, wait, maybe I've spotted the code for this.
>
> Thinking ahead just a bit, it'd be nice if we could just declare in
> advance that 3.9++ == 4.0. If we're going to bump the major number at
> arbitrary points, that's the most obvious one. It's approximately 3
> years out at the current rate which seems like a good pace. Then tools
> like ketchup and other tools that handle these version numbers could
> just do all this once.
>
> Linus?
Yeap, that would be nice, indeed. Otherwise, ketchup code (and other
tools probably) will get uglier and uglier as major numbers advance, and
I made it look ugly already (although this is probably 'thinking way
into the future').

-- 
Stratos Psomadakis
<psomas@ece.ntua.gr>

