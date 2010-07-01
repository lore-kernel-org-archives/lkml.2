Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756959Ab0GAQQo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 12:16:44 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53648 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567Ab0GAQQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 12:16:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Mc7/+gE56RYWH0WeDtwT6nFKkBCRIgU6vVPbIv07cYVAZ7Lt8FjW6R2G9ApYXAP8b3
         I3FbfKt+AAUeESWZVPjW2Z90RhRGAbP5t0uRiOYpEboco0Dwm4EOHa53wUCd8QdTQl3q
         aFgPxMEF4g/QNWcN+8mlBphPrRd17dYMUsghE=
Date: Thu, 1 Jul 2010 17:47:59 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Stephane Eranian <eranian@google.com>,
       David Miller <davem@davemloft.net>, Paul Mundt <lethal@linux-sh.org>,
       Will Deacon <will.deacon@arm.com>, Borislav Petkov <bp@amd64.org>
Subject: Re: [RFC PATCH 3/6] perf: Generalize some arch callchain code
Message-ID: <20100701154757.GB10616@nowhere>
References: <1277998562-21366-1-git-send-regression-fweisbec@gmail.com> <1277998562-21366-4-git-send-regression-fweisbec@gmail.com> <1277999161.1917.216.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277999161.1917.216.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 01, 2010 at 05:46:01PM +0200, Peter Zijlstra wrote:
> On Thu, 2010-07-01 at 17:35 +0200, Frederic Weisbecker wrote:
> > - Most archs use one callchain buffer per cpu, except x86 that needs
> >   to deal with NMIs. Provide a default perf_callchain_buffer()
> >   implementation that x86 overrides. 
> 
> sparc and power also have NMI like contexts.


Right, but they didn't split that into different nested buffers.
The 5th patch does anyway.

