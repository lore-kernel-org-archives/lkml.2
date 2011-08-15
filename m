Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941Ab1HOSSK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 14:18:10 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:41915 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752005Ab1HOSSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 14:18:06 -0400
Subject: Re: [PATCH] x86, efi: Don't recursively acquire rtc_lock
From: Matt Fleming <matt@console-pimps.org>
To: Jan Beulich <JBeulich@novell.com>
Cc: Ingo Molnar <mingo@elte.hu>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, hpa@linux.intel.com,
        Avi Kivity <avi@redhat.com>, mjg@redhat.com,
        Marcelo Tosatti <mtosatti@redhat.com>,
        johnstultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
In-Reply-To: <4E429FE30200007800050910@nat28.tlf.novell.com>
References: <4E3C30C602000078000740D5@nat28.tlf.novell.com>
	 <1312810836.10579.127.camel@mfleming-mobl1.ger.corp.intel.com>
	 <4E4009A50200007800050258@nat28.tlf.novell.com>
	 <20110810090330.GF26762@elte.hu>
	 <4E426D4702000078000508B5@nat28.tlf.novell.com>
	 <20110810095140.GB21059@elte.hu>
	 <4E429FE30200007800050910@nat28.tlf.novell.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 15 Aug 2011 19:18:03 +0100
Message-ID: <1313432283.3436.110.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-10 at 14:12 +0100, Jan Beulich wrote:
> Bottom line - the fix here is needed for 32-bit booting only (and
> hence isn't - afaic - as critical as I first thought). But the adjustment
> I'm holding is a necessary one (and I don't even understand why,
> when 32- and 64-bit EFI code got merged, this was left 32-bit only),
> and the NX consolidation change needs to be fixed too (basically as
> a prerequisite).

But the rtc-lock patch is independent and can be merged on its own,
right? Sure the other issues need fixing but there's no sense in holding
up the rtc-lock patch, since with it applied my machine actually boots.

-- 
Matt Fleming, Intel Open Source Technology Center

