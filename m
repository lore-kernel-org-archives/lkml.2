Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933367Ab1ESOPF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 10:15:05 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36733 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933264Ab1ESOPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 10:15:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Ln4uYURFTHbxWMKcZLn5XYi+o+3Cc99Gb4hDp+nk/vAZ7vHRWltcFm2BFx+waldmIm
         JuUln9XOIAxgTlsudm2GQaIQBKbgU2ED4a6lB/8/zVAykZWMqeYEgDb7byM9QEFnwD21
         w3LKjbzCJIEhuP2skAF0dCnpW2eWM4G43cxyA=
Date: Thu, 19 May 2011 16:14:59 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Borislav Petkov <bp@alien8.de>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>
Subject: Re: [RFC PATCH] perf: Split up buffer handling from core code
Message-ID: <20110519141456.GB1956@nowhere>
References: <1305767185-5771-1-git-send-email-fweisbec@gmail.com>
 <20110519073136.GB14049@liondog.tnic>
 <1305793931.2466.7191.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305793931.2466.7191.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 10:32:11AM +0200, Peter Zijlstra wrote:
> On Thu, 2011-05-19 at 09:31 +0200, Borislav Petkov wrote:
> > 
> > Ok, maybe I'm missing something looking at this from the side but
> > perf_output_copy is used only internally by perf_event.c, i.e.
> > events/core.c, why not put it into the internal.h header?
> 
> Not strictly true, but since the current inline is only valid for the
> existing perf_event.c its close enough :-)
> 
> Anyway, I agree, stick it in internal.h :-)

Great. I kept it global because I read in a review from you
that you wanted it to stay a visible API. But if you're fine
with it internal, let's move it there.

Thanks.
