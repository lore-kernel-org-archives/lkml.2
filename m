Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756719Ab0LSQip (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 11:38:45 -0500
Received: from cantor.suse.de ([195.135.220.2]:36889 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753289Ab0LSQin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 11:38:43 -0500
Date: Sun, 19 Dec 2010 08:34:27 -0800
From: Greg KH <gregkh@suse.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Bug #22562] Regression in 2.6.37-rc1 - logs spammed with
 "unable to enumerate USB port" - bisected to commit 3df7169e
Message-ID: <20101219163427.GA22994@suse.de>
References: <wNJKqSoEutL.A.lKD.odfDNB@chimera>
 <6Ue85L6pKCJ.A.MoF.2ffDNB@chimera>
 <4D0E2DD7.4060607@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D0E2DD7.4060607@lwfinger.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 19, 2010 at 10:07:51AM -0600, Larry Finger wrote:
> On 12/19/2010 06:34 AM, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a summary report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.36.  Please verify if it still should be listed and let the tracking team
> > know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=22562
> > Subject		: Regression in 2.6.37-rc1 - logs spammed with "unable to enumerate USB port" - bisected to commit 3df7169e
> > Submitter	: Larry Finger <Larry.Finger@lwfinger.net>
> > Date		: 2010-11-02 22:32 (48 days old)
> > First-Bad-Commit: http://git.kernel.org/linus/3df7169e73fc1d71a39cffeacc969f6840cdf52b
> > Message-ID	: <4CD09166.4060202@lwfinger.net>
> > References	: http://marc.info/?l=linux-kernel&m=128873713207906&w=2
> 
> Yes, this regression is still present in 2.6.37-rc6. I'm trying to debug this
> with very little success.

To be fair, you seem to have the only machine with this problem :(
