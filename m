Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494Ab1JJHPO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 03:15:14 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:5740 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358Ab1JJHPN convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@suse.com:9:1>);
	Mon, 10 Oct 2011 03:15:13 -0400
Message-Id: <4E92B79B020000780005A64F@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Mon, 10 Oct 2011 08:15:07 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: "Jeremy Fitzhardinge" <jeremy.fitzhardinge@citrix.com>,
        "Matt Fleming" <matt@console-pimps.org>,
        "Rui Zhang" <rui.zhang@intel.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>, "Avi Kivity" <avi@redhat.com>,
        "Matthew Garrett" <mjg@redhat.com>,
        "Marcelo Tosatti" <mtosatti@redhat.com>,
        "johnstultz" <johnstul@us.ibm.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] x86: Don't recursively acquire rtc_lock
References: <1314720739-28683-1-git-send-email-matt@console-pimps.org>
 <1314721040.3649.4.camel@mfleming-mobl1.ger.corp.intel.com>
 <1317367617.3375.2.camel@mfleming-mobl1.ger.corp.intel.com>
 <20111010064536.GJ32173@elte.hu>
In-Reply-To: <20111010064536.GJ32173@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 10.10.11 at 08:45, Ingo Molnar <mingo@elte.hu> wrote:
> * Matt Fleming <matt@console-pimps.org> wrote:
>> Ping? It's -rc8 and 32-bit EFI machines still don't boot.
> 
> Don't know the status of this - Thomas?

This went into 3.1-rc9 (with your signed-off being last).

Jan

> Thanks,
> 
> 	Ingo



