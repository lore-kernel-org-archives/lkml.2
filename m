Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932104Ab0ITTeX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 15:34:23 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:51626 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757135Ab0ITTeU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 15:34:20 -0400
Date: Mon, 20 Sep 2010 12:34:17 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [Bug #16537] TREE_RCU hangs at boot
Message-ID: <20100920193417.GG2408@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <QnCvudbe2FD.A.XiE.DgSjMB@chimera>
 <p44oKaOqEDM.A.AeF.EhSjMB@chimera>
 <20100920182626.GE2408@linux.vnet.ibm.com>
 <201009202120.36708.eike-kernel@sf-tec.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201009202120.36708.eike-kernel@sf-tec.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 20, 2010 at 09:20:27PM +0200, Rolf Eike Beer wrote:
> Paul E. McKenney wrote:
> > On Sun, Sep 12, 2010 at 09:08:42PM +0200, Rafael J. Wysocki wrote:
> > > This message has been generated automatically as a part of a report
> > > of regressions introduced between 2.6.34 and 2.6.35.
> > > 
> > > The following bug entry is on the current list of known regressions
> > > introduced between 2.6.34 and 2.6.35.  Please verify if it still should
> > > be listed and let the tracking team know (either way).
> > > 
> > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16537
> > > Subject		: TREE_RCU hangs at boot
> > > Submitter	: Rolf Eike Beer <eike-kernel@sf-tec.de>
> > > Date		: 2010-08-07 12:18 (37 days old)
> > > Handled-By	: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > 
> > I cannot reproduce this.  The function that is claimed to hang contains
> > only printk()s.  I have asked the guys who can actually reproduce it
> > to try a later kernel, and will let you know how this goes.
> > 
> > If you cannot trust printk(), who can you trust?  ;-)
> 
> I suspect that it is related to:
> 
> http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.35.y.git;a=commit;h=5a8477871f0b45664eedfa352c3942093408a169
> 
> I'll try to test plain 2.6.35 with this patch and see it this works.

That would explain my utter failure to reproduce this bug -- I don't have
a PA-RISC system.  ;-)

							Thanx, Paul
