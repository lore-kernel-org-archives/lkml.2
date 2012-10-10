Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757304Ab2JJUhO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 16:37:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37216 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757180Ab2JJUhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 16:37:12 -0400
Date: Wed, 10 Oct 2012 13:37:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Tang Chen <tangchen@cn.fujitsu.com>,
        mingo@redhat.com, miaox@cn.fujitsu.com, wency@cn.fujitsu.com,
        linux-kernel@vger.kernel.org, linux-numa@vger.kernel.org
Subject: Re: [PATCH] Do not use cpu_to_node() to find an offlined cpu's
 node.
Message-Id: <20121010133709.7eaefcdb.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.1210101324000.28583@chino.kir.corp.google.com>
References: <1349665183-11718-1-git-send-email-tangchen@cn.fujitsu.com>
	<1349780256.7880.12.camel@twins>
	<alpine.DEB.2.00.1210091328030.32588@chino.kir.corp.google.com>
	<1349815676.7880.85.camel@twins>
	<alpine.DEB.2.00.1210091617260.10143@chino.kir.corp.google.com>
	<1349860216.7880.105.camel@twins>
	<alpine.DEB.2.00.1210101324000.28583@chino.kir.corp.google.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Oct 2012 13:30:29 -0700 (PDT)
David Rientjes <rientjes@google.com> wrote:

> > So for now, let me NACK that patch. You cannot go change stuff like
> > that.
> > 
> 
> Agreed, that makes the nack-count up to 2 now.  Andrew, please remove 
> cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved.patch
> cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved-fix.patch
> from -mm.

Nope.  It fixes a BUG() and so I'll be keeping it around until I see a
better fix.  It's one of the ways in which I prevent things from falling
through cracks.
