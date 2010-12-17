Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996Ab0LQUQY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 15:16:24 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:13681 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906Ab0LQUQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 15:16:21 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Jon Mason <jon.mason@exar.com>
Subject: Re: "x86: allocate space within a region top-down" causes bar0 access issue
Date: Fri, 17 Dec 2010 13:16:12 -0700
User-Agent: KMail/1.13.2 (Linux/2.6.32-26-generic; KDE/4.4.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Ramkrishna Vepa <ramkrishna.vepa@exar.com>
References: <20101217194457.GA4470@exar.com>
In-Reply-To: <20101217194457.GA4470@exar.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012171316.12761.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, December 17, 2010 12:44:58 pm Jon Mason wrote:
> The following patch is causing problem with the vxge driver/adapter on
> HP x86-64 systems. Reads to bar0 to return 0xffffffffffffffff instead
> of their intended value.  This prevents the vxge module from loading
> by failing sanity checks in the driver for certain values in bar0.  We
> are not seeing any issues with this patch on non-HP systems in our
> lab.
> 
> Can this patch be removed from 2.6.37 until a better solution can be
> found?

There were several issues related to that patch, and it's about to
be reverted.  I am curious about the failure you're seeing, though,
and I'd like to understand the cause and make sure it's one of the
issues I've already investigated.

Can you send me the complete dmesg log of a failing boot?

Thanks,
  Bjorn
