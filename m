Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758818Ab2EONIa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 09:08:30 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:54786 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758090Ab2EONI1 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:6:1>);
	Tue, 15 May 2012 09:08:27 -0400
Message-Id: <4FB271860200007800083D21@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Tue, 15 May 2012 14:08:54 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Matthew Garrett" <mjg59@srcf.ucam.org>
Cc: <dannf@dannf.org>, <mingo@elte.hu>, <tglx@linutronix.de>,
        <matt.fleming@linux.intel.com>, <linux-kernel@vger.kernel.org>,
        <hpa@zytor.com>
Subject: Re: [PATCH, resend] x86: enable rtc-efi
References: <4FB263560200007800083CB0@nat28.tlf.novell.com>
 <20120515123811.GA25248@srcf.ucam.org>
In-Reply-To: <20120515123811.GA25248@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 15.05.12 at 14:38, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Tue, May 15, 2012 at 01:08:22PM +0100, Jan Beulich wrote:
>> Besides a Kconfig change this just requires creating a corresponding
>> platform device.
> 
> I don't think this is a good idea yet - we completely fail to perform 
> timezone handling with the EFI clock, which violates platform 
> expectations. We should fix that up first.

So how is this driver okay on ia64 then? It's my understanding
that either it's entirely broken, or should be used universally.
That's the more that accessing the RTC directly isn't really being
permitted by the EFI spec (i.e. using this driver really is a
requirement, not an option).

Jan

