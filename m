Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753806Ab0EMVQx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 17:16:53 -0400
Received: from fifo99.com ([67.223.236.141]:51231 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752760Ab0EMVQv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 17:16:51 -0400
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 6)
From: Daniel Walker <dwalker@fifo99.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Matthew Garrett <mjg@redhat.com>, Brian Swetland <swetland@google.com>,
       Paul Walmsley <paul@pwsan.com>,
       Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       Tony Lindgren <tony@atomide.com>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Alan Stern <stern@rowland.harvard.edu>, magnus.damm@gmail.com,
       "Theodore Ts'o" <tytso@mit.edu>, mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>,
       =?ISO-8859-1?Q?Beno=EEt?= Cousson <b-cousson@ti.com>,
       linux-omap@vger.kernel.org, Vitaly Wool <vitalywool@gmail.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>
In-Reply-To: <201005132311.26293.rjw@sisk.pl>
References: <1272667021-21312-1-git-send-email-arve@android.com>
	 <1273779394.19100.47.camel@c-dwalke-linux.qualcomm.com>
	 <20100513194820.GA19722@srcf.ucam.org>  <201005132311.26293.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 13 May 2010 14:16:39 -0700
Message-ID: <1273785399.19100.98.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-13 at 23:11 +0200, Rafael J. Wysocki wrote:
> On Thursday 13 May 2010, Matthew Garrett wrote:
> > On Thu, May 13, 2010 at 12:36:34PM -0700, Daniel Walker wrote:
> > > On Thu, 2010-05-13 at 20:11 +0100, Matthew Garrett wrote:
> > > > See feature-removal-schedule.txt. So far we have no indication that it's 
> > > > going to be replaced, because nobody has actually suggested a working 
> > > > way to do this better. If we had a concrete implementation proposal for 
> > > > that then we'd be in a pretty different position right now.
> > > 
> > > Ok, feature-removal-schedule.txt applies to everything tho. What your
> > > saying is that if this interface only last a short time it might take 6
> > > months, if it last for a long time it would take longer. There's no easy
> > > way to know that Google is the only user after some amount of time
> > > passes.
> > 
> > If the interface is there for a long time, it's because we haven't come 
> > up with anything better. And if we haven't come up with anything better, 
> > the interface deserves to be there.
> 
> Moreover, the interface is already in use out-of-tree and that usage is
> actually _growing_, so we have a growing number of out-of-tree drivers that
> aren't megrgeable for this very reason.

Why can't we merge the drivers? Drivers are just drivers, they don't
need this to get merged. (They need it to work with Android)

Daniel

