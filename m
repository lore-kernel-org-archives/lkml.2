Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759293Ab0E0V3J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 17:29:09 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:55088 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757174Ab0E0V3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 17:29:05 -0400
Date: Thu, 27 May 2010 22:28:52 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100527212852.GA9859@srcf.ucam.org>
References: <20100527210808.GB8865@srcf.ucam.org> <Pine.LNX.4.44L0.1005271723200.3239-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1005271723200.3239-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 05:24:28PM -0400, Alan Stern wrote:

> Would it help to divide the application into two processes, one of 
> which receives events and the other does the drawing?

At the point where you're rewriting the application you can just make it 
adhere to our current behavioural standards anyway.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
