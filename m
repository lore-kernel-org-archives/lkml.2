Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698Ab0EJKwQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 06:52:16 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:50122 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756013Ab0EJKwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 06:52:15 -0400
Date: Mon, 10 May 2010 11:52:00 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Eduardo Valentin <eduardo.valentin@nokia.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-arm-kernel@lists.infradead.org,
       Linux-OMAP <linux-omap@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       ext Tony Lindgren <tony@atomide.com>,
       ext Kevin Hilman <khilman@deeprootsystems.com>,
       Peter De-Schrijver <Peter.De-Schrijver@nokia.com>,
       santosh.shilimkar@ti.com, Ambresh <a0393775@ti.com>,
       felipe.balbi@nokia.com
Subject: Re: [PATCHv4 3/4] mach-omap1: export omap1 info under /proc/socinfo
Message-ID: <20100510105200.GA14337@n2100.arm.linux.org.uk>
References: <1273487857-32281-1-git-send-email-eduardo.valentin@nokia.com> <1273487857-32281-4-git-send-email-eduardo.valentin@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273487857-32281-4-git-send-email-eduardo.valentin@nokia.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 10, 2010 at 01:37:36PM +0300, Eduardo Valentin wrote:
> From: Eduardo Valentin <eduardo.valentin@nokia.com>
> 
> Report OMAP name and rev under /proc/socinfo node.

I think this needs to be combined with the previous patch.  The previous
patch enables the socinfo file, which means with patch 2 applied but not
patch 3, OMAP1 breaks.
