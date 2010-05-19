Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537Ab0ESHOK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 03:14:10 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:42440 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146Ab0ESHOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 03:14:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=GwQZwetLrRABpwry4yz/B55F0HPndeNI93IKZKX9CliLZDSmgv4fV0O4ruJLeN0gTX
         37KDJxjkgHoP7u1pZ6Dkvz3aIo3GtJqfhz451rSvegdkOIb4Ew7wXQmG+HXbDEwJKi3M
         iBHOtQFL2lx2dj9xD3748GDhbQJzIehqkP1Cs=
Date: Wed, 19 May 2010 09:14:10 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] Optimize perf ring-buffer
Message-ID: <20100519071408.GA5704@nowhere>
References: <20100518133258.000434886@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100518133258.000434886@chello.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 18, 2010 at 03:32:58PM +0200, Peter Zijlstra wrote:
> This patch-set optimizes the perf ring-buffer by removing IRQ disable and 
> all LOCK ops from the fast paths.
> 
> There's also an RFC patch that adds perf_output_addr() which will allow
> you to write directly to the buffer, however I'm not sure how to go
> about using it for the trace events since we need to multiplex event --
> there is no single copy of the actual event.


What do you mean by the fact we need to multiplex event?

