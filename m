Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756045Ab0E0Wfj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 18:35:39 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:39919 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754323Ab0E0Wfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 18:35:37 -0400
Date: Thu, 27 May 2010 23:35:12 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       Florian Mickler <florian@mickler.org>,
       Vitaly Wool <vitalywool@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Paul@smtp1.linux-foundation.org, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100527223512.GA11364@srcf.ucam.org>
References: <20100527170740.GA1980@srcf.ucam.org> <1274980391.27810.5552.camel@twins> <20100527171644.GA2468@srcf.ucam.org> <1274980856.27810.5582.camel@twins> <20100527172510.GC2468@srcf.ucam.org> <20100527223751.7af3b5ee@lxorguk.ukuu.org.uk> <20100527213635.GA9916@srcf.ucam.org> <20100527225637.57a336ad@lxorguk.ukuu.org.uk> <20100527220819.GA10602@srcf.ucam.org> <20100527233247.37195656@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100527233247.37195656@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 11:32:47PM +0100, Alan Cox wrote:
> > The kernel performs no explicit notification to userspace. With legacy 
> 
> For a PC ACPI using type device /proc/acpi/events which wakes acpid which
> wakes gnome-power-manager which wakes half the universe

No, there's no explicit /proc/acpi/event notification on resume.

> Do we need a better more generic version of the events files - maybe but
> thats a rather different kettle of fish to suspend blockers.

It's a requirement for any reasonable alternative approach.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
