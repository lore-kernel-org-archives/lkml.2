Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755669Ab1H3QIS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 12:08:18 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:59288 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755592Ab1H3QIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 12:08:04 -0400
Subject: Re: [PATCH] x86, efi: Don't recursively acquire rtc_lock
From: Matt Fleming <matt@console-pimps.org>
To: Matthew Garrett <mjg@redhat.com>
Cc: Jan Beulich <JBeulich@novell.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        hpa@linux.intel.com, Avi Kivity <avi@redhat.com>,
        MarceloTosatti <mtosatti@redhat.com>, johnstultz <johnstul@us.ibm.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110830154530.GA28071@srcf.ucam.org>
References: <4E3C30C602000078000740D5@nat28.tlf.novell.com>
	 <1312810836.10579.127.camel@mfleming-mobl1.ger.corp.intel.com>
	 <4E4009A50200007800050258@nat28.tlf.novell.com>
	 <20110810090330.GF26762@elte.hu>
	 <4E426D4702000078000508B5@nat28.tlf.novell.com>
	 <20110810095140.GB21059@elte.hu>
	 <4E429FE30200007800050910@nat28.tlf.novell.com>
	 <1313432283.3436.110.camel@mfleming-mobl1.ger.corp.intel.com>
	 <4E4A28AE0200007800051605@nat28.tlf.novell.com>
	 <1313486068.3436.116.camel@mfleming-mobl1.ger.corp.intel.com>
	 <20110830154530.GA28071@srcf.ucam.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Aug 2011 17:07:45 +0100
Message-ID: <1314720465.3649.2.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-08-30 at 16:45 +0100, Matthew Garrett wrote:
> Could this be applied? 32-bit EFI boot is currently completely broken.

Thanks for the reminder Matthew, I'll resend this now.

-- 
Matt Fleming, Intel Open Source Technology Center

