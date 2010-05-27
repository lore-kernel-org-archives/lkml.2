Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932953Ab0E0RxO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 13:53:14 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42235 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759331Ab0E0RxM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 13:53:12 -0400
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
From: Peter Zijlstra <peterz@infradead.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       Thomas Gleixner <tglx@linutronix.de>, Paul@smtp1.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <Pine.LNX.4.44L0.1005271344040.3239-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1005271344040.3239-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 27 May 2010 19:52:59 +0200
Message-ID: <1274982779.27810.5708.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-27 at 13:44 -0400, Alan Stern wrote:

> You close your laptop's lid and throw the machine into a backpack.  At 
> that time you want it to suspend even though it may not be idle.
> 
> > We've been trying to tell you you don't need that.
> 
> And I'm trying to tell you that you do.

Shall we henceforth stop confusing forced suspend for laptops and
powersaving a running system?
