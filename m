Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693Ab0ETI5P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 04:57:15 -0400
Received: from ns1.siteground211.com ([209.62.36.12]:48764 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759Ab0ETI5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 04:57:12 -0400
Date: Thu, 20 May 2010 11:57:40 +0300
From: Felipe Balbi <me@felipebalbi.com>
To: Florian Mickler <florian@mickler.org>
Cc: felipe.balbi@nokia.com, ext James Bottomley <James.Bottomley@suse.de>,
       "me@felipebalbi.com" <me@felipebalbi.com>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "Theodore Ts'o" <tytso@mit.edu>, Geoff Smith <geoffx.smith@intel.com>,
       Brian Swetland <swetland@google.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Tejun Heo <tj@kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Liam Girdwood <lrg@slimlogic.co.uk>, Matthew Garrett <mjg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 6)
Message-ID: <20100520085739.GB14584@gandalf>
Reply-To: me@felipebalbi.com
References: <1274119179.4418.68.camel@mulgrave.site>
 <20100517181252.GA14260@gandalf>
 <1274124267.4418.149.camel@mulgrave.site>
 <20100517193840.GB14047@gandalf>
 <20100517193952.GC14047@gandalf>
 <1274125775.4418.182.camel@mulgrave.site>
 <20100518064022.GA6522@nokia.com>
 <1274191188.10304.5.camel@mulgrave.site>
 <20100519065934.GH12879@nokia.com>
 <20100520071528.494c38e4@schatten.dmk.lab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100520071528.494c38e4@schatten.dmk.lab>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 20, 2010 at 07:15:28AM +0200, Florian Mickler wrote:
> But with that, you still shift the burden of exchanging that app with
> an feature-equivalent non-broken version to the user. 
> which is not user friendly and not necessary if you have a "smart"
> enough kernel.

and _without that_, you shift the burden of having a working power
management completely into the kernel. Forcing the kernel to deal with
completely broken apps. What will happen is that apps developers won't
boder thinking about power consumption since the kernel is "smart"
enough to "fix" their mess.

To me that's much bigger burden to the kernel than the other option is
to apps.

-- 
balbi
