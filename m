Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933435Ab1ESPPh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 11:15:37 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:54884 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933014Ab1ESPPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 11:15:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=s7Khs/37IlAMVBw7/mxAsMC15NXyFruYokNvygRkxv1o/pcuy31aJAGg2hftnEOKo7
         o+0/jivomTJk2OaQS2XVTKRKzgzEnJmrPHdPhGuaBZCsstuzzJlAh/HNqXZi2LLhDDNp
         XfjLHunNCy1id8f7NxEgBK2RqvMHYqJMqSoIw=
Date: Thu, 19 May 2011 17:15:30 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Borislav Petkov <bp@alien8.de>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>
Subject: Re: [RFC PATCH] perf: Split up buffer handling from core code
Message-ID: <20110519151528.GE1956@nowhere>
References: <1305767185-5771-1-git-send-email-fweisbec@gmail.com>
 <20110519073136.GB14049@liondog.tnic>
 <1305793931.2466.7191.camel@twins>
 <20110519141456.GB1956@nowhere>
 <1305816208.2466.7223.camel@twins>
 <20110519145951.GD1956@nowhere>
 <1305818041.2466.7225.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305818041.2466.7225.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 05:14:01PM +0200, Peter Zijlstra wrote:
> On Thu, 2011-05-19 at 16:59 +0200, Frederic Weisbecker wrote:
> > I thought it would be nice to keep it inline for core use, as it's called
> > pretty often from the overflow path.
> 
> That's what I meant.
> 
> > A solution is to have a perf_output_copy_inline() in internal.h
> > and export it through perf_output_copy() in buffer.c 
> 
> If only "external inline" would work :-)

Hehe :)
 
> I'd call it __perf_output_copy() though, less typing.

Fine!
