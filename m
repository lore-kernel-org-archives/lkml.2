Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852Ab0K2EJ6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 23:09:58 -0500
Received: from amber.ccs.neu.edu ([129.10.116.51]:55107 "EHLO
	amber.ccs.neu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754730Ab0K2EJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 23:09:57 -0500
Date: Sun, 28 Nov 2010 23:09:51 -0500
From: Gene Cooperman <gene@ccs.neu.edu>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: Kapil Arya <kapil@ccs.neu.edu>, Gene Cooperman <gene@ccs.neu.edu>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, xemul@sw.ru,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linux Containers <containers@lists.osdl.org>
Subject: Re: [Ksummit-2010-discuss] checkpoint-restart: naked patch
Message-ID: <20101129040951.GD6471@sundance.ccs.neu.edu>
References: <4CD72150.9070705@cs.columbia.edu>
 <4CE3C334.9080401@kernel.org>
 <20101117153902.GA1155@hallyn.com>
 <4CE3F8D1.10003@kernel.org>
 <20101119041045.GC24031@hallyn.com>
 <4CE683E1.6010500@kernel.org>
 <4CE69B8C.6050606@cs.columbia.edu>
 <Pine.LNX.4.64.1011251049350.3051@takamine.ncl.cs.columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1011251049350.3051@takamine.ncl.cs.columbia.edu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oren,

On Thu, Nov 25, 2010 at 11:04:16AM -0500, Oren Laadan wrote:
> On Tue, 23 Nov 2010, Kapil Arya wrote:
> 
> > OL> Even if it did - the question is not how to deal with "glue"
> > OL> (you demonstrated quite well how to do that with DMTCP), but
> > OL> how should teh basic, core c/r functionality work - which is
> > OL> below, and orthogonal to the "glue".
> > 
> > There seems to be an implicit assumption that it is easy to separate the DMTCP
> > "glue code" from the DMTCP C/R engine as separate modules. DMTCP is modular but
> > it splits the problems into modules along a different line than Linux C/R. We
> > look forward to the joint experiment in which we would try to combine DMTCP
> > with Linux C/R. This will help answer the question in our mind.
> 
> I apologize for being blunt - but this is probably an issue specific to 
> DMTCP's engineering...
> 

I completely agree with you, Oren.  DMTCP was never designed to be split
into a userland and in-kernel replacement.  We will want to re-factor
DMTCP to make this happen.
    I'm sorry if my e-mail came off as confrontational.  That was not my
intention.  I was just looking forward to an interesting intellectual
experiment --- how to go about combining DMTCP and Linux C/R.   I was
trying to guess ahead of time where there are interesting challenges, and
my hope is that we will find a way to solve them together.

Best wishes,
- Gene
