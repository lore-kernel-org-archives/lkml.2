Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176Ab2FGHfl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 03:35:41 -0400
Received: from natasha.panasas.com ([67.152.220.90]:55279 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754829Ab2FGHfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 03:35:40 -0400
Message-ID: <4FD059AC.8050808@panasas.com>
Date: Thu, 7 Jun 2012 10:35:08 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111113 Thunderbird/8.0
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>
CC: <user-mode-linux-devel@lists.sourceforge.net>,
        <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
        <viro@zeniv.linux.org.uk>, <jslaby@suse.cz>, <alan@linux.intel.com>
Subject: Re: [uml-devel] um: TTY fixes (?)
References: <1338841657-30358-1-git-send-email-richard@nod.at> <4FCF6748.6020005@panasas.com>
In-Reply-To: <4FCF6748.6020005@panasas.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2012 05:20 PM, Boaz Harrosh wrote:

> On 06/04/2012 11:27 PM, Richard Weinberger wrote:
> 
<>

> 

> 
> Horray I'm back to my old self. Thanks I'll give it a run
> and report of any new problems
> 
> Thanks a million Richard
> Boaz
> 


OK I've run with these for a few days and they are doing
the Job perfectly. Not a single problem.

You may add tested-by: Boaz Harrosh <bharrosh@panasas.com>
on all patches if you'd like.

Please push them ASAP to Linus. They fix a real life breakage
that's there since v3.3. At least now we are back to
the problems that where there for a long time.

Please also CC: Stable Tree <stable@kernel.org> for 3.4
as clearly 3.4 is unusable at all right now.

I wish they would be sent to older stables as well, but
they won't patch, so it's not worth the effort.

>> 	mingetty is unable to start on anything else than tty0.
>> 	It exits after a few seconds.


I suspect this was always so since forever. I don't even know
how to configure such a thing. I know that the console I run
vmlinux from becomes tty0, until I halt (or crash). How do
you open more tty(s) and attach them to console windows?
I just use ssh for that.

(The setup of tty(s) for UML on Fedora is always such a pain
 and it changed 4 times since FC10, I always have to mount
 the image, figure out how to make tty1 a tty0, and delete
 all the other tty(s). perhaps I'm just clueless. Is there an
 easier way? Is there a way to tell UML to make tty0 be a tty1?
 Because in fedora tty0 is not defined.)

But please do not delay these patches because of old problems.
These can be solved later.

Thanks very much for fixing this, it's a life saver
Boaz

