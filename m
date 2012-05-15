Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932814Ab2EONQq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 09:16:46 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:51687 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932282Ab2EONQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 09:16:45 -0400
Date: Tue, 15 May 2012 14:16:37 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Jan Beulich <JBeulich@suse.com>
Cc: dannf@dannf.org, mingo@elte.hu, tglx@linutronix.de,
        matt.fleming@linux.intel.com, linux-kernel@vger.kernel.org,
        hpa@zytor.com
Subject: Re: [PATCH, resend] x86: enable rtc-efi
Message-ID: <20120515131637.GA26038@srcf.ucam.org>
References: <4FB263560200007800083CB0@nat28.tlf.novell.com>
 <20120515123811.GA25248@srcf.ucam.org>
 <4FB271860200007800083D21@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FB271860200007800083D21@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2012 at 02:08:54PM +0100, Jan Beulich wrote:

> So how is this driver okay on ia64 then? It's my understanding
> that either it's entirely broken, or should be used universally.
> That's the more that accessing the RTC directly isn't really being
> permitted by the EFI spec (i.e. using this driver really is a
> requirement, not an option).

ia64 is basically never dual booted. If there's an RTC in the ACPI 
tables then it's completely valid to use the legacy RTC.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
