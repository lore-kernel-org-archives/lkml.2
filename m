Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933274Ab0E0WKH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 18:10:07 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:38405 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932788Ab0E0WKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 18:10:02 -0400
Date: Thu, 27 May 2010 23:09:49 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100527220949.GB10602@srcf.ucam.org>
References: <20100527222514.0a1710bf@lxorguk.ukuu.org.uk> <Pine.LNX.4.44L0.1005271730180.3239-100000@iolanthe.rowland.org> <20100527230806.4deb6de3@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100527230806.4deb6de3@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 11:08:06PM +0100, Alan Cox wrote:

> This is I believe robust (and has been implemented on some non x86
> boxes). It depends on not forcing running tasks into suspend. That is the
> key.

We've already established that ACPI systems require us to force running 
tasks into suspend. How do we avoid the race in that situation?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
