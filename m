Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759197Ab0EMS0U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 14:26:20 -0400
Received: from fifo99.com ([67.223.236.141]:55584 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759161Ab0EMS0N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 14:26:13 -0400
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 6)
From: Daniel Walker <dwalker@fifo99.com>
To: Brian Swetland <swetland@google.com>
Cc: Matthew Garrett <mjg@redhat.com>, Paul Walmsley <paul@pwsan.com>,
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
In-Reply-To: <s2ga55d774e1005131117yd138c59bk54cc109401eb4a8d@mail.gmail.com>
References: <1272667021-21312-1-git-send-email-arve@android.com>
	 <alpine.DEB.2.00.1005122118530.7624@utopia.booyaka.com>
	 <20100513121745.GA10749@srcf.ucam.org>
	 <1273771990.19100.13.camel@c-dwalke-linux.qualcomm.com>
	 <s2ga55d774e1005131117yd138c59bk54cc109401eb4a8d@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 13 May 2010 11:25:57 -0700
Message-ID: <1273775157.19100.20.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-13 at 11:17 -0700, Brian Swetland wrote:

> 
> I'm not sure this necessitates using only debugfs for the userspace
> interface.  A userspace interface is necessary to accomplish what
> we're trying to do here, otherwise we have only half a solution, and
> our hope is that it'd be a stable interface (as userspace interfaces
> are supposed to be) for as long as its needed.  I could totally
> imagine the userspace interface eventually becoming a no-op or
> punching through to some other facility, depending on how this problem
> is solved long-term in the ideal post-suspend-block future.

The problem is that once this userspace interface is exposed, it's
nearly permanent and has to be support for a long long time .. It might
seen trivial to just remove something your not using, but we never know
who is using what once the kernel is released.

Daniel

