Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025Ab1C2SUD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 14:20:03 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:44873 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459Ab1C2SUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 14:20:02 -0400
Date: Tue, 29 Mar 2011 19:19:47 +0100
From: Russell King <rmk@arm.linux.org.uk>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, gregkh@suse.de,
        linux-wireless@vger.kernel.org, devel@linuxdriverproject.org
Subject: Re: [PATCH 0/1] new module for amba axi on-chip interconnect
Message-ID: <20110329181947.GA18134@flint.arm.linux.org.uk>
References: <1301391619-4499-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301391619-4499-1-git-send-email-arend@broadcom.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 29, 2011 at 11:40:18AM +0200, Arend van Spriel wrote:
> GUIDANCE NEEDED:
> This patch puts the module at proposed location. Please provide your
> guidance if there is a better location within the linux tree for this
> module.
> 
> This module has been isolated from the brcm80211 driver currently
> located in staging and provided to other drivers for chipsets using
> the AMBA AXI on-chip interconnect with ARM Device Management Plugin
> (DMP) silicon IP, which provides system discovery (chip being the
> system) and basic core function (disable, reset, etc.).

What does this do which the 'amba' bus support doesn't?

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
