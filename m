Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758701Ab1FKPlG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jun 2011 11:41:06 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:41031 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758655Ab1FKPlD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jun 2011 11:41:03 -0400
Date: Sat, 11 Jun 2011 17:40:56 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Greg Dietsche <gregory.dietsche@cuw.edu>
Cc: Nicolas Palix <Nicolas.Palix@inria.fr>, rdunlap@xenotime.net,
        Gilles.Muller@lip6.fr, cocci@diku.dk, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] coccicheck: add M= option to control which dir is
 processed
In-Reply-To: <4DF38AB8.4080004@cuw.edu>
Message-ID: <Pine.LNX.4.64.1106111740130.13465@ask.diku.dk>
References: <1307503774-30370-1-git-send-email-Gregory.Dietsche@cuw.edu>
 <1307503774-30370-2-git-send-email-Gregory.Dietsche@cuw.edu> <4DEFC6DA.9050809@cuw.edu>
 <BANLkTi=gZzsZcSKUd3x50PbPwKC-Vnj24Q@mail.gmail.com> <4DF38AB8.4080004@cuw.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 11 Jun 2011, Greg Dietsche wrote:

> On 06/08/2011 02:10 PM, Nicolas Palix wrote:
> > I am not familiar with out-of-tree development but I guess that in
> > that case we should
> > also add a "-I $KBUILD_EXTMOD/include" ?
> >
> >    
> I decided to skip doing this in V2 of the patch. I did a very quick test and
> cocci didn't seem to like two -I flags on one command line.

What was the problem and what version of coccinelle do you have?  To my 
recollection, the ability to have multiple -I options was added sometime 
not so long ago.

julia

> > The use of -I by Coccinelle depends on the other options (like
> > -include_headers or -all_includes).
> > Such options are retrieved from the comments in the cocci files.
> > So the need for -I depends on the semantic patch you consider. I think
> > it is thus better
> > to be "exhaustive" in that case.
> >
> > Julia, is there any performance problem in doing so ?
> >    
> 
> Greg
> 
> 
> 
