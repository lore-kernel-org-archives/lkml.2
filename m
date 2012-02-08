Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757056Ab2BHNIW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 08:08:22 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:59382 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757018Ab2BHNIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 08:08:21 -0500
Date: Wed, 8 Feb 2012 13:08:07 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Michal Simek <monstr@monstr.eu>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Ohad Ben-Cohen <ohad@wizery.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: CMA on arm from zero address
Message-ID: <20120208130807.GJ889@n2100.arm.linux.org.uk>
References: <4F326A4E.1030106@monstr.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F326A4E.1030106@monstr.eu>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 08, 2012 at 01:27:58PM +0100, Michal Simek wrote:
> Hi,
>
> I would like to setup CMA space at the beginning of ram because
> I want to use remoteproc to run code on the second cpu which has to
> use addresses 0x0 - 32MB.
>
> I have changed textofs in arch/arm/Makefile but there is not possible
> to setup all values which I would like to use.

What a broken setup.  Placing the kernel outside of the 16MB window
effectively prevents you from using modules.  Why do people come up
with stupid things like this.  Please stop.  Put such things at the
end of RAM instead and save the rest of the ARM community from this
madness.
