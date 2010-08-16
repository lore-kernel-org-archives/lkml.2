Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679Ab0HPQKE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 12:10:04 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:59954 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390Ab0HPQKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 12:10:03 -0400
Date: Mon, 16 Aug 2010 17:09:11 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: paulmck@linux.vnet.ibm.com, Pavel Machek <pavel@ucw.cz>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        "Ted Ts'o" <tytso@mit.edu>, david@lang.hm,
        Brian Swetland <swetland@google.com>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, florian@mickler.org, rjw@sisk.pl,
        stern@rowland.harvard.edu, peterz@infradead.org, tglx@linutronix.de,
        menage@google.com, david-b@pacbell.net, James.Bottomley@suse.de,
        swmike@swm.pp.se, galibert@pobox.com, dipankar@in.ibm.com
Subject: Re: Attempted summary of suspend-blockers LKML thread, take three
Message-ID: <20100816160911.GA3479@srcf.ucam.org>
References: <20100811222854.GJ2516@linux.vnet.ibm.com> <AANLkTimahmGikeai8QnAxCy45deT00-6T7h-eA-NqL4G@mail.gmail.com> <20100812010612.GL2516@linux.vnet.ibm.com> <AANLkTinVV1NVHFPeO0p_e2pCtNwTNB932q9tbu9MMD3_@mail.gmail.com> <20100812034435.GA7403@linux.vnet.ibm.com> <20100813115751.3bbbafbd@lxorguk.ukuu.org.uk> <20100813152912.GE2511@linux.vnet.ibm.com> <20100814073843.GA27430@elf.ucw.cz> <20100814151048.GA2461@linux.vnet.ibm.com> <20100814095351.6a996187@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100814095351.6a996187@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 14, 2010 at 09:53:51AM -0700, Arjan van de Ven wrote:

> they tend to go "off".
> 
> however I think you're making an assumption that there is a
> real difference between a deep idle state and "off"....
> 
> For modern x86 hardware, that assumption isn't really valid.
> (other than a very very small sram that stores register content in the
> idle case)

Really? I thought the TSC stopped in suspend. Does having a package go 
into C6 mean that the RAM goes into self-refresh?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
