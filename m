Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755711Ab1HRNEa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 09:04:30 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56508 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397Ab1HRNE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 09:04:29 -0400
Date: Thu, 18 Aug 2011 15:04:24 +0200
From: Tejun Heo <tj@kernel.org>
To: Jan Beulich <JBeulich@novell.com>
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, stable@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i386/bigsmp: eliminate false warnings regarding logical
 APIC ID mismatches
Message-ID: <20110818130424.GC20085@htj.dyndns.org>
References: <4E4D27B40200007800051D40@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E4D27B40200007800051D40@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Jan.

On Thu, Aug 18, 2011 at 01:54:44PM +0100, Jan Beulich wrote:
> Fix this (for the time being, i.e. until x86_32_early_logical_apicid()
> will get removed again, as Tehun says ought to be possible) by
> overriding the previously stored values at the point where the APIC
> driver gets overridden.

Hmmm... how about just removing the WARN_ON() in setup_local_APIC()?
We already don't depend on the value so just overriding it isn't
dangerous at all.

Thanks.

-- 
tejun
