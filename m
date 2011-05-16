Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392Ab1EPHnm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 03:43:42 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:45119 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888Ab1EPHnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 03:43:41 -0400
Date: Mon, 16 May 2011 08:42:30 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, John Stultz <john.stultz@linaro.org>,
        Jacob Pan <jacob.jun.pan@intel.com>,
        Glauber Costa <glommer@redhat.com>,
        Dimitri Sivanich <sivanich@sgi.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Jeremy Fitzhardinge <jeremy@xensource.com>,
        Chris McDermott <lcm@us.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: linux-next: manual merge of the tip tree with the arm tree
Message-ID: <20110516074230.GI30539@n2100.arm.linux.org.uk>
References: <20110513131437.8999e8eb.sfr@canb.auug.org.au> <20110513080634.GA13647@elte.hu> <20110513083738.GA19733@n2100.arm.linux.org.uk> <20110513092646.GK13647@elte.hu> <20110513213640.GB30539@n2100.arm.linux.org.uk> <20110516073144.GF24836@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110516073144.GF24836@elte.hu>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 16, 2011 at 09:31:44AM +0200, Ingo Molnar wrote:
> 
> * Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> 
> > On Fri, May 13, 2011 at 11:26:46AM +0200, Ingo Molnar wrote:
> > > Had you asked us before committing it one day after it was posted, or had you 
> > > *noticed* that those files are not in your tree and are already modified in 
> > > linux-next, you'd have gotten a response like:
> > 
> > Please also don't read anything into the commit date - it merely shows
> > when the last update happened.
> >
> > My workflow for patch series involves keeping them in git right from the 
> > start.  So actually they've been in git since _before_ they were posted. In 
> > fact, the emails which I send out for any patch series are always generated 
> > from the git commits.
> > 
> > So, all my patches live in git _first_ before being mailed out.
> 
> It is not a problem at all if you commit it to some non-permanent development 
> branch of your own - we all do it.

Clearly you're not listening, so no point discussing this further.
