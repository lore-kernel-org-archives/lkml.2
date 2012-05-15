Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932852Ab2EONk0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 09:40:26 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:60981 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932729Ab2EONkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 09:40:25 -0400
Date: Tue, 15 May 2012 14:40:17 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Jan Beulich <JBeulich@suse.com>
Cc: dannf@dannf.org, mingo@elte.hu, tglx@linutronix.de,
        matt.fleming@linux.intel.com, linux-kernel@vger.kernel.org,
        hpa@zytor.com
Subject: Re: [PATCH, resend] x86: enable rtc-efi
Message-ID: <20120515134017.GA26656@srcf.ucam.org>
References: <4FB263560200007800083CB0@nat28.tlf.novell.com>
 <20120515123811.GA25248@srcf.ucam.org>
 <4FB271860200007800083D21@nat28.tlf.novell.com>
 <20120515131637.GA26038@srcf.ucam.org>
 <4FB274CD0200007800083D41@nat28.tlf.novell.com>
 <20120515132631.GA26298@srcf.ucam.org>
 <4FB277F20200007800083D5B@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FB277F20200007800083D5B@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2012 at 02:36:18PM +0100, Jan Beulich wrote:
> >>> On 15.05.12 at 15:26, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> > On Tue, May 15, 2012 at 02:22:53PM +0100, Jan Beulich wrote:
> > 
> >> I don't think so - the two drivers could end up manipulating the
> >> same piece of hardware, without synchronization. rtc-cmos
> >> really should bail when loaded on an EFI-enabled system.
> > 
> > That's why we're taking the rtc lock.
> 
> Which is completely bogus imo (i.e. it should be a goal to remove
> this).

Sure, once we've fixed the EFI clock and made sure that there's no 
lingering accesses to the old nvram.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
