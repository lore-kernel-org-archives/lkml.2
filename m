Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756325Ab0E1Llp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 07:41:45 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:53697 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754527Ab0E1Llo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 07:41:44 -0400
Date: Fri, 28 May 2010 12:41:23 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: tytso@mit.edu, Alan Stern <stern@rowland.harvard.edu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100528114123.GA22947@srcf.ucam.org>
References: <20100527222514.0a1710bf@lxorguk.ukuu.org.uk> <Pine.LNX.4.44L0.1005271730180.3239-100000@iolanthe.rowland.org> <20100527230806.4deb6de3@lxorguk.ukuu.org.uk> <20100527220949.GB10602@srcf.ucam.org> <20100527232357.6d14fdb2@lxorguk.ukuu.org.uk> <20100527223605.GB11364@srcf.ucam.org> <20100527235546.09f3ce8a@lxorguk.ukuu.org.uk> <20100528043114.GC26177@thunk.org> <20100528103713.0a7952d9@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100528103713.0a7952d9@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 28, 2010 at 10:37:13AM +0100, Alan Cox wrote:

> The other vendors appear to be managing nicely without magic blockers. I
> conjecture therefore there are other solutions.

Actually, no. A badly behaved application will kill the N900's battery 
life. Nobody else has "managed nicely" - they've just made life harder 
for application developers and users, which may have something to do 
with the relative levels of market adoption of Maemo and Android. I'm 
not aware of any form of resource management framework in MeeGo either, 
so as far as I know it'll have exactly the same problem.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
