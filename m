Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932522Ab2EOMi3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 08:38:29 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:54141 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757589Ab2EOMi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 08:38:28 -0400
Date: Tue, 15 May 2012 13:38:12 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Jan Beulich <JBeulich@suse.com>
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, dannf@dannf.org,
        matt.fleming@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH, resend] x86: enable rtc-efi
Message-ID: <20120515123811.GA25248@srcf.ucam.org>
References: <4FB263560200007800083CB0@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FB263560200007800083CB0@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2012 at 01:08:22PM +0100, Jan Beulich wrote:
> Besides a Kconfig change this just requires creating a corresponding
> platform device.

I don't think this is a good idea yet - we completely fail to perform 
timezone handling with the EFI clock, which violates platform 
expectations. We should fix that up first.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
