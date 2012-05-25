Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757388Ab2EYP3k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 11:29:40 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:52819 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753625Ab2EYP3j convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Fri, 25 May 2012 11:29:39 -0400
Message-Id: <4FBFC1A3020000780008638F@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 25 May 2012 16:30:11 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Matthew Garrett" <mjg59@srcf.ucam.org>
Cc: <mingo@elte.hu>, <tglx@linutronix.de>, <matt.fleming@linux.intel.com>,
        <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [PATCH] x86-64: use EFI to deal with platform wall clock
References: <4FBFBF5F020000780008637F@nat28.tlf.novell.com>
 <20120525152414.GA16704@srcf.ucam.org>
In-Reply-To: <20120525152414.GA16704@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 25.05.12 at 17:24, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Fri, May 25, 2012 at 04:20:31PM +0100, Jan Beulich wrote:
> 
>> Also make the two EFI functions in question here static - they're not
>> being referenced elsewhere.
> 
> Looks good, but should we also be changing get_time to return in UTC? 

Imo that would be a separate change though.

> What are the expected semantics for get_wallclock?

Not sure - I think both are permitted (just like for the legacy RTC),
with the expectation that early user mode would tell the kernel.

Jan

