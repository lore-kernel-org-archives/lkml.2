Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932615Ab2EOMl2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 08:41:28 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:56237 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932092Ab2EOMl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 08:41:27 -0400
Subject: Re: [PATCH, resend] x86: enable rtc-efi
From: Matt Fleming <matt@console-pimps.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Jan Beulich <JBeulich@suse.com>, mingo@elte.hu, tglx@linutronix.de,
        hpa@zytor.com, dannf@dannf.org, linux-kernel@vger.kernel.org
In-Reply-To: <20120515123811.GA25248@srcf.ucam.org>
References: <4FB263560200007800083CB0@nat28.tlf.novell.com>
	 <20120515123811.GA25248@srcf.ucam.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 May 2012 13:41:17 +0100
Message-ID: <1337085677.27692.19.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-15 at 13:38 +0100, Matthew Garrett wrote:
> On Tue, May 15, 2012 at 01:08:22PM +0100, Jan Beulich wrote:
> > Besides a Kconfig change this just requires creating a corresponding
> > platform device.
> 
> I don't think this is a good idea yet - we completely fail to perform 
> timezone handling with the EFI clock, which violates platform 
> expectations. We should fix that up first.

Last time I spoke to Thomas about this, the impression I got was that
the kernel didn't need to worry about handling the timezone for this
case.

Unless I'm missing something?

-- 
Matt Fleming, Intel Open Source Technology Center

