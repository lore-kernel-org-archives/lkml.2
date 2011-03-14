Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757445Ab1CNW1n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 18:27:43 -0400
Received: from leopard.mail.utk.edu ([160.36.0.85]:38675 "EHLO
	leopard.mail.utk.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757404Ab1CNW1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 18:27:42 -0400
Date: Mon, 14 Mar 2011 18:27:19 -0400 (EDT)
From: Vince Weaver <vweaver1@eecs.utk.edu>
To: linux-kernel@vger.kernel.org
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: perf: kernel memory leak when inherit enabled
In-Reply-To: <alpine.DEB.2.00.1103111745070.15818@cl320.eecs.utk.edu>
Message-ID: <alpine.DEB.2.00.1103141824190.13179@cl320.eecs.utk.edu>
References: <alpine.DEB.2.00.1103111745070.15818@cl320.eecs.utk.edu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Mar 2011, Vince Weaver wrote:
> 
> While trying to use perf events with inherit enabled to profile some 
> multi-threaded BLAS routines (using PAPI) I ended up out-of-memorying my 
> machine.  It turns out you can quickly leak gigabytes of kernel memory
> that isn't freed when the process exits.

I've bisected this.  There's a whole day I'll never see again. binutils 
2.21 and gcc-4.5 for the lose :(

Anyway this memory leak with inherit was introduced in 
  4fd38e4595e

Vince

