Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759406Ab0EMS7x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 14:59:53 -0400
Received: from fifo99.com ([67.223.236.141]:44696 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757334Ab0EMS7v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 14:59:51 -0400
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
In-Reply-To: <20100513183646.GA18155@srcf.ucam.org>
References: <1272667021-21312-1-git-send-email-arve@android.com>
	 <alpine.DEB.2.00.1005122118530.7624@utopia.booyaka.com>
	 <20100513121745.GA10749@srcf.ucam.org>
	 <1273771990.19100.13.camel@c-dwalke-linux.qualcomm.com>
	 <s2ga55d774e1005131117yd138c59bk54cc109401eb4a8d@mail.gmail.com>
	 <1273775157.19100.20.camel@c-dwalke-linux.qualcomm.com>
	 <20100513183646.GA18155@srcf.ucam.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 13 May 2010 11:59:37 -0700
Message-ID: <1273777177.19100.24.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-13 at 19:36 +0100, Matthew Garrett wrote:
> On Thu, May 13, 2010 at 11:25:57AM -0700, Daniel Walker wrote:
> 
> > The problem is that once this userspace interface is exposed, it's
> > nearly permanent and has to be support for a long long time .. It might
> > seen trivial to just remove something your not using, but we never know
> > who is using what once the kernel is released.
> 
> Deprecating sysfs interfaces can be done within 6 months or so, 
> especially if there's only one real consumer.

I'll assume your right (can you give an example of this?), but why
should we even add it if we know it's already going to get replaced.
It's like it's pre-deprecated ..

Daniel


