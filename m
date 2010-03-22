Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755119Ab0CVUNv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 16:13:51 -0400
Received: from mail.windriver.com ([147.11.1.11]:52905 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756Ab0CVUNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 16:13:50 -0400
Message-ID: <4BA7CF53.7040504@windriver.com>
Date: Mon, 22 Mar 2010 15:13:07 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: torvalds@linux-foundation.org, kgdb-bugreport@lists.sourceforge.net,
       lkml <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [RESEND] Re: [Kgdb-bugreport] [GIT PULL] V2 kdb / early debug
 (1 of 2) for 2.6.34
References: <1267420188-10227-1-git-send-email-jason.wessel@windriver.com><4BA58100.2000104@windriver.com> <20100322130530.50e8de1e@jbarnes-piketon>
In-Reply-To: <20100322130530.50e8de1e@jbarnes-piketon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Mar 2010 20:13:06.0194 (UTC) FILETIME=[156DCF20:01CAC9FC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2010 03:05 PM, Jesse Barnes wrote:
> On Sat, 20 Mar 2010 21:14:24 -0500
> Jason Wessel <jason.wessel@windriver.com> wrote:
>
>   
>> On 02/28/2010 11:09 PM, Jason Wessel wrote:
>>     
>>> Linus please pull the kdb-merge tree which merges the kdb front end
>>> into the kernel debug core for 7 architectures.
>>>
>>> git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb.git kdb-merge
>>>   
>>>       
>> What is the status of this pull request?  Was some part of the process
>> missed here that there has been no response on this pull request?
>>
>> Please let me know what is wrong here.   I have a number of other fixes
>> pending to the tree at this point.
>>
>> Would it be possible to merge part of the tree that is only related to
>> kgdb, in particular the directory re-organization?
>>     
>
> IIRC he still had some issues with the keyboard/input handling.  We
> discussed it briefly a couple of weeks ago and he was worried about
> potential duplication.
>
>   

I worked with Dmitry Torokhov to come to some agreement with respect to
the kdb keyboard handling.  This resulted in dropping one of the
keyboard patches entirely, and it will be done another way.  There are
RFC patches from me on this, as well as Dmitry's own RFC patches for
sysrq handling.

The discussion with Dmitry also resulted in the cleanup of the current
kdb low level PS/2 kdb keyboard driver to an acceptable state.  I was
waiting to hear back on the response to the pull request before
investing further effort here.  I am always open to suggestions of how
to solve this tricky problem.

Thanks,
Jason.
