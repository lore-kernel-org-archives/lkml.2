Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935474Ab2JXSZw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 14:25:52 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60869 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935246Ab2JXSZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 14:25:50 -0400
Date: Wed, 24 Oct 2012 11:25:46 -0700
From: Jonathan Nieder <jrnieder@gmail.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Greg KH <gregkh@linuxfoundation.org>, linbao.zhang@hp.com
Subject: Re: [stable 2.6.32..2.6.34] x86, ioapic: initialize
 nr_ioapic_registers early in mp_register_ioapic()
Message-ID: <20121024182546.GB3338@elie.Belkin>
References: <1351102644.6017.72.camel@sbsiddha-desk.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351102644.6017.72.camel@sbsiddha-desk.sc.intel.com>
User-Agent: Mutt/1.5.21+51 (9e756d1adb76) (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Suresh,

Suresh Siddha wrote:

[...]
> This problem doesn't happen with more recent kernels and closer
> look at the 2.6.32 kernel shows that the code which masks
> the IO-APIC RTE's is not working as expected as the nr_ioapic_registers
> for each IO-APIC is not yet initialized at this point. In the later
> kernels we initialize nr_ioapic_registers much before and
> everything works as expected.
>
> For 2.6.[32..34] kernels, fix this issue by initializing
> nr_ioapic_registers early in mp_register_ioapic()
>
> Relevant upstream commit info:
>
> commit 7716a5c4ff5f1f3dc5e9edcab125cbf7fceef0af

Why not cherry-pick 7716a5c4ff5 in full?

Curious,
Jonathan
