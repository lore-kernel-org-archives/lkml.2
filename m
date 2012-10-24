Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758651Ab2JXTSh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 15:18:37 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:49191 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756331Ab2JXTSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 15:18:35 -0400
Date: Wed, 24 Oct 2012 12:18:31 -0700
From: Jonathan Nieder <jrnieder@gmail.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Greg KH <gregkh@linuxfoundation.org>, linbao.zhang@hp.com
Subject: Re: [stable 2.6.32..2.6.34] x86, ioapic: initialize
 nr_ioapic_registers early in mp_register_ioapic()
Message-ID: <20121024191831.GB3120@elie.Belkin>
References: <1351102644.6017.72.camel@sbsiddha-desk.sc.intel.com>
 <20121024182546.GB3338@elie.Belkin>
 <1351103872.6017.80.camel@sbsiddha-desk.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351103872.6017.80.camel@sbsiddha-desk.sc.intel.com>
User-Agent: Mutt/1.5.21+51 (9e756d1adb76) (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suresh Siddha wrote:

> commit 4b6b19a1c7302477653d799a53d48063dd53d555

Oh, yuck.  If that commit had changed io_apic_get_redir_entries()'s
name, it would have avoided some trouble.  Thanks for pointing it out.

> Wanted to keep the changes as minimal as possible.

I don't see how this is conceptually simpler than a version that also
removes the nr_ioapic_registers calculation in enable_IO_APIC().

Either way, please do mention 4b6b19a1c730 in the commit message so
others looking at the patch can see the off-by-one that is being
narrowly avoided.  Thanks for your help and patience.

Jonathan
