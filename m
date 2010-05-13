Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932433Ab0EMTM0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 15:12:26 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:58057 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932305Ab0EMTMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 15:12:23 -0400
Date: Thu, 13 May 2010 20:11:42 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Brian Swetland <swetland@google.com>, Paul Walmsley <paul@pwsan.com>,
       Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       Tony Lindgren <tony@atomide.com>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Alan Stern <stern@rowland.harvard.edu>, magnus.damm@gmail.com,
       "Theodore Ts'o" <tytso@mit.edu>, mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       =?iso-8859-1?Q?Beno=EEt?= Cousson <b-cousson@ti.com>,
       linux-omap@vger.kernel.org, Vitaly Wool <vitalywool@gmail.com>,
       Linus Walleij <linus.walleij@ericsson.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 6)
Message-ID: <20100513191142.GA18886@srcf.ucam.org>
References: <1272667021-21312-1-git-send-email-arve@android.com> <alpine.DEB.2.00.1005122118530.7624@utopia.booyaka.com> <20100513121745.GA10749@srcf.ucam.org> <1273771990.19100.13.camel@c-dwalke-linux.qualcomm.com> <s2ga55d774e1005131117yd138c59bk54cc109401eb4a8d@mail.gmail.com> <1273775157.19100.20.camel@c-dwalke-linux.qualcomm.com> <20100513183646.GA18155@srcf.ucam.org> <1273777177.19100.24.camel@c-dwalke-linux.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273777177.19100.24.camel@c-dwalke-linux.qualcomm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 13, 2010 at 11:59:37AM -0700, Daniel Walker wrote:
> On Thu, 2010-05-13 at 19:36 +0100, Matthew Garrett wrote:
> > Deprecating sysfs interfaces can be done within 6 months or so, 
> > especially if there's only one real consumer.
> 
> I'll assume your right (can you give an example of this?), but why
> should we even add it if we know it's already going to get replaced.
> It's like it's pre-deprecated ..

See feature-removal-schedule.txt. So far we have no indication that it's 
going to be replaced, because nobody has actually suggested a working 
way to do this better. If we had a concrete implementation proposal for 
that then we'd be in a pretty different position right now.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
