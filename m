Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756281Ab0DUUKq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 16:10:46 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:62832 "EHLO
	mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755413Ab0DUUKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 16:10:45 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19407.23456.469074.256306@stoffel.org>
Date: Wed, 21 Apr 2010 16:10:08 -0400
From: "John Stoffel" <john@stoffel.org>
To: Hedi Berriche <hedi@sgi.com>
Cc: John Stoffel <john@stoffel.org>, Rik van Riel <riel@redhat.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Mike Travis <travis@sgi.com>,
       Ingo Molnar <mingo@elte.hu>, Greg Kroah-Hartman <gregkh@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, Robin Holt <holt@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Patch 1/1] init: Provide a kernel start parameter to increase
	pid_max v2
In-Reply-To: <20100421193350.GU16427@zorg.emea.sgi.com>
References: <4BCE579C.5070100@sgi.com>
	<4BCE5A73.3000904@sgi.com>
	<20100421102350.4c222e6b@lxorguk.ukuu.org.uk>
	<20100421165934.GN16427@zorg.emea.sgi.com>
	<4BCF336B.1050706@redhat.com>
	<19407.20109.308816.104856@stoffel.org>
	<20100421193350.GU16427@zorg.emea.sgi.com>
X-Mailer: VM 8.0.9 under Emacs 22.3.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Hedi" == Hedi Berriche <hedi@sgi.com> writes:

Hedi> On Wed, Apr 21, 2010 at 20:15 John Stoffel wrote:
Hedi> | >>>>> "Rik" == Rik van Riel <riel@redhat.com> writes:
Hedi> | 
Hedi> | Rik> That is 15 kernel threads per CPU.
Hedi> | 
Hedi> | Rik> Reducing the number of kernel threads sounds like a
Hedi> | Rik> useful thing to do.
Hedi> | 
Hedi> | Isn't that already a project? 

Hedi> Yes, thanks to Alan's probing I looked it up 

Hedi>     http://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git

Hedi> but we're definitely talking long term solution vs. something
Hedi> that can ease pain now.

It seems to me that running Linux on such a large machine is such a
specialized niche, the putting in your change to the regular kernel
isn't a near term need either.  And from the sounds of it, Tejun's
work has better long term potential.

But hey, I'm generally clueless, so take what I say with a grain of
salt.  :]  

John
