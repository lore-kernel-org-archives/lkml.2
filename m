Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756023Ab0EQTjO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 15:39:14 -0400
Received: from ns1.siteground211.com ([209.62.36.12]:42248 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755448Ab0EQTjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 15:39:13 -0400
Date: Mon, 17 May 2010 22:39:53 +0300
From: Felipe Balbi <me@felipebalbi.com>
To: Felipe Balbi <me@felipebalbi.com>
Cc: James Bottomley <James.Bottomley@suse.de>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Alan Stern <stern@rowland.harvard.edu>, linux-omap@vger.kernel.org,
       "Theodore Ts'o" <tytso@mit.edu>, Geoff Smith <geoffx.smith@intel.com>,
       Brian Swetland <swetland@google.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Tejun Heo <tj@kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Liam Girdwood <lrg@slimlogic.co.uk>, Matthew Garrett <mjg@redhat.com>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 6)
Message-ID: <20100517193952.GC14047@gandalf>
Reply-To: me@felipebalbi.com
References: <Pine.LNX.4.44L0.1005151716180.24645-100000@netrider.rowland.org>
 <87hbm6cz90.fsf@deeprootsystems.com>
 <1274115885.4418.59.camel@mulgrave.site>
 <20100517174647.GA11512@gandalf>
 <1274119179.4418.68.camel@mulgrave.site>
 <20100517181252.GA14260@gandalf>
 <1274124267.4418.149.camel@mulgrave.site>
 <20100517193840.GB14047@gandalf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100517193840.GB14047@gandalf>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

On Mon, May 17, 2010 at 10:38:40PM +0300, Felipe Balbi wrote:
> that's a whole other story. Hardware issues are things which in 99.999%
> of the cases we can't change. We have to work around them. Software
> bugs, on the other hand, can be fixed much more easily. I'm sure you
> agree with that, don't you ?
> 
> Trying to make a comparisson between hardware bug and software bug is
> simply non-sense in this case.

before you reply saying that most of the problems are firmware bugs, try
to file a bug to any of the usb storage manufacturers and wait for them
to fix. It's virtualy impossible, so let's consider it a problem that
has to be worked around.

-- 
balbi
