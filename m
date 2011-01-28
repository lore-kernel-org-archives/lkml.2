Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358Ab1A1RmJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 12:42:09 -0500
Received: from www.tglx.de ([62.245.132.106]:36723 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755061Ab1A1RmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 12:42:08 -0500
Date: Fri, 28 Jan 2011 18:41:33 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@elte.hu>
cc: Tejun Heo <tj@kernel.org>, roland@redhat.com, oleg@redhat.com,
        jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
Subject: Re: [PATCHSET] ptrace,signal: group stop / ptrace updates
In-Reply-To: <20110128165455.GA18194@elte.hu>
Message-ID: <alpine.LFD.2.00.1101281839390.31804@localhost6.localdomain6>
References: <1296227324-25295-1-git-send-email-tj@kernel.org> <20110128165455.GA18194@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Jan 2011, Ingo Molnar wrote:
> See that '^C^C' line? That is where i had to do Ctrl-C twice.
> 
> It only fails here about once every 10 times, so it's very rare. I have a stock F14 
> system running on that box, with the very latest .38 based kernel.

Tripped over the refuse ^C thing today twice. Had to kill a kernel
build from another shell. It just happily displayed ^C and never
stopped. That happens once in a while and I have no idea either how to
debug that.

Thanks,

	tglx
