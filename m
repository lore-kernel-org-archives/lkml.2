Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755153Ab2DQCEu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 22:04:50 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36819 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892Ab2DQCEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 22:04:48 -0400
Date: Mon, 16 Apr 2012 21:04:33 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Robert Scott <bugs@humanleg.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Kevin Tian <kevin.tian@intel.com>,
        Fengzhe Zhang <fengzhe.zhang@intel.com>, mingo@redhat.com,
        hpa@zytor.com, Ian Campbell <Ian.Campbell@eu.citrix.com>,
        JBeulich@novell.com, xen-devel@lists.xensource.com,
        Lars Boegild Thomsen <lth@cow.dk>,
        e568b31a443d@6cc2cce7af2d.anonbox.net,
        "Liu, Chuansheng" <chuansheng.liu@intel.com>
Subject: Re: [regression] Ideapad S10-3 does not wake up from suspend
Message-ID: <20120417020433.GA15848@burratino>
References: <625BA99ED14B2D499DC4E29D8138F1505C8ED7F7E3@shsmsx502.ccr.corp.intel.com>
 <20110829041532.GA22087@elie.gateway.2wire.net>
 <20120415140628.GA4536@burratino>
 <201204161905.13260.bugs@humanleg.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201204161905.13260.bugs@humanleg.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Scott wrote:
> On Sunday 15 April 2012, Jonathan Nieder wrote:

>> Lars, Robert, anon: can you try 3.4-rc2 or newer and let us know how
>> it goes?  I suspect v3.4-rc2~24^2~4 ("x86: Preserve lazy irq disable
>> semantics in fixup_irqs()") will fix this.
>
> Hmm, no, 3.4-rc2 seems to produce the same results I'm afraid.

Alas.  Does suspend-to-disk ("echo disk >/sys/power/state") have the
same problem?  Can you get a log of the failure with
"no_console_suspend" appended to the kernel command line, for example
with a serial console or netconsole?

If someone has time to go through the steps in
"Documentation/power/basic-pm-debugging.txt", that would also be useful.

Thanks, and sorry to take so long to get to this.

Sincerely,
Jonathan
