Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106Ab0DURyi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 13:54:38 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34479 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756091Ab0DURyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 13:54:36 -0400
Date: Wed, 21 Apr 2010 18:58:52 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Hedi Berriche <hedi@sgi.com>
Cc: Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, Robin Holt <holt@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Patch 1/1] init: Provide a kernel start parameter to increase
 pid_max v2
Message-ID: <20100421185852.3397f1da@lxorguk.ukuu.org.uk>
In-Reply-To: <20100421165934.GN16427@zorg.emea.sgi.com>
References: <4BCE579C.5070100@sgi.com>
	<4BCE5A73.3000904@sgi.com>
	<20100421102350.4c222e6b@lxorguk.ukuu.org.uk>
	<20100421165934.GN16427@zorg.emea.sgi.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Apr 2010 17:59:34 +0100
Hedi Berriche <hedi@sgi.com> wrote:

> On Wed, Apr 21, 2010 at 10:20 Alan Cox wrote:
> | > of 32k will not be enough.  A system with 1664 CPU's, there are 25163 processes
> | > started before the login prompt.  It's estimated that with 2048 CPU's we will pass
> | 
> | Is that perhaps the bug not the 32K limit?
> 
> Doubt it: I just checked on an *idle* 1664 CPUs system and I can see 26844
> tasks, all but few being kernel threads.

So why have we got 26844 tasks. Isn't that a rather more relevant
question.

And as I asked before - how does Tejun's work on sanitizing work queues
affect this ?

Alan
