Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699Ab0EQSPb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 14:15:31 -0400
Received: from ns1.siteground211.com ([209.62.36.12]:55141 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693Ab0EQSPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 14:15:30 -0400
Date: Mon, 17 May 2010 21:16:05 +0300
From: Felipe Balbi <me@felipebalbi.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: Felipe Balbi <me@felipebalbi.com>,
       James Bottomley <James.Bottomley@suse.de>,
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
       Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 6)
Message-ID: <20100517181604.GB14260@gandalf>
Reply-To: me@felipebalbi.com
References: <Pine.LNX.4.44L0.1005151716180.24645-100000@netrider.rowland.org>
 <87hbm6cz90.fsf@deeprootsystems.com>
 <1274115885.4418.59.camel@mulgrave.site>
 <20100517174647.GA11512@gandalf>
 <20100517175820.GA29773@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100517175820.GA29773@srcf.ucam.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, May 17, 2010 at 06:58:20PM +0100, Matthew Garrett wrote:
> We know that this problem is mostly uninteresting if your userland is 
> well written. The sad truth is that it's impossible to trust that your 
> userland is well written, and broadly impossible to communicate to users 
> that the reason that their battery life is miserable is because of the 
> applications and not because of the platform. If you don't believe that 
> that's a worthwhile use case to deal with then suspend blockers buy you 
> pretty much nothing. But if you do, then nobody's yet demonstrated 
> another workable way for this to be handled.

don't get me wrong, I have faced similar problems of use time targets
due to ill-behaved applications, we just decided to deal with it with
the help of bugzilla. File a bug to that application and get the
developer to fix it. At least you are teaching the guy to fish. I
understand when you open an AppStore the problem grows bigger but, like
I replied to James, build an automated system to check average power
usage on the SDK and AppStore acceptance process and you get developers
to fix their apps before they reach the device.

-- 
balbi
