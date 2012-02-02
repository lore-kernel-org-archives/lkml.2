Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933475Ab2BBTvE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 14:51:04 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:45098 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933461Ab2BBTvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 14:51:02 -0500
Date: Thu, 02 Feb 2012 14:50:36 -0500 (EST)
Message-Id: <20120202.145036.1235867786947627132.davem@davemloft.net>
To: danny.kukawka@bisect.de
Cc: mac@melware.de, dkukawka@suse.de, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, isdn@linux-pingi.de, bhutchings@solarflare.com,
        David.Laight@aculab.com
Subject: Re: [PATCH v2] eicon: fix -Warray-bounds warning
From: David Miller <davem@davemloft.net>
In-Reply-To: <1328188830-28133-1-git-send-email-danny.kukawka@bisect.de>
References: <1328188830-28133-1-git-send-email-danny.kukawka@bisect.de>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 02 Feb 2012 11:50:40 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Danny Kukawka <danny.kukawka@bisect.de>
Date: Thu,  2 Feb 2012 14:20:28 +0100

> Fix for a -Warray-bounds warning. mixer_notify_update() tries to
> write to ((CAPI_MSG *) msg)->info.facility_req.structs[3] while
> structs is defined as byte structs[1]. Set all 'structs' which are
> part of the typdefs in the info union to 'byte structs[0]'.
> 
> v2: set all info.*.structs to byte structs[0]
> 
> Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>

Applied, thanks.
