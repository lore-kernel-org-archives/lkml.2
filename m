Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515Ab2FDCRw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 22:17:52 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:40000 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755009Ab2FDCRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 22:17:49 -0400
Date: Mon, 4 Jun 2012 10:17:17 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: tglx@linutronix.de, peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        rusty@rustcorp.com.au, mingo@kernel.org, akpm@linux-foundation.org,
        vatsa@linux.vnet.ibm.com, rjw@sisk.pl, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, nikunj@linux.vnet.ibm.com,
        Ralf Baechle <ralf@linux-mips.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mike Frysinger <vapier@gentoo.org>,
        David Howells <dhowells@redhat.com>, Arun Sharma <asharma@fb.com>,
        linux-mips@linux-mips.org
Subject: Re: [PATCH 10/27] mips, smpboot: Use generic SMP booting
 infrastructure
Message-ID: <20120604021717.GA26319@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <20120601090952.31979.24799.stgit@srivatsabhat.in.ibm.com>
 <20120601091226.31979.62223.stgit@srivatsabhat.in.ibm.com>
 <20120603082507.GA16829@zhy>
 <4FCB4F00.8080202@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4FCB4F00.8080202@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 03, 2012 at 05:18:16PM +0530, Srivatsa S. Bhat wrote:
> Yes, I noticed that while writing the patch. But then, I thought of cleaning
> up the hundreds of callin/callout/commenced maps in various architectures and
> bringing them out into core code in a later series, and clean this up at that time..
> I didn't want to do too many invasive changes all at one-shot.

OK.

> But I guess for this particular case of mips, I can get rid of the wait for
> cpu_callin_map in this patchset itself. I'll update this patch with that change.

:-)

> So what is the status of those patches? Has anyone picked them up?
> 
> I could rebase this patch on top of yours, or better yet, if your
> patches haven't been picked up yet, I could include them in this
> patchset itself to avoid too many dependencies on external patches.
> 
> What do you say?

Ralf has pushed it to http://git.linux-mips.org/?p=ralf/linux.git;a=summary

I guess you can see it soon.

Thanks,
Yong
