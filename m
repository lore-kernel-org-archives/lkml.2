Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551Ab2FFJrs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 05:47:48 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:48032 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410Ab2FFJrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 05:47:47 -0400
Date: Wed, 6 Jun 2012 11:47:42 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Jan Beulich <JBeulich@suse.com>, mingo@elte.hu, tglx@linutronix.de,
        matt.fleming@linux.intel.com, linux-kernel@vger.kernel.org,
        hpa@zytor.com
Subject: Re: [PATCH] x86-64: use EFI to deal with platform wall clock
Message-ID: <20120606094742.GF9495@gmail.com>
References: <4FBFBF5F020000780008637F@nat28.tlf.novell.com>
 <20120525152414.GA16704@srcf.ucam.org>
 <4FBFC1A3020000780008638F@nat28.tlf.novell.com>
 <20120525153416.GA16973@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120525153416.GA16973@srcf.ucam.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> On Fri, May 25, 2012 at 04:30:11PM +0100, Jan Beulich wrote:
> > >>> On 25.05.12 at 17:24, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> > > Looks good, but should we also be changing get_time to return in UTC? 
> > 
> > Imo that would be a separate change though.
> 
> Sure, but probably a useful one. I've had complaints from firmware 
> vendors that we're not handling the timezone properly here.

I converted this bit of the discussion into:

Acked-by: Matthew Garrett <mjg@redhat.com>

for the original patch. Holler if that's wrong.

Thanks,

	Ingo
