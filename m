Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011Ab0E1ODB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 10:03:01 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:46241 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601Ab0E1OC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 10:02:59 -0400
Date: Fri, 28 May 2010 15:02:37 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100528140237.GD25798@srcf.ucam.org>
References: <Pine.LNX.4.44L0.1005271730180.3239-100000@iolanthe.rowland.org> <20100527230806.4deb6de3@lxorguk.ukuu.org.uk> <20100527220949.GB10602@srcf.ucam.org> <20100527232357.6d14fdb2@lxorguk.ukuu.org.uk> <AANLkTil6Bo7qZltbLzHJjIDyruKHFQEURpe5LPJEpTws@mail.gmail.com> <20100528101755.7b5f6b8a@lxorguk.ukuu.org.uk> <AANLkTilYHKKmQePBGW3LVLjUZy7HXHQku2Iub-LWGBm6@mail.gmail.com> <20100528132138.2d802d77@lxorguk.ukuu.org.uk> <20100528123110.GA23930@srcf.ucam.org> <20100528145420.1c06e4a3@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100528145420.1c06e4a3@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 28, 2010 at 02:54:20PM +0100, Alan Cox wrote:

> I am not convinced at this point. If the app gets put into the important
> group by the driver then you don't need to poke a policy manager.

Ok, I think I've misunderstood you. You're actually saying that only 
applications that are trusted to behave well are allowed to receive 
wakeup events? Yes, that makes implementation significantly easier. If 
that maps reasonably well onto the existing Android application space, 
it may even be an acceptable compromise.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
