Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757633Ab1EBVvV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 17:51:21 -0400
Received: from mail-px0-f170.google.com ([209.85.212.170]:64127 "EHLO
	mail-px0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686Ab1EBVvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 17:51:20 -0400
Date: Mon, 2 May 2011 15:51:18 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Tony Lindgren <tony@atomide.com>
Cc: devicetree-discuss@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 4/8] arm/dt: probe for platforms via the device tree
Message-ID: <20110502215118.GD10097@ponder.secretlab.ca>
References: <20110429070135.12522.35745.stgit@ponder>
 <20110429071548.12522.56929.stgit@ponder>
 <20110502151542.GG2092@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110502151542.GG2092@atomide.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 02, 2011 at 08:15:42AM -0700, Tony Lindgren wrote:
> Also, not counting the separate DT append issues, I got things booting
> with these patches (and the dts files) on omaps. So for patches 1 - 5,
> and patch 8:
> 
> Tested-by: Tony Lindgren <tony@atomide.com>

Seeing as Documentation isn't actually executable, I'll interpret that
as an "Acked-by" for the 8th patch.  :-)

g.

