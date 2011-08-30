Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014Ab1H3S1L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 14:27:11 -0400
Received: from mga01.intel.com ([192.55.52.88]:6502 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755958Ab1H3S1H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 14:27:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,303,1312182000"; 
   d="scan'208";a="46535401"
Message-ID: <4E5D2B79.4040407@linux.intel.com>
Date: Tue, 30 Aug 2011 11:27:05 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
Organization: Intel Open Source Technology Center
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Matt Fleming <matt@console-pimps.org>
CC: Matthew Garrett <mjg@redhat.com>, Jan Beulich <JBeulich@novell.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Avi Kivity <avi@redhat.com>, MarceloTosatti <mtosatti@redhat.com>,
        johnstultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, efi: Don't recursively acquire rtc_lock
References: <4E3C30C602000078000740D5@nat28.tlf.novell.com>  <1312810836.10579.127.camel@mfleming-mobl1.ger.corp.intel.com>  <4E4009A50200007800050258@nat28.tlf.novell.com>  <20110810090330.GF26762@elte.hu>  <4E426D4702000078000508B5@nat28.tlf.novell.com>  <20110810095140.GB21059@elte.hu>  <4E429FE30200007800050910@nat28.tlf.novell.com>  <1313432283.3436.110.camel@mfleming-mobl1.ger.corp.intel.com>  <4E4A28AE0200007800051605@nat28.tlf.novell.com>  <1313486068.3436.116.camel@mfleming-mobl1.ger.corp.intel.com>  <20110830154530.GA28071@srcf.ucam.org> <1314720465.3649.2.camel@mfleming-mobl1.ger.corp.intel.com>
In-Reply-To: <1314720465.3649.2.camel@mfleming-mobl1.ger.corp.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30/2011 09:07 AM, Matt Fleming wrote:
> On Tue, 2011-08-30 at 16:45 +0100, Matthew Garrett wrote:
>> Could this be applied? 32-bit EFI boot is currently completely broken.
> 
> Thanks for the reminder Matthew, I'll resend this now.

Point me to the current version and I'll put it in.

	-hpa


