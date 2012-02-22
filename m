Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643Ab2BVNz0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 08:55:26 -0500
Received: from matrix.voodoobox.net ([75.127.97.206]:59164 "EHLO
	matrix.voodoobox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985Ab2BVNzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 08:55:23 -0500
X-Greylist: delayed 1220 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Feb 2012 08:55:22 EST
Subject: Re: [PATCH 1/2] 3com/typhoon: reuse eth_mac_addr()
From: David Dillow <dave@thedillows.org>
To: Danny Kukawka <danny.kukawka@bisect.de>
Cc: Danny Kukawka <dkukawka@suse.de>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Date: Wed, 22 Feb 2012 08:32:17 -0500
In-Reply-To: <1329914199-30862-2-git-send-email-danny.kukawka@bisect.de>
References: <1329914199-30862-1-git-send-email-danny.kukawka@bisect.de>
	 <1329914199-30862-2-git-send-email-danny.kukawka@bisect.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1329917537.27315.0.camel@obelisk.thedillows.org>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-22 at 13:36 +0100, Danny Kukawka wrote:
> Use eth_mac_addr() for .ndo_set_mac_address, remove
> typhoon_set_mac_address() since it do currently the same as
> eth_mac_addr(). Additional advantage: eth_mac_addr() already
> checks if the given address is valid.
> 
> Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>

Acked-by: Dave Dillow <dave@thedillows.org>

