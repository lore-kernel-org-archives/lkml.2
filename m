Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758869Ab0EMMSR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 08:18:17 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:57491 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758807Ab0EMMSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 08:18:15 -0400
Date: Thu, 13 May 2010 13:17:45 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Paul Walmsley <paul@pwsan.com>
Cc: Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       Tony Lindgren <tony@atomide.com>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Alan Stern <stern@rowland.harvard.edu>, magnus.damm@gmail.com,
       "Theodore Ts'o" <tytso@mit.edu>, mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>,
       Brian Swetland <swetland@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       =?iso-8859-1?Q?Beno=EEt?= Cousson <b-cousson@ti.com>,
       linux-omap@vger.kernel.org, Vitaly Wool <vitalywool@gmail.com>,
       Linus Walleij <linus.walleij@ericsson.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 6)
Message-ID: <20100513121745.GA10749@srcf.ucam.org>
References: <1272667021-21312-1-git-send-email-arve@android.com> <alpine.DEB.2.00.1005122118530.7624@utopia.booyaka.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1005122118530.7624@utopia.booyaka.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 12, 2010 at 09:35:30PM -0600, Paul Walmsley wrote:
> 
> Figuring out a different way to do this should not limit Android at all, 
> since Google can do what other Linux distributions do and continue to 
> patch opportunistic suspend/suspend-block calls into their kernels as 
> needed to ship devices, while contributing towards a different solution to 
> the problem.

I basically agree, except that despite having a year to do so none of us 
have come up with a different way that would actually work. Google have 
done this work. Who's going to prove that there is actually a different 
way to do this?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
