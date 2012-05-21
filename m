Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756402Ab2EUISw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 04:18:52 -0400
Received: from mail.skyhub.de ([78.46.96.112]:35435 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756218Ab2EUISr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 04:18:47 -0400
Date: Mon, 21 May 2012 10:18:43 +0200
From: Borislav Petkov <bp@alien8.de>
To: Bojan Smojver <bojan@rexursive.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]: In kernel hibernation, suspend to both
Message-ID: <20120521081843.GC1729@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Bojan Smojver <bojan@rexursive.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	"Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Linux PM list <linux-pm@vger.kernel.org>,
	Kernel development list <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.1205132212070.5628-100000@netrider.rowland.org>
 <1337039996.1628.9.camel@shrek.rexursive.com>
 <4FB269BF.3090801@linux.vnet.ibm.com>
 <201205151942.36335.rjw@sisk.pl>
 <1337120605.2543.1.camel@shrek.rexursive.com>
 <1337575107.1647.56.camel@shrek.rexursive.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1337575107.1647.56.camel@shrek.rexursive.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 02:38:27PM +1000, Bojan Smojver wrote:
> > http://marc.info/?l=linux-kernel&m=133651588229850&w=2
> 
> Now that 3.4 is out, just a ping to have this in the 3.5 queue.

Is this the final thing you guys agree on which should be tested more?

Thanks.

-- 
Regards/Gruss,
    Boris.
