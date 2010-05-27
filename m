Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932779Ab0E0Res (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 13:34:48 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60863 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932535Ab0E0Req convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 13:34:46 -0400
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
From: Peter Zijlstra <peterz@infradead.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Alan Stern <stern@rowland.harvard.edu>, Paul@smtp1.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <20100527173118.GE2468@srcf.ucam.org>
References: <Pine.LNX.4.44L0.1005271253240.3239-100000@iolanthe.rowland.org>
	 <alpine.LFD.2.00.1005271915540.3032@localhost.localdomain>
	 <20100527173118.GE2468@srcf.ucam.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 27 May 2010 19:34:40 +0200
Message-ID: <1274981680.27810.5636.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-27 at 18:31 +0100, Matthew Garrett wrote:

> Even if we could use suspend-via-deep-idle-state on PCs, 

( see Alan Cox's argument on PCs )

> we still need to be able to enter suspend while the system isn't idle.

_WHY_!?

We've been trying to tell you you don't need that.
