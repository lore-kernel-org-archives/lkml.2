Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932561Ab0EMTgs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 15:36:48 -0400
Received: from fifo99.com ([67.223.236.141]:45672 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932238Ab0EMTgr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 15:36:47 -0400
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 6)
From: Daniel Walker <dwalker@fifo99.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: Brian Swetland <swetland@google.com>, Paul Walmsley <paul@pwsan.com>,
       Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       Tony Lindgren <tony@atomide.com>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Alan Stern <stern@rowland.harvard.edu>, magnus.damm@gmail.com,
       "Theodore Ts'o" <tytso@mit.edu>, mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       =?ISO-8859-1?Q?Beno=EEt?= Cousson <b-cousson@ti.com>,
       linux-omap@vger.kernel.org, Vitaly Wool <vitalywool@gmail.com>,
       Linus Walleij <linus.walleij@ericsson.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>
In-Reply-To: <20100513191142.GA18886@srcf.ucam.org>
References: <1272667021-21312-1-git-send-email-arve@android.com>
	 <alpine.DEB.2.00.1005122118530.7624@utopia.booyaka.com>
	 <20100513121745.GA10749@srcf.ucam.org>
	 <1273771990.19100.13.camel@c-dwalke-linux.qualcomm.com>
	 <s2ga55d774e1005131117yd138c59bk54cc109401eb4a8d@mail.gmail.com>
	 <1273775157.19100.20.camel@c-dwalke-linux.qualcomm.com>
	 <20100513183646.GA18155@srcf.ucam.org>
	 <1273777177.19100.24.camel@c-dwalke-linux.qualcomm.com>
	 <20100513191142.GA18886@srcf.ucam.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 13 May 2010 12:36:34 -0700
Message-ID: <1273779394.19100.47.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-13 at 20:11 +0100, Matthew Garrett wrote:
> On Thu, May 13, 2010 at 11:59:37AM -0700, Daniel Walker wrote:
> > On Thu, 2010-05-13 at 19:36 +0100, Matthew Garrett wrote:
> > > Deprecating sysfs interfaces can be done within 6 months or so, 
> > > especially if there's only one real consumer.
> > 
> > I'll assume your right (can you give an example of this?), but why
> > should we even add it if we know it's already going to get replaced.
> > It's like it's pre-deprecated ..
> 
> See feature-removal-schedule.txt. So far we have no indication that it's 
> going to be replaced, because nobody has actually suggested a working 
> way to do this better. If we had a concrete implementation proposal for 
> that then we'd be in a pretty different position right now.

Ok, feature-removal-schedule.txt applies to everything tho. What your
saying is that if this interface only last a short time it might take 6
months, if it last for a long time it would take longer. There's no easy
way to know that Google is the only user after some amount of time
passes.

Daniel

