Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757707Ab1ANSFR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 13:05:17 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36214 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756939Ab1ANSFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 13:05:12 -0500
Date: Fri, 14 Jan 2011 18:04:55 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Igor Plyatov <plyatov@gmail.com>, Andrew Victor <linux@maxim.org.za>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Sergio Tanzilli <tanzilli@acmesystems.it>
Subject: Re: [GIT PULL] AT91: patches for v2.6.38-rc1
Message-ID: <20110114180455.GL15996@n2100.arm.linux.org.uk>
References: <4D308F30.6070503@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D308F30.6070503@atmel.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 14, 2011 at 07:00:16PM +0100, Nicolas Ferre wrote:
> Hi Russell,
> 
> Can you please pull those little changes for AT91? They add two 
> new boards already discussed on the mailing list and a little 
> cleanup patch:

Has this already been in linux-next?

We should only be merging new code during a merge window which has
already had visibility in linux-next, with the exception of bug fixes
and regression fixes.

Regression fixes can be merged at any time provided they're obvious.
Any regression fix should be acceptable during the merge window.

Bug fixes any time up until (I'd say) the last week of the -rc series.
