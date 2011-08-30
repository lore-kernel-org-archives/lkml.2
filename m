Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477Ab1H3Ppv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 11:45:51 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:35278 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753775Ab1H3Ppt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 11:45:49 -0400
Date: Tue, 30 Aug 2011 16:45:30 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Jan Beulich <JBeulich@novell.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        hpa@linux.intel.com, Avi Kivity <avi@redhat.com>,
        MarceloTosatti <mtosatti@redhat.com>, johnstultz <johnstul@us.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, efi: Don't recursively acquire rtc_lock
Message-ID: <20110830154530.GA28071@srcf.ucam.org>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313486068.3436.116.camel@mfleming-mobl1.ger.corp.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Could this be applied? 32-bit EFI boot is currently completely broken.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
