Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541Ab2BVNaP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 08:30:15 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41947 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971Ab2BVNaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 08:30:11 -0500
MIME-Version: 1.0
In-Reply-To: <1329914199-30862-3-git-send-email-danny.kukawka@bisect.de>
References: <1329914199-30862-1-git-send-email-danny.kukawka@bisect.de>
	<1329914199-30862-3-git-send-email-danny.kukawka@bisect.de>
Date: Wed, 22 Feb 2012 17:30:10 +0400
Message-ID: <CALT56yNcW5rAJ7N7SmJuPu_cQvvO=V_L9YOq80THdx2v6tumFw@mail.gmail.com>
Subject: Re: [PATCH 2/2] net/ieee802154/6lowpan.c: reuse eth_mac_addr()
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: Danny Kukawka <danny.kukawka@bisect.de>
Cc: Danny Kukawka <dkukawka@suse.de>, Sergey Lapin <slapin@ossfans.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-zigbee-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 22, 2012 at 4:36 PM, Danny Kukawka <danny.kukawka@bisect.de> wrote:
> Use eth_mac_addr() for .ndo_set_mac_address, remove
> lowpan_set_address since it do currently the same as
> eth_mac_addr(). Additional advantage: eth_mac_addr() already
> checks if the given address is valid
>
> Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>

Acked-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>

-- 
With best wishes
Dmitry
