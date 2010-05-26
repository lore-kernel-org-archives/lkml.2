Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805Ab0EZNDy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 09:03:54 -0400
Received: from ist.d-labs.de ([213.239.218.44]:41215 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753578Ab0EZNDx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 09:03:53 -0400
Date: Wed, 26 May 2010 15:03:48 +0200
From: Florian Mickler <florian@mickler.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: felipe.balbi@nokia.com, Vitaly Wool <vitalywool@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Paul@smtp1.linux-foundation.org" <Paul@smtp1.linux-foundation.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100526150348.54ea29c7@schatten.dmk.lab>
In-Reply-To: <1274877689.27810.287.camel@twins>
References: <87wrusvrqe.fsf@deeprootsystems.com>
	<201005250138.16293.rjw@sisk.pl>
	<1274863655.5882.4875.camel@twins>
	<AANLkTinN6MKvCEhPkbYQRD2gu-mGXdNW9asRsTuKN3_Y@mail.gmail.com>
	<1274867106.5882.5090.camel@twins>
	<20100526120242.5c9b73ad@schatten.dmk.lab>
	<AANLkTim4021cTnhVZrQpefq1MG-eEPOFLDRO-XDepHb4@mail.gmail.com>
	<20100526133721.602633b2@schatten.dmk.lab>
	<AANLkTikzgaOFdQKess4E-D86OLPOzxP3dWiDkU_UR0ri@mail.gmail.com>
	<20100526142430.327ccbc4@schatten.dmk.lab>
	<20100526122932.GB1990@nokia.com>
	<20100526143323.7c6f8705@schatten.dmk.lab>
	<1274877689.27810.287.camel@twins>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 May 2010 14:41:29 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, 2010-05-26 at 14:33 +0200, Florian Mickler wrote:
> > On Wed, 26 May 2010 15:29:32 +0300
> > Felipe Balbi <felipe.balbi@nokia.com> wrote:
> > 
> > > hi,
> > > 
> > > On Wed, May 26, 2010 at 02:24:30PM +0200, ext Florian Mickler wrote:
> > > >And if you have two kernels, one with which your device is dead after 1
> > > >hour and one with which your device is dead after 10 hours. Which would
> > > >you prefer? I mean really... this is ridiculous.
> > > 
> > > What I find ridiculous is the assumption that kernel should provide good 
> > > power management even for badly written applications. They should work, 
> > > of course, but there's no assumption that the kernel should cope with 
> > > those applications and provide good battery usage on those cases.
> > > 
> > > You can install and run anything on the device, and they will work as 
> > > they should (they will be scheduled and will be processed) but you can't 
> > > expect the kernel to prevent that application from waking up the CPU 
> > > every 10 ms simply because someone didn't think straight while writting 
> > > the app.
> > > 
> > 
> > But then someone at the user side has to know what he is doing. 
> > 
> > I fear, if you target mass market without central distribution
> > channels, you can not assume that much.
> 
> Provide the developers and users with tools. 
> 
> Notify the users that their phone is using power at an unadvised rate
> due to proglet $foo.
> 
> Also, if you can integrate into the development environment and provide
> developers instant feedback on suckage of their app they can react and
> fix before letting users run into the issue.
> 

Yeah. And I personally agree with you there. But this is a policy
decision that should not prevent android from doing it differently.
The kernel can not win if it does not try to integrate any use of it.
After all, we are a free comunity and if someone wants to use it their
way, why not allow for it? (As long as it does not directly impact other
uses)

The best solution wins, but not by decision of some kernel
development gatekeepers, but because it is superior. There are no clear
markings of the better solution. Time will tell.

Cheers,
Flo


