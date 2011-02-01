Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037Ab1BANDw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 08:03:52 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:49258 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640Ab1BANDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 08:03:51 -0500
Date: Tue, 1 Feb 2011 13:03:11 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Colin Cross <ccross@android.com>
Cc: linux-tegra@vger.kernel.org, konkers@android.com,
        Gary King <gking@nvidia.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Abhijeet Dharmapurikar <adharmap@codeaurora.org>,
        linux-kernel@vger.kernel.org, olof@lixom.net,
        linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: Re: [PATCH v2 02/28] ARM: gic: Add functions to save and restore
	gic state
Message-ID: <20110201130311.GG31216@n2100.arm.linux.org.uk>
References: <1295834493-5019-1-git-send-email-ccross@android.com> <1295834493-5019-3-git-send-email-ccross@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295834493-5019-3-git-send-email-ccross@android.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 23, 2011 at 06:01:07PM -0800, Colin Cross wrote:
> on systems with idle states which power-gate the logic including
> the gic, such as tegra, the gic distributor needs to be shut down
> and restored on entry and exit from the architecture idle code

I'd rather not add this and then have to weed it back out when we have a
proper interface for dealign with idle shutdown stuff.

Can some effort please be put into coming up with a proper interface
such as an idle notifier list rather than calling directly into random
parts of the kernel on idle.
