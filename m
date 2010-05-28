Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756836Ab0E1LpU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 07:45:20 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:53747 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754553Ab0E1LpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 07:45:18 -0400
Date: Fri, 28 May 2010 12:45:04 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100528114504.GB22947@srcf.ucam.org>
References: <20100527210808.GB8865@srcf.ucam.org> <Pine.LNX.4.44L0.1005271723200.3239-100000@iolanthe.rowland.org> <20100527212852.GA9859@srcf.ucam.org> <1275040988.20005.29.camel@thorin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275040988.20005.29.camel@thorin>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 28, 2010 at 12:03:08PM +0200, Bernd Petrovitsch wrote:
> On Don, 2010-05-27 at 22:28 +0100, Matthew Garrett wrote:
> > At the point where you're rewriting the application you can just make it 
> > adhere to our current behavioural standards anyway.
> 
> Thank you for confirming that the so-called "feature" is just there to
> make apps work in some area that are crappy anyways - and God knows in
> which other areas they are crappy too.

Kind of like memory protection, really. Or preemptive multitasking. Or 
many things that the kernel does to prevent badly written applications 
from interfering with other applications or the user's experience.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
