Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758448Ab1CaPhz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 11:37:55 -0400
Received: from adelie.canonical.com ([91.189.90.139]:52579 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758433Ab1CaPhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 11:37:53 -0400
Date: Thu, 31 Mar 2011 12:37:48 -0300
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: Re: [PATCH] [0/275] 2.6.35.12 longterm review
Message-ID: <20110331153747.GA3057@herton-IdeaPad-Y430>
References: <20110330203.501921634@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110330203.501921634@firstfloor.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 30, 2011 at 02:03:53PM -0700, Andi Kleen wrote:
> 
> This is the start of the longterm review cycle for the 2.6.35.12 release.
> There are a large number of patches in this series, all will be posted as a 
> response to this one.  If anyone has any issues with these being applied, 
> please let me know.  If anyone is a maintainer of the proper subsystem, and
> wants to add a Signed-off-by: line to the patch, please respond with it.
> 
> The full quilt queue can be found at
> git://git.kernel.org/pub/scm/linux/kernel/git/longterm/longterm-queue-2.6.35
> 
> Responses should be made within 48 hours.

Can you include in this series also the following upstream patch?:
commit 7a89e4c "USB: serial: option: Apply OPTION_BLACKLIST_SENDSETUP
also for ZTE MF626"

It affects also .35, I thought it was going in in this .35 update too as
it's Cc: stable, but if it's already queued for the next .35 update then
please disregard this.

> 
> -Andi
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
[]'s
Herton
