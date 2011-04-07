Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225Ab1DGQ5r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 12:57:47 -0400
Received: from linux-sh.org ([111.68.239.195]:55241 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755822Ab1DGQ5p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 12:57:45 -0400
Date: Fri, 8 Apr 2011 01:56:54 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Kevin Hilman <khilman@ti.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        Magnus Damm <magnus.damm@gmail.com>,
        "Rafael J. Wysocki" <rjw@suse.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH/RFC 4/6] ARM: move SH-mobile runtime PM to arm/common for sharing with other platforms
Message-ID: <20110407165654.GD8052@linux-sh.org>
References: <1302134569-22825-1-git-send-email-khilman@ti.com> <1302134569-22825-5-git-send-email-khilman@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302134569-22825-5-git-send-email-khilman@ti.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 06, 2011 at 05:02:47PM -0700, Kevin Hilman wrote:
> There is really nothing SH-mobile specific about this runtime PM
> implementation.  Any platform wanting to implement runtime PM based on
> simple clock gating can use this implementation.
> 
> Signed-off-by: Kevin Hilman <khilman@ti.com>

This observation is wholly architecture agnostic, so it's not clear that
keeping it in arch/arm/common is any better. It seems that this would be
better suited for drivers/base/power/ with a generic Kconfig symbol.
