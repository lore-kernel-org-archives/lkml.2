Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751200Ab2AAW6K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jan 2012 17:58:10 -0500
Received: from violet.fr.zoreil.com ([92.243.8.30]:38468 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871Ab2AAW6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jan 2012 17:58:08 -0500
Date: Sun, 1 Jan 2012 23:49:09 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: Bjarke Istrup Pedersen <gurligebis@gentoo.org>
Cc: David Miller <davem@davemloft.net>, shemminger@vyatta.com,
        bhutchings@solarflare.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, rl@hellgate.ch
Subject: Re: [PATCH 1/1] via-rhine: Split driver into .c and .h files.
Message-ID: <20120101224909.GA18144@electric-eye.fr.zoreil.com>
References: <1325452525-23476-1-git-send-email-gurligebis@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1325452525-23476-1-git-send-email-gurligebis@gentoo.org>
User-Agent: Mutt/1.4.2.2i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjarke Istrup Pedersen <gurligebis@gentoo.org> :
> Split the driver into via-rhine.c and via-rhine.h like it should be.
> There is also a bit of cleanup of checkpatch warnings, other than that,
> there is no changes to how the code works, it is plain refactoring.

Please don't do that. The .h won't be used elsewhere. It's useless
(and register definitions stay barely readable).

Roger, any comment regarding patches #1 .. #3 ?

rhine_task_{enable / disable} should be balanced in open / close and
suspend / resume, ok.

-- 
Ueimor
