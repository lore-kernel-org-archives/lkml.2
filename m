Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756283Ab2C1IZb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 04:25:31 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:50476 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713Ab2C1IZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 04:25:28 -0400
Date: Wed, 28 Mar 2012 09:25:01 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Olof Johansson <olof@lixom.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, arm@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL 1/5] ARM: cleanups of io includes
Message-ID: <20120328082501.GA22414@n2100.arm.linux.org.uk>
References: <1332918842-13521-1-git-send-email-olof@lixom.net> <1332918842-13521-2-git-send-email-olof@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332918842-13521-2-git-send-email-olof@lixom.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2012 at 12:13:58AM -0700, Olof Johansson wrote:
> Rob Herring has done a sweeping change cleaning up all of the mach/io.h includes,
> moving some of the oft-repeated macros to a common location and removing a bunch of
> boiler plate. This is another step closer to a common zImage for multiple platforms.

NAK.  Linus, do not pull this.  This breaks PXA compilation, which has
been known about for more than a week.
