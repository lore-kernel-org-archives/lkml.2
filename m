Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751379Ab0HRDzQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 23:55:16 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60792 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892Ab0HRDzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 23:55:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=XhJmZfKnQmNsR3VhJfmw7u61MnH5LlggwJqwj6rQTFWyiChAtzsTxzernJ3zFGht70
         WFLSAHJrrVvcfgB9IMGT9kT2ny4vhuJEE8KowDzy9AWSa5OA//PgeRFDZhSG8XlomvPt
         ZW/GpWCOJzoNS0VWBIH07uS/3bbDl/Cmzp7Bo=
Date: Wed, 18 Aug 2010 05:55:09 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Will Deacon <will.deacon@arm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Paul Mundt <lethal@linux-sh.org>, David Miller <davem@davemloft.net>,
        Borislav Petkov <bp@amd64.org>
Subject: Re: [RFC PATCH 0/0 v3] callchain fixes and cleanups
Message-ID: <20100818035507.GE24748@nowhere>
References: <1281991715-10367-1-git-send-regression-fweisbec@gmail.com> <1282041159.22114.2.camel@e102144-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282041159.22114.2.camel@e102144-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 17, 2010 at 11:32:39AM +0100, Will Deacon wrote:
> On Mon, 2010-08-16 at 21:48 +0100, Frederic Weisbecker wrote:
> > Hi,
> > 
> Hi Frederic,
> > 
> > This set factorizes a lot of callchain code and fixes concurrent
> > callchain buffers accesses.
> 
> > You can test it by pulling that branch:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> >         perf/callchains
> > 
> 
> I've tested this on an ARM Cortex-A9 board and it all seems fine [plus
> the code is a lot cleaner!].
> 
> Tested-by: Will Deacon <will.deacon@arm.com>


Thanks a lot!

BTW, out of curiosity, do you have NMIs on ARM and do the hardware events
make use of them? Or may be you use FIQ to simulate NMIs?

