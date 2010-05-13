Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759437Ab0EMTZv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 15:25:51 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:55890 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755816Ab0EMTZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 15:25:49 -0400
Date: Thu, 13 May 2010 20:25:22 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Paul Walmsley <paul@pwsan.com>,
       Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       Kevin Hilman <khilman@deeprootsystems.com>, magnus.damm@gmail.com,
       "Theodore Ts'o" <tytso@mit.edu>, mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>,
       Brian Swetland <swetland@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       =?iso-8859-1?Q?Beno=EEt?= Cousson <b-cousson@ti.com>,
       linux-omap@vger.kernel.org, Vitaly Wool <vitalywool@gmail.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 6)
Message-ID: <20100513192522.GA19256@srcf.ucam.org>
References: <alpine.DEB.2.00.1005122118530.7624@utopia.booyaka.com> <Pine.LNX.4.44L0.1005131002380.1695-100000@iolanthe.rowland.org> <20100513191717.GA3428@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100513191717.GA3428@atomide.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 13, 2010 at 12:17:17PM -0700, Tony Lindgren wrote:
> The suspend blocks seems like a hack to spam filter good and bad
> apps from timer usage point of view. Applications are categorized
> as good or bad depending if they grab a susped blocker or not.
> 
> I believe categorizing the apps should be instead done with some
> timer flags or cgroups instead.

I agree, but we have no mechanism for implementing that in a race-free 
way. We don't even have a realistical proposal for what that mechanism 
would look like. Should we refuse bread today for the promise of cake 
tomorrow?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
