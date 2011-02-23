Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035Ab1BWVgI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 16:36:08 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:56353 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753305Ab1BWVgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 16:36:06 -0500
Date: Wed, 23 Feb 2011 14:36:01 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH v4 6/7] arm/dt: Basic tegra devicetree support
Message-ID: <20110223213601.GA5404@angua.secretlab.ca>
References: <20110223021524.18318.71902.stgit@localhost6.localdomain6>
 <20110223022234.18318.90592.stgit@localhost6.localdomain6>
 <4D657880.50405@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D657880.50405@ru.mvista.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 24, 2011 at 12:13:36AM +0300, Sergei Shtylyov wrote:
> Hello.
> 
> On 23-02-2011 5:22, Grant Likely wrote:
> 
> >This patch adds adds very basic support for booting tegra with a
> >device tree.  It simply allows the existing machine_descs to match
> >against the tegra compatible values so that the kernel can boot.
> >Kernel parameters and the initrd pointer is read out of the tree
> >instead of atags.
> 
> >This is not complete device tree support.  This change will be
> >reverted when a new machine_desc is added that can populate the
> >device registrations directly from data in the tree instead of using
> >hard coded data.  That change will be made in a future patch.
> 
> >v2: Fixed cut-and-paste error in commit text
> 
>    Shouldn't this sentence follow the --- tearline?

Nope!  It is actually quite useful for the version information to show
up in the commit text.  That way you know *exactly* which version got
merged.  dwmw2 pointed that out to me a few months back.

