Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751329Ab1GERuR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 13:50:17 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:37375 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124Ab1GERuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 13:50:12 -0400
Date: Tue, 5 Jul 2011 18:49:01 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Petr Tesarik <ptesarik@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@redhat.com>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>,
        x86@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-ia64@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
        Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 00/10] Enhance /dev/mem to allow read/write of
 arbitrary physical addresses
Message-ID: <20110705174901.GA30531@srcf.ucam.org>
References: <201106171038.25988.ptesarik@suse.cz>
 <201107012134.45881.ptesarik@suse.cz>
 <20110701195629.GA19057@elte.hu>
 <201107012244.57593.ptesarik@suse.cz>
 <20110703194618.GB27022@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110703194618.GB27022@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 03, 2011 at 09:46:18PM +0200, Ingo Molnar wrote:

> But those tables wont be in regular RAM (they will be in ROM or in 
> RAM marked non-RAM in a special way in the e820 tables).
> 
> dmidecode certainly works on Fedora.

I've repeatedly wanted to dump EFI data that's flagged as E820_RESERVED 
above the top of RAM and had to hack the kernel every time. I'm entirely 
in favour of not having to hack the kernel every time.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
