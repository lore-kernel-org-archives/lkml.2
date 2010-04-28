Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961Ab0D1Q4H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 12:56:07 -0400
Received: from cantor.suse.de ([195.135.220.2]:39391 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755920Ab0D1Q4F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 12:56:05 -0400
Date: Wed, 28 Apr 2010 18:55:50 +0200
From: Jiri Benc <jbenc@suse.cz>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
       Greg KH <greg@kroah.com>, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Eric Dumazet <dada1@cosmosbay.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Tejun Heo <tj@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Jiri Kosina <jkosina@suse.cz>, Anton Blanchard <anton@samba.org>
Subject: Re: [171/197] module: fix __module_ref_addr()
Message-ID: <20100428185550.4406319c@logostar.upir.cz>
In-Reply-To: <20100428162056.GA2846@Krystal>
References: <20100422191857.GA13268@kroah.com>
	<20100422190922.702027944@kvm.kroah.org>
	<20100428165201.3d7d6b4a@griffin.suse.cz>
	<20100428162056.GA2846@Krystal>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Apr 2010 12:20:56 -0400, Mathieu Desnoyers wrote:
> Can you try reverting commit c8d52465f95c4187871f8e65666c07806ca06d41 and see if
> it helps ?

It doesn't. The produced code is identical.

> If you have other compiler versions handy, that would also be helpful to see if
> the problem is specific to the gcc version you are using.

Tried 4.5.0, the same problem (at least looking at the produced assembler
code, I haven't booted the kernel, but it looks very similar to 4.3.3).

Thanks,

 Jiri

-- 
Jiri Benc
SUSE Labs
