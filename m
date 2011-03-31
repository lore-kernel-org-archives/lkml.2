Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759154Ab1CaSwz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 14:52:55 -0400
Received: from one.firstfloor.org ([213.235.205.2]:51270 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759132Ab1CaSwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 14:52:54 -0400
Date: Thu, 31 Mar 2011 20:52:53 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com
Subject: Re: [PATCH] [0/275] 2.6.35.12 longterm review
Message-ID: <20110331185253.GN21838@one.firstfloor.org>
References: <20110330203.501921634@firstfloor.org> <20110331153747.GA3057@herton-IdeaPad-Y430>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110331153747.GA3057@herton-IdeaPad-Y430>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Can you include in this series also the following upstream patch?:
> commit 7a89e4c "USB: serial: option: Apply OPTION_BLACKLIST_SENDSETUP
> also for ZTE MF626"
> 
> It affects also .35, I thought it was going in in this .35 update too as
> it's Cc: stable, but if it's already queued for the next .35 update then
> please disregard this.

It's not queued yet, but I should pick it up with the next update.
For this one it's too late.
Thanks,
-Andi
