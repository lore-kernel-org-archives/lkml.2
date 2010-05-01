Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932Ab0EAKS3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 May 2010 06:18:29 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:60406 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832Ab0EAKS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 May 2010 06:18:28 -0400
Date: Sat, 1 May 2010 11:18:11 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Amit Kucheria <amit.kucheria@verdurent.com>
Cc: Dinh Nguyen <Dinh.Nguyen@freescale.com>,
       Sascha Hauer <s.hauer@pengutronix.de>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: Fix build error for i.MX51 (mx51_defconfig)
Message-ID: <20100501101811.GI12172@n2100.arm.linux.org.uk>
References: <20100421211707.GC2951@matterhorn.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100421211707.GC2951@matterhorn.lan>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 22, 2010 at 12:17:07AM +0300, Amit Kucheria wrote:
> Please apply the following patch to fix build failure for i.MX51 in
> 2.6.34-rc5.

It would be preferable to have an acked-by from Sascha, but given this
is a build error I'll take it via the patch system; thanks.
