Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756364Ab2FNPo4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 11:44:56 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56389 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756324Ab2FNPoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 11:44:55 -0400
Date: Thu, 14 Jun 2012 16:44:14 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: nicolas.pitre@linaro.org, linux-s390@vger.kernel.org,
        matt.fleming@intel.com, lasse.collin@tukaani.org, jj@chaosbits.net,
        linux-sh@vger.kernel.org, x86@kernel.org, heiko.carstens@de.ibm.com,
        linux-kernel@vger.kernel.org, lethal@linux-sh.org,
        T Makphaibulchoke <tmac@hp.com>, schwidefsky@de.ibm.com,
        linux390@de.ibm.com, tglx@linutronix.de, kaloz@openwrt.org,
        mingo@redhat.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] lib/decompress_unxz.c: removing all memory helper
	functions
Message-ID: <20120614154414.GA7628@n2100.arm.linux.org.uk>
References: <1339470307-28223-1-git-send-email-tmac@hp.com> <4FD6B472.7040609@zytor.com> <20120612143545.GC7918@n2100.arm.linux.org.uk> <20120614134715.GE28714@n2100.arm.linux.org.uk> <4FD9F6AD.6060407@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FD9F6AD.6060407@zytor.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2012 at 07:35:25AM -0700, H. Peter Anvin wrote:
> On 06/14/2012 06:47 AM, Russell King - ARM Linux wrote:
> > On Tue, Jun 12, 2012 at 03:35:45PM +0100, Russell King - ARM Linux wrote:
> >> I'd like to toss this into my kautobuild+boot, but at the moment that's
> >> rather pointless because OMAP has been broken since towards the end of
> >> the merge window, and so far no sign of the fix hitting mainline any
> >> time soon...
> > 
> > Okay, given the issue raised with memcpy() calling __builtin_memcpy(),
> > I don't think there's any value to me actually testing this, because
> > that seems to need to be solved first?
> 
> You mean __builtin_memcpy() calling memcpy(), right?

Indeed I do.
