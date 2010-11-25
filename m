Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751550Ab0KYIKQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 03:10:16 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64196 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997Ab0KYIKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 03:10:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mSWgKGXJGesFmAN26sSZ/V4VAYGHkZ1/T0lvbfxh6LBxJFHrpSb79ccZC996ARRtIl
         DXAi4Iwjiu9UH/AGNT0/u5ydH6rFQyTXrXAp4EjhDLDxle+r1guu6qQzFglfOGIDnBoH
         MMppcL6qEe6EO6TZjYR6JOouYgsThTRNyIbeY=
Date: Thu, 25 Nov 2010 09:10:11 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>, Julia Lawall <julia@diku.dk>,
        Tom Zanussi <tzanussi@gmail.com>, linux-kernel@vger.kernel.org,
        Matt Fleming <matt@console-pimps.org>
Subject: Re: [RFC PATCHv3] perf tools: add event grouping capability to
 "perf stat"
Message-ID: <20101125081008.GE2538@nowhere>
References: <1290650053-3486-1-git-send-email-cjashfor@linux.vnet.ibm.com>
 <1290666760.2072.539.camel@laptop>
 <20101125074629.GC2538@nowhere>
 <1290672009.2072.558.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290672009.2072.558.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 25, 2010 at 09:00:09AM +0100, Peter Zijlstra wrote:
> On Thu, 2010-11-25 at 08:46 +0100, Frederic Weisbecker wrote:
> > > perf record -e task-clock:freq=1000,cycles:period=0
> > 
> > Wouldn't this syntax clash with the flags we have on events already?
> > 
> > the u,k,p flags? 
> 
> From stephane's email (to which you were CC'ed) http://lkml.org/lkml/2010/11/23/303

Right, I'm going look at this.

 
> > $ perf record -e cycles:u:period=100000,instructions:k:freq=1500 -a -- sleep 5
> 
> The parser isn't particularly pretty, maybe its time to think about a parser generator?

May be yeah.
