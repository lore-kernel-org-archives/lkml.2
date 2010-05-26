Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754948Ab0EZMle (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 08:41:34 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38301 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754160Ab0EZMlc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 08:41:32 -0400
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
From: Peter Zijlstra <peterz@infradead.org>
To: Florian Mickler <florian@mickler.org>
Cc: felipe.balbi@nokia.com, Vitaly Wool <vitalywool@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Paul@smtp1.linux-foundation.org" <Paul@smtp1.linux-foundation.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
In-Reply-To: <20100526143323.7c6f8705@schatten.dmk.lab>
References: <87wrusvrqe.fsf@deeprootsystems.com>
	 <201005250138.16293.rjw@sisk.pl> <1274863655.5882.4875.camel@twins>
	 <AANLkTinN6MKvCEhPkbYQRD2gu-mGXdNW9asRsTuKN3_Y@mail.gmail.com>
	 <1274867106.5882.5090.camel@twins>
	 <20100526120242.5c9b73ad@schatten.dmk.lab>
	 <AANLkTim4021cTnhVZrQpefq1MG-eEPOFLDRO-XDepHb4@mail.gmail.com>
	 <20100526133721.602633b2@schatten.dmk.lab>
	 <AANLkTikzgaOFdQKess4E-D86OLPOzxP3dWiDkU_UR0ri@mail.gmail.com>
	 <20100526142430.327ccbc4@schatten.dmk.lab>
	 <20100526122932.GB1990@nokia.com>
	 <20100526143323.7c6f8705@schatten.dmk.lab>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 26 May 2010 14:41:29 +0200
Message-ID: <1274877689.27810.287.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-26 at 14:33 +0200, Florian Mickler wrote:
> On Wed, 26 May 2010 15:29:32 +0300
> Felipe Balbi <felipe.balbi@nokia.com> wrote:
> 
> > hi,
> > 
> > On Wed, May 26, 2010 at 02:24:30PM +0200, ext Florian Mickler wrote:
> > >And if you have two kernels, one with which your device is dead after 1
> > >hour and one with which your device is dead after 10 hours. Which would
> > >you prefer? I mean really... this is ridiculous.
> > 
> > What I find ridiculous is the assumption that kernel should provide good 
> > power management even for badly written applications. They should work, 
> > of course, but there's no assumption that the kernel should cope with 
> > those applications and provide good battery usage on those cases.
> > 
> > You can install and run anything on the device, and they will work as 
> > they should (they will be scheduled and will be processed) but you can't 
> > expect the kernel to prevent that application from waking up the CPU 
> > every 10 ms simply because someone didn't think straight while writting 
> > the app.
> > 
> 
> But then someone at the user side has to know what he is doing. 
> 
> I fear, if you target mass market without central distribution
> channels, you can not assume that much.

Provide the developers and users with tools. 

Notify the users that their phone is using power at an unadvised rate
due to proglet $foo.

Also, if you can integrate into the development environment and provide
developers instant feedback on suckage of their app they can react and
fix before letting users run into the issue.


