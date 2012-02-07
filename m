Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724Ab2BGO7m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 09:59:42 -0500
Received: from mga03.intel.com ([143.182.124.21]:20804 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751206Ab2BGO7l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 09:59:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="104136938"
Date: Tue, 7 Feb 2012 06:55:53 -0800
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Richard Farina <sidhayn@gmail.com>, andiry.xu@amd.com,
        linux-kernel@vger.kernel.org
Subject: Re: Question about error from xhci-hcd
Message-ID: <20120207145553.GA5235@xanatos>
References: <4F30BB0B.5060203@gmail.com>
 <4F31275A.8000502@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F31275A.8000502@lwfinger.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 07, 2012 at 07:30:02AM -0600, Larry Finger wrote:
> On 02/06/2012 11:47 PM, Richard Farina wrote:
> >I apologize but I am having the same issue reported in this thread in
> >December
> >
> >[ 5077.573181] xhci_hcd 0000:0a:00.0: ERROR no room on ep ring
> >
> >I saw no resolution on this issue so I figured I'd step up and see if
> >you needed an active tester who could reproduce the issue.
> >
> >I am running Gentoo with a 3.2.2 kernel.  I am able to run any kernel
> >version you need, including random git trees and custom patches.  If you
> >have not solved this yet, please allow me to be your test monkey. If you
> >have solved this already then sorry for harming the signal to noise
> >ratio, I could not a find a later message then the one below.
> 
> Are the "no room" messages triggered by rtl8192cu, or some other driver?

They can be caused by any USB driver that attempts to queue large
transfers or many small transfers.

Sarah Sharp
