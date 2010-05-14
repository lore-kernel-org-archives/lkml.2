Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758576Ab0ENXfR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 19:35:17 -0400
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:41200 "HELO
	outbound-mail-01.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754626Ab0ENXfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 19:35:13 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=eQM6eOEcxjkdTMCuNbfRQnz7QUIguq5rLiQvIEsX7Yw5JdeuIPL1w6FgLcDONZrFxEzSmUhgUpadt/9AcP4UI+gvcbpV3lF9W3e9iqGkRHG9HxHG0jyuMVVgzCXcq2y/;
Date: Fri, 14 May 2010 16:34:16 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mike Travis <travis@sgi.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Mike Habeck <habeck@sgi.com>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
       Jacob Pan <jacob.jun.pan@intel.com>, Tejun Heo <tj@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Yinghai <yinghai.lu@oracle.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Myron Stowe <myron.stowe@hp.com>
Subject: Re: [Patch 1/1] x86 pci: Add option to not assign BAR's if not
 already assigned
Message-ID: <20100514163416.0e940f64@virtuousgeek.org>
In-Reply-To: <4BEDDD77.1050205@zytor.com>
References: <4BEAF008.9030805@sgi.com>
	<201005131256.17997.bjorn.helgaas@hp.com>
	<4BEC5530.1000008@sgi.com>
	<201005131402.30759.bjorn.helgaas@hp.com>
	<20100514152509.3aeb37b4@virtuousgeek.org>
	<4BEDCFD9.7020202@sgi.com>
	<20100514154706.4f36f4ed@virtuousgeek.org>
	<4BEDDACD.9040704@zytor.com>
	<20100514162836.27e0325a@virtuousgeek.org>
	<4BEDDD77.1050205@zytor.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 May 2010 16:32:07 -0700
"H. Peter Anvin" <hpa@zytor.com> wrote:

> On 05/14/2010 04:28 PM, Jesse Barnes wrote:
> > On Fri, 14 May 2010 16:20:45 -0700
> > "H. Peter Anvin" <hpa@zytor.com> wrote:
> > 
> >> On 05/14/2010 03:47 PM, Jesse Barnes wrote:
> >>>
> >>> Wow and they're using cards that want to use I/O space?  Funky.  It's
> >>> too late to get this into 2.6.34, but that can't be what you were
> >>> expecting... I don't see a problem with getting something like this in
> >>> for 2.6.35.
> >>>
> >>
> >> Most cards on the market provide I/O BARs as a convenience to legacy
> >> BIOSes; they don't need the I/O BAR functionality from inside a
> >> full-featured OS.  There are a few, key, exceptions, mainly in the form
> >> of legacy-interface devices like UARTs and VGA (note that VGA has its
> >> own routing bits and is therefore unaffected by this problem.)
> > 
> > Yeah, it's the "legacy" part that I'm questioning.  I'm just lamenting
> > that it's dying off so slowly...
> > 
> > And yes, VGA is an unfortunate standard.
> > 
> 
> I'm not lamenting that fact, because my experience is that what ends up
> replacing it is often far worse.  Consider UARTs -- no MMU dependencies
> at all, can be accessed with four lines of assembly, and compare it to
> EHCI debug port, the driver for which is over 900 lines in the Linux
> kernel -- and that assumes that you're already in flat mode.

Heh, you're so old and crufty!

-- 
Jesse Barnes, Intel Open Source Technology Center
