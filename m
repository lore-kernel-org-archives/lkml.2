Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649Ab1JJH4K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 03:56:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58777 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751825Ab1JJH4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 03:56:08 -0400
Date: Mon, 10 Oct 2011 09:54:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <JBeulich@suse.com>
Cc: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Matt Fleming <matt@console-pimps.org>, Rui Zhang <rui.zhang@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Avi Kivity <avi@redhat.com>,
        Matthew Garrett <mjg@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        johnstultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] x86: Don't recursively acquire rtc_lock
Message-ID: <20111010075424.GA31061@elte.hu>
References: <1314720739-28683-1-git-send-email-matt@console-pimps.org>
 <1314721040.3649.4.camel@mfleming-mobl1.ger.corp.intel.com>
 <1317367617.3375.2.camel@mfleming-mobl1.ger.corp.intel.com>
 <20111010064536.GJ32173@elte.hu>
 <4E92B79B020000780005A64F@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E92B79B020000780005A64F@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jan Beulich <JBeulich@suse.com> wrote:

> >>> On 10.10.11 at 08:45, Ingo Molnar <mingo@elte.hu> wrote:
> > * Matt Fleming <matt@console-pimps.org> wrote:
> >> Ping? It's -rc8 and 32-bit EFI machines still don't boot.
> > 
> > Don't know the status of this - Thomas?
> 
> This went into 3.1-rc9 (with your signed-off being last).

Heh, I typoed the search for the commit and thought it's still 
unmerged and there's still some problem left with this patch.

Thanks,

	Ingo
