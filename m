Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911Ab2EUNNl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 09:13:41 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:56333 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755290Ab2EUNNj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 09:13:39 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bojan Smojver <bojan@rexursive.com>
Subject: Re: [PATCH]: In kernel hibernation, suspend to both
Date: Mon, 21 May 2012 15:18:38 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc7+; KDE/4.6.0; x86_64; ; )
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>, bp@alien8.de
References: <Pine.LNX.4.44L0.1205132212070.5628-100000@netrider.rowland.org> <1337120605.2543.1.camel@shrek.rexursive.com> <1337575107.1647.56.camel@shrek.rexursive.com>
In-Reply-To: <1337575107.1647.56.camel@shrek.rexursive.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201205211518.39137.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, May 21, 2012, Bojan Smojver wrote:
> On Wed, 2012-05-16 at 08:23 +1000, Bojan Smojver wrote:
> > On Tue, 2012-05-15 at 19:42 +0200, Rafael J. Wysocki wrote:
> > > which I suppose is what the first Bojan's patch did, right? 
> > 
> > Correct. No extra notifiers were sent, so whatever hibernation code did
> > was it.
> > 
> > That patch is here:
> > 
> > http://marc.info/?l=linux-kernel&m=133651588229850&w=2
> 
> Now that 3.4 is out, just a ping to have this in the 3.5 queue.

No, I'm not going to put that into 3.5, sorry.  It can go into 3.6.

Thanks,
Rafael
