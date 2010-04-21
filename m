Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623Ab0DUTaU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 15:30:20 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:62318 "EHLO
	mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755394Ab0DUTaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 15:30:18 -0400
X-Greylist: delayed 908 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Apr 2010 15:30:18 EDT
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19407.20109.308816.104856@stoffel.org>
Date: Wed, 21 Apr 2010 15:14:21 -0400
From: "John Stoffel" <john@stoffel.org>
To: Rik van Riel <riel@redhat.com>
Cc: Hedi Berriche <hedi@sgi.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, Robin Holt <holt@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Patch 1/1] init: Provide a kernel start parameter to increase
 pid_max v2
In-Reply-To: <4BCF336B.1050706@redhat.com>
References: <4BCE579C.5070100@sgi.com>
	<4BCE5A73.3000904@sgi.com>
	<20100421102350.4c222e6b@lxorguk.ukuu.org.uk>
	<20100421165934.GN16427@zorg.emea.sgi.com>
	<4BCF336B.1050706@redhat.com>
X-Mailer: VM 8.0.9 under Emacs 22.3.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Rik" == Rik van Riel <riel@redhat.com> writes:

Rik> On 04/21/2010 12:59 PM, Hedi Berriche wrote:
>> On Wed, Apr 21, 2010 at 10:20 Alan Cox wrote:
>> |>  of 32k will not be enough.  A system with 1664 CPU's, there are 25163 processes
>> |>  started before the login prompt.  It's estimated that with 2048 CPU's we will pass
>> |
>> | Is that perhaps the bug not the 32K limit?
>> 
>> Doubt it: I just checked on an *idle* 1664 CPUs system and I can see 26844
>> tasks, all but few being kernel threads.

Rik> That is 15 kernel threads per CPU.

Rik> Reducing the number of kernel threads sounds like a
Rik> useful thing to do.

Isn't that already a project?  I thought someone (Jeff? Jorn? Tejun? Bueller
bueller....?) was already proposing a patch set to reduce the number
of kernel threads by having dynamic workqueues instead, so that we
didn't spawn a bunch of threads that never did anything?

John
