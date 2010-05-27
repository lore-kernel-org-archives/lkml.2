Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434Ab0E0WoK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 18:44:10 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50282 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753119Ab0E0WoH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 18:44:07 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Date: Fri, 28 May 2010 00:45:32 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rjw; KDE/4.3.5; x86_64; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Stern <stern@rowland.harvard.edu>, Paul@smtp1.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
References: <Pine.LNX.4.44L0.1005271253240.3239-100000@iolanthe.rowland.org> <20100527190515.08be091a@lxorguk.ukuu.org.uk> <20100527181533.GH3543@srcf.ucam.org>
In-Reply-To: <20100527181533.GH3543@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005280045.32571.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 May 2010, Matthew Garrett wrote:
> On Thu, May 27, 2010 at 07:05:15PM +0100, Alan Cox wrote:
> 
> > I'd prefer we avoided mixing them up. Everyone seems fairly happy with
> > the current operator ordered suspend behaviour I believe ?
> 
> No. The current mechanism can lose wakeup events.

As long as the operator agrees to lose wakeup events occasionally, which is
the case at least 99% of the time, there's nothing wrong with that IMO.

Rafael
