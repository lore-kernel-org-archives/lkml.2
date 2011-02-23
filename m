Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656Ab1BWM2N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 07:28:13 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:48519 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754579Ab1BWM2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 07:28:10 -0500
Date: Wed, 23 Feb 2011 13:29:04 +0100
From: Borislav Petkov <bp@amd64.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Borislav Petkov <bp@amd64.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Funny perf
Message-ID: <20110223122904.GA3935@aftab>
References: <20110217182658.GA23443@aftab>
 <1298456508.2217.357.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298456508.2217.357.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 23, 2011 at 05:21:48AM -0500, Peter Zijlstra wrote:
> On Thu, 2011-02-17 at 19:26 +0100, Borislav Petkov wrote:
> > 
> > so this looks like some of the samples do not belong in the perf.data
> > output with that garbled cpu field. It lets me also assume that the
> > sample->time field is also crap so the timestamp check is falsely
> > tripped. 
> 
> Most interesting, I haven't tried to reproduce, but it does sound
> smelly.
> 
> I did have a quick peek at some code I suspected but that all seems in
> order. I guess someone will have to sit down and figure this out proper,
> if nobody steps up I guess it'll have to be me, but that also means it
> might take a while since I've got some other pending stuff to stare at
> before this :/

Same here, I'll try to play with this a bit more when I get a free
window. I think the first step should be if someone else tries
reproducing this to see whether it really is reproducible or there's
something wrong with my setup.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
