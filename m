Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887Ab1FHUnK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 16:43:10 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:38422 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753501Ab1FHUnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 16:43:08 -0400
Date: Wed, 8 Jun 2011 21:42:44 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jim Bos <jim876@xs4all.nl>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Maarten Lankhorst <m.b.lankhorst@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.39.1 immediately reboots/resets on EFI system
Message-ID: <20110608204244.GA31484@srcf.ucam.org>
References: <20110608192950.GA29235@srcf.ucam.org>
 <4DEFCF1A.9030400@kernel.org>
 <20110608193833.GA29855@srcf.ucam.org>
 <4DEFD220.5040507@kernel.org>
 <20110608195250.GB30256@srcf.ucam.org>
 <4DEFD58D.5060402@kernel.org>
 <20110608200903.GA30694@srcf.ucam.org>
 <4DEFDA4A.9080500@kernel.org>
 <20110608203037.GA31052@srcf.ucam.org>
 <4DEFDD69.7010000@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DEFDD69.7010000@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 08, 2011 at 01:36:57PM -0700, Yinghai Lu wrote:

> or just let bootloader to mark those boot services just like run-time services in e820 table or setupdata?

That was my original approach, but if there's boot services code at the 
top of RAM it means that max_pfn is wrong and it's difficult to recover 
the memory.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
