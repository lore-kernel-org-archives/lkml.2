Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756976Ab0EFRKa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 13:10:30 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:38477 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037Ab0EFRK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 13:10:29 -0400
Date: Thu, 6 May 2010 18:09:56 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Brian Swetland <swetland@google.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       mark gross <mgross@linux.intel.com>, markgross@thegnar.org,
       Len Brown <len.brown@intel.com>, linux-doc@vger.kernel.org,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 1/8] PM: Add suspend block api.
Message-ID: <20100506170956.GA28104@srcf.ucam.org>
References: <20100505202826.GB7450@linux.intel.com> <Pine.LNX.4.44L0.1005051705200.1885-100000@iolanthe.rowland.org> <z2ta55d774e1005051437heb584584q6afca0b4b254d5d0@mail.gmail.com> <20100505234755.GI29604@atomide.com> <20100506134015.GA23426@srcf.ucam.org> <20100506170151.GA30928@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100506170151.GA30928@atomide.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 06, 2010 at 10:01:51AM -0700, Tony Lindgren wrote:

> Or are you suspending constantly, tens of times per minute even if
> there's no user activity?

In this case you'd be repeatedly trying to suspend until the modem 
driver stopped blocking it. It's pretty much a waste.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
