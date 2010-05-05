Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759989Ab0EENcE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 09:32:04 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:41324 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759252Ab0EENcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 09:32:00 -0400
Date: Wed, 5 May 2010 14:31:31 +0100
From: Matthew Garrett <mjg@redhat.com>
To: mark gross <mgross@linux.intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, markgross@thegnar.org,
       Len Brown <len.brown@intel.com>, linux-doc@vger.kernel.org,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 1/8] PM: Add suspend block api.
Message-ID: <20100505133131.GA24477@srcf.ucam.org>
References: <20100504160346.GA27938@linux.intel.com> <Pine.LNX.4.44L0.1005041252480.1729-100000@iolanthe.rowland.org> <20100505015050.GA30591@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100505015050.GA30591@linux.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 04, 2010 at 06:50:50PM -0700, mark gross wrote:

> In my sequence above I had the modem driver "magically" knowing to fail
> this suspend attempt.  (that "magic" wasn't fully thought out though.)

If the modem driver knows to "magically" fail a suspend attempt until it 
knows that userspace has consumed the event, you have something that 
looks awfully like suspend blockers.

> There *has* to be a better way.

But nobody has reasonably proposed one and demonstrated that it works. 
We've had over a year to do so and failed, and I think it's pretty 
unreasonable to ask Google to attempt to rearchitect based on a 
hypothetical.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
