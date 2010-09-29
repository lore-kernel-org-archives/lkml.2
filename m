Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992Ab0I2H33 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 03:29:29 -0400
Received: from ist.d-labs.de ([213.239.218.44]:39402 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751412Ab0I2H32 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 03:29:28 -0400
Date: Wed, 29 Sep 2010 09:29:24 +0200
From: Florian Mickler <florian@mickler.org>
To: tmhikaru@gmail.com
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.35.6
Message-ID: <20100929092924.2090f19e@schatten.dmk.lab>
In-Reply-To: <20100928190358.GA24303@roll>
References: <20100927003608.GA20395@kroah.com>
	<20100927163208.GA4892@roll>
	<20100927215135.3d11d587@schatten.dmk.lab>
	<20100927233956.GA15705@roll>
	<20100928083505.0a808ffd@schatten.dmk.lab>
	<20100928190358.GA24303@roll>
X-Mailer: Claws Mail 3.7.6cvs31 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Sep 2010 15:03:58 -0400
tmhikaru@gmail.com wrote:

> On Tue, Sep 28, 2010 at 08:35:05AM +0200, Florian Mickler wrote:
> > > 
> > > Here's a graphical example of just how wacky this is:
> > > 
> > > http://yfrog.com/6lloadbp
> > > 
> > > In this image, the dip down to less than 0.5 after the 18'th is due to me
> > > experimenting using the slackware distribution kernel (2.6.33.4) after I
> > > finally noticed something was amiss. The sharp rise afterwards is due to me
> > > first, building 2.6.35.5, and then afterwards, using it. To be perfectly
> > > clear, I've previously used 2.6.34.2 and did not experience the problem
> > > there either, nor is it in 2.6.33.4.
> > 
> > What load figure are you basing your observations on? The 15 minutes
> > average should be the most interesting (sampled at a 7 minutes
> > interval...)
> 
> my observations are based on letting the machine idle immediately after
> bootup. I monitor the state of the machine using a program called conky,
> which I have configured to show disk I/O, cpu use, swap I/O and among other
> things, the load average. Immediately after booting my loadaverage tends to
> peak at about 2.5 to 3.0; on a working kernel this eventually settles down
> to 0.00 to 0.05 in about ten minutes. On kernels that exhibit this problem,
> it doesn't settle lower than 0.3 and is much more likely to hang anywhere
> from 0.8 to 1.2. In fact, if I give it enough time it'll raise and lower
> itself constantly without any (visible) work being done. So basically I boot
> the machine and go get a drink, come back, and if it's been ten minutes,
> there's been no disk IO, cpu use, or any other activity recorded and it's
> still above 0.3 something's not working right.

Do you know what load average conky is showing you? If I
type 'uptime' on a console, i get three load numbers: 1minute-,
5minutes- and 15minutes-average. 
If there is a systematic bias it should be visible on the
15minutes-average.  If there are only bursts of 'load' it should be
visible on the 1 minutes average numbers. 

But it doesn't really matter for now what kind of load disturbance you
are seeing, because you actually have a better way to distinguish a good
kernel from a bad:

On Mon, 27 Sep 2010 12:32:08 -0400
tmhikaru@gmail.com wrote:

> *Something* is wrong beyond the
> mere loadaverage numbers going crazy however, since timed runs of kernel
> compiles done with my distro's kernel and 2.6.35.5 show that while there is
> no *apparent* use of cpu or disk showing in vmstat while the machine is
> idle, the compiles on the newer kernel are taking approximately twice as
> long as before.


> If you're talking about the graph,
> I merely posted it to show that I've been having this problem for over a
> month, and it's demonstrably causing very inconsistent load averages. (Which
> is why the graph isn't anything close to a line, it's a mess!) the graph
> takes a reading every five minutes, if you were wondering about the sample
> rate.

Yes, the sample rate was one of the things I wanted to know, but also which of
the 3 load figures you were graphing.  

> In other news, I'm in the process of bisection but keep having to skip
> bisects that have compile errors. sigh. still at 12 hops, somewhere around
> five thousands commits to check.

Good. 

> 
> Tim McGrath
> 

Regards,
Flo
