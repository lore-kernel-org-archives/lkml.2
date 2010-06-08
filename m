Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621Ab0FHHcr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 03:32:47 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:58934 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413Ab0FHHcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 03:32:45 -0400
Date: Tue, 8 Jun 2010 16:32:12 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frans Pop <elendil@planet.nl>, Dirk Hohndel <hohndel@infradead.org>,
       Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH, v2] kbuild: Improve version string logic - two for the price of one - No thanks
Message-ID: <20100608073211.GB13191@linux-sh.org>
References: <20091006173508.GA4786@elte.hu> <20091012195733.GA7351@elte.hu> <4C0D29DE.6050602@panasas.com> <alpine.DEB.2.00.1006071242510.30389@chino.kir.corp.google.com> <4C0DDAA6.8080002@panasas.com> <alpine.DEB.2.00.1006072311170.31780@chino.kir.corp.google.com> <20100608063419.GF6376@linux-sh.org> <4C0DE5AC.1090204@panasas.com> <4C0DEE57.1070505@panasas.com> <4C0DEF92.5000601@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C0DEF92.5000601@panasas.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 08, 2010 at 10:21:54AM +0300, Boaz Harrosh wrote:
> On 06/08/2010 10:16 AM, Boaz Harrosh wrote:
> OK I get it above should be:
> [my-tree] $ echo "-my_tree" > localversion-my_tree
> 
> But now I get DEPMOD 2.6.35-rc2-my_tree+
> 
> Please fix it so if localversion* is present then the plus is
> removed. And the git is not inspected
> 
How is that a 'fix'? If I'm using localversion* and have people sending
me bug reports, I still do want to see the git ID. The + thing in this
context might not have any meaning since the 2.6.35-rc2 that you've
tagged for your tree and the release one could wildly differ, but that's
more of an argument against the + thing existing at all than anything
else.

Whether having LOCALVERSION_AUTO be compulsory is a good idea or not is
another matter entirely, the localversion* semantics are pretty
clear-cut.
