Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932357Ab2EYPY2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 11:24:28 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:59140 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757226Ab2EYPY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 11:24:27 -0400
Date: Fri, 25 May 2012 16:24:14 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Jan Beulich <JBeulich@suse.com>
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
        matt.fleming@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86-64: use EFI to deal with platform wall clock
Message-ID: <20120525152414.GA16704@srcf.ucam.org>
References: <4FBFBF5F020000780008637F@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FBFBF5F020000780008637F@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, 2012 at 04:20:31PM +0100, Jan Beulich wrote:

> Also make the two EFI functions in question here static - they're not
> being referenced elsewhere.

Looks good, but should we also be changing get_time to return in UTC? 
What are the expected semantics for get_wallclock?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
