Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758050Ab0EMRdd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 13:33:33 -0400
Received: from fifo99.com ([67.223.236.141]:39435 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755032Ab0EMRdc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 13:33:32 -0400
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 6)
From: Daniel Walker <dwalker@fifo99.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: Paul Walmsley <paul@pwsan.com>,
       Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       Tony Lindgren <tony@atomide.com>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Alan Stern <stern@rowland.harvard.edu>, magnus.damm@gmail.com,
       "Theodore Ts'o" <tytso@mit.edu>, mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>,
       Brian Swetland <swetland@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       =?ISO-8859-1?Q?Beno=EEt?= Cousson <b-cousson@ti.com>,
       linux-omap@vger.kernel.org, Vitaly Wool <vitalywool@gmail.com>,
       Linus Walleij <linus.walleij@ericsson.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>
In-Reply-To: <20100513121745.GA10749@srcf.ucam.org>
References: <1272667021-21312-1-git-send-email-arve@android.com>
	 <alpine.DEB.2.00.1005122118530.7624@utopia.booyaka.com>
	 <20100513121745.GA10749@srcf.ucam.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 13 May 2010 10:33:10 -0700
Message-ID: <1273771990.19100.13.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-13 at 13:17 +0100, Matthew Garrett wrote:
> On Wed, May 12, 2010 at 09:35:30PM -0600, Paul Walmsley wrote:
> > 
> > Figuring out a different way to do this should not limit Android at all, 
> > since Google can do what other Linux distributions do and continue to 
> > patch opportunistic suspend/suspend-block calls into their kernels as 
> > needed to ship devices, while contributing towards a different solution to 
> > the problem.
> 
> I basically agree, except that despite having a year to do so none of us 
> have come up with a different way that would actually work. Google have 
> done this work. Who's going to prove that there is actually a different 
> way to do this?

We all feel the pain of inelegance right? I think it's clear that this
system will not last (but there's no other immediate option) .. That
doesn't mean we should reject it, but we need to be clear that this
system will get replaced. So we should format the patches appropriately.
To me the userspace aspect is a permanent change .. If we could drop
that (or put it into debugfs) then it would make this a lot easy to
accept as a stepping stone.

Daniel

