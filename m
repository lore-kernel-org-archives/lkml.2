Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010Ab0FAKu7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 06:50:59 -0400
Received: from www.tglx.de ([62.245.132.106]:43946 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754934Ab0FAKu4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 06:50:56 -0400
Date: Tue, 1 Jun 2010 12:50:01 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Neil Brown <neilb@suse.de>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       =?ISO-8859-15?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "Paul@smtp1.linux-foundation.org" <Paul@smtp1.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
In-Reply-To: <20100601122012.1edeaf48@notabene.brown>
Message-ID: <alpine.LFD.2.00.1006011243350.2933@localhost.localdomain>
References: <Pine.LNX.4.44L0.1005271303190.3239-100000@iolanthe.rowland.org> <201006010005.19554.rjw@sisk.pl> <20100601090023.788cabf4@notabene.brown> <201006010232.20263.rjw@sisk.pl> <20100601113309.609349fd@notabene.brown> <alpine.LFD.2.00.1006010340160.2933@localhost.localdomain>
 <20100601122012.1edeaf48@notabene.brown>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Jun 2010, Neil Brown wrote:
> 
> I think you have acknowledged that there is a race with suspend - thanks.
> Next step was "can it be closed".
> You seem to suggest that it can, but you describe it as a "work around"
> rather than a "bug fix"...
> 
> Do you agree that the race is a "bug", and therefore it is appropriate to
> "fix" it assuming an acceptable fix can be found (which I think it can)?

If we can fix it, yes we definitely should do and not work around it.
 
Thanks,

	tglx
