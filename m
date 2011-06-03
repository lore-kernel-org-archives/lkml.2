Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855Ab1FCR5Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 13:57:25 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:45459 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969Ab1FCR5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 13:57:24 -0400
Date: Fri, 3 Jun 2011 11:57:23 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Shawn Guo <shawn.guo@linaro.org>, linux-kernel@vger.kernel.org,
        arnd@arndb.de, kernel@pengutronix.de,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org
Subject: Re: [PATCH v2 0/2] Move Freescale MXS gpio driver into drivers/gpio
Message-ID: <20110603175723.GE15616@ponder.secretlab.ca>
References: <1306595374-25178-1-git-send-email-shawn.guo@linaro.org>
 <20110530064502.GC23771@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110530064502.GC23771@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 30, 2011 at 08:45:02AM +0200, Sascha Hauer wrote:
> Grant,
> 
> I suppose we should take this through the architecture tree. Can I have
> your Ack for this?
> 

Actually, as mentioned in my other email, I'd like to see this series
respun with a separate patch for just moving the gpio driver (without
breaking the build).  

Also, I've been thinking about how to merge these changes, and I'd
rather take them through the gpio tree since there will be a lot of
conflicts with the other gpio driver moves.  It will be easier to
resolve merge conflicts if I push it out to my tree and allow the
subarch trees to merge in mine if necessary.

g.
