Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751857Ab0FHHwJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 03:52:09 -0400
Received: from daytona.panasas.com ([67.152.220.89]:63373 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750743Ab0FHHwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 03:52:07 -0400
Message-ID: <4C0DF6A2.1050608@panasas.com>
Date: Tue, 08 Jun 2010 10:52:02 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Paul Mundt <lethal@linux-sh.org>
CC: David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frans Pop <elendil@planet.nl>, Dirk Hohndel <hohndel@infradead.org>,
       Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH, v2] kbuild: Improve version string logic - two for the
 price of one - No thanks
References: <20091006173508.GA4786@elte.hu> <20091012195733.GA7351@elte.hu> <4C0D29DE.6050602@panasas.com> <alpine.DEB.2.00.1006071242510.30389@chino.kir.corp.google.com> <4C0DDAA6.8080002@panasas.com> <alpine.DEB.2.00.1006072311170.31780@chino.kir.corp.google.com> <20100608063419.GF6376@linux-sh.org> <4C0DE5AC.1090204@panasas.com> <4C0DEE57.1070505@panasas.com> <4C0DEF92.5000601@panasas.com> <20100608073211.GB13191@linux-sh.org>
In-Reply-To: <20100608073211.GB13191@linux-sh.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Jun 2010 07:52:04.0814 (UTC) FILETIME=[7C9A1EE0:01CB06DF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/2010 10:32 AM, Paul Mundt wrote:
> On Tue, Jun 08, 2010 at 10:21:54AM +0300, Boaz Harrosh wrote:
>> On 06/08/2010 10:16 AM, Boaz Harrosh wrote:
>> OK I get it above should be:
>> [my-tree] $ echo "-my_tree" > localversion-my_tree
>>
>> But now I get DEPMOD 2.6.35-rc2-my_tree+
>>
>> Please fix it so if localversion* is present then the plus is
>> removed. And the git is not inspected
>>
> How is that a 'fix'? If I'm using localversion* and have people sending
> me bug reports, I still do want to see the git ID. The + thing in this
> context might not have any meaning since the 2.6.35-rc2 that you've
> tagged for your tree and the release one could wildly differ, but that's
> more of an argument against the + thing existing at all than anything
> else.
> 

You lost me sorry. I don't understand what you are saying ?

> Whether having LOCALVERSION_AUTO be compulsory is a good idea or not is
> another matter entirely, the localversion* semantics are pretty
> clear-cut.

the "localversion* semantics" is not the issue here. The issue is the
CONFIG_LOCALVERSION_AUTO semantics. You have effectively made it compulsory
but with a choice of a style. "From the frying pan to the fire"

And you have broken the "localversion* semantics". Because my vanilla release
is 2.6.rc2-my_tree-my_ver as checkedout and delivered from my official tree.
Now you have added a "+" regardless of if it is an official tagged version or
not.

I do not expect a complicated "let me be smarter than you" system that
checks any tags of mine and provides an out-of-tree version system. I just
want a switch that tells the system. "Let me shoot myself in the leg,
I know what I want"

"localversion*" should override any automatism as an indication of an
alternative tagging system. (Or any other switch that can turn this off)

And please stop the politics: "having LOCALVERSION_AUTO be compulsory" is
Politics not, anything technical: "how to support my needs"

Boaz
