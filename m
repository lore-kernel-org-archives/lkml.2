Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932680Ab2EOMvH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 08:51:07 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:46429 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932620Ab2EOMvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 08:51:06 -0400
Date: Tue, 15 May 2012 13:50:31 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: Jan Beulich <JBeulich@suse.com>, mingo@elte.hu, tglx@linutronix.de,
        hpa@zytor.com, dannf@dannf.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH, resend] x86: enable rtc-efi
Message-ID: <20120515125031.GC25248@srcf.ucam.org>
References: <4FB263560200007800083CB0@nat28.tlf.novell.com>
 <20120515123811.GA25248@srcf.ucam.org>
 <1337085677.27692.19.camel@mfleming-mobl1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337085677.27692.19.camel@mfleming-mobl1.ger.corp.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2012 at 01:41:17PM +0100, Matt Fleming wrote:

> Last time I spoke to Thomas about this, the impression I got was that
> the kernel didn't need to worry about handling the timezone for this
> case.
> 
> Unless I'm missing something?

We always pass EFI_UNSPECIFIED_TIMEZONE which is really not how this is 
meant to work.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
