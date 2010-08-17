Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757700Ab0HQPZ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 11:25:28 -0400
Received: from THUNK.ORG ([69.25.196.29]:56432 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757634Ab0HQPZV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 11:25:21 -0400
Date: Tue, 17 Aug 2010 11:25:01 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: paulmck@linux.vnet.ibm.com, Pavel Machek <pavel@ucw.cz>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Felipe Contreras <felipe.contreras@gmail.com>, david@lang.hm,
        Brian Swetland <swetland@google.com>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, mjg59@srcf.ucam.org, florian@mickler.org,
        rjw@sisk.pl, stern@rowland.harvard.edu, peterz@infradead.org,
        tglx@linutronix.de, menage@google.com, david-b@pacbell.net,
        James.Bottomley@suse.de, swmike@swm.pp.se, galibert@pobox.com,
        dipankar@in.ibm.com
Subject: Re: Attempted summary of suspend-blockers LKML thread, take three
Message-ID: <20100817152501.GH21182@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Arjan van de Ven <arjan@infradead.org>, paulmck@linux.vnet.ibm.com,
	Pavel Machek <pavel@ucw.cz>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Felipe Contreras <felipe.contreras@gmail.com>, david@lang.hm,
	Brian Swetland <swetland@google.com>,
	linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
	arve@android.com, mjg59@srcf.ucam.org, florian@mickler.org,
	rjw@sisk.pl, stern@rowland.harvard.edu, peterz@infradead.org,
	tglx@linutronix.de, menage@google.com, david-b@pacbell.net,
	James.Bottomley@suse.de, swmike@swm.pp.se, galibert@pobox.com,
	dipankar@in.ibm.com
References: <20100811222854.GJ2516@linux.vnet.ibm.com>
 <AANLkTimahmGikeai8QnAxCy45deT00-6T7h-eA-NqL4G@mail.gmail.com>
 <20100812010612.GL2516@linux.vnet.ibm.com>
 <AANLkTinVV1NVHFPeO0p_e2pCtNwTNB932q9tbu9MMD3_@mail.gmail.com>
 <20100812034435.GA7403@linux.vnet.ibm.com>
 <20100813115751.3bbbafbd@lxorguk.ukuu.org.uk>
 <20100813152912.GE2511@linux.vnet.ibm.com>
 <20100814073843.GA27430@elf.ucw.cz>
 <20100814151048.GA2461@linux.vnet.ibm.com>
 <20100814095351.6a996187@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100814095351.6a996187@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 14, 2010 at 09:53:51AM -0700, Arjan van de Ven wrote:
> however I think you're making an assumption that there is a
> real difference between a deep idle state and "off"....
> 
> For modern x86 hardware, that assumption isn't really valid.
> (other than a very very small sram that stores register content in the
> idle case)

This is more of CPU statement than a chipset or laptop/device-wide
statement, correct?

If "hardware" applies to the entire laptop, how "modern" is "modern"?

						- Ted
