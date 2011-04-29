Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760746Ab1D2Rrm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 13:47:42 -0400
Received: from jaguar.mail.utk.edu ([160.36.0.84]:51806 "EHLO
	jaguar.mail.utk.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760660Ab1D2Rrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 13:47:41 -0400
Date: Fri, 29 Apr 2011 13:46:01 -0400 (EDT)
From: Vince Weaver <vweaver1@eecs.utk.edu>
To: Pekka Enberg <penberg@kernel.org>
cc: Andi Kleen <ak@linux.intel.com>, torvalds@linux-foundation.org,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@gmail.com>
Subject: Re: re-enable Nehalem raw Offcore-Events support
In-Reply-To: <BANLkTim3bojtfeeWsAFx2Gct7LsvGCdn-w@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1104291341510.23685@cl320.eecs.utk.edu>
References: <alpine.DEB.2.00.1104291056220.22212@cl320.eecs.utk.edu> <BANLkTimjmYUJMGw0aB+w+E76H+kxSpqFZg@mail.gmail.com> <20110429172525.GA2745@tassilo.jf.intel.com> <BANLkTim3bojtfeeWsAFx2Gct7LsvGCdn-w@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Apr 2011, Pekka Enberg wrote:

> Asking Linus to revert the commit is short-sighted and doesn't solve
> the problem. Learn to work with the maintainer and save yourself a lot
> of trouble.

Work "with" Ingo?  That's turned out well so far.  I'm sure certain 
scheduler people could comment here too on where that gets you.

The kernel I run is "Linux" not "Ingoix".  So I await a comment from Linus 
on this issue.  If it turns out that he's happy with Ingo's work, fine.
It just means I'll have to start maintaining some perf counter related 
patches out of tree for those of us who actually like having control on 
what we're measuring.

Vince
