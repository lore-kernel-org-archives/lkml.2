Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752436Ab1ALOBb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 09:01:31 -0500
Received: from smtp.outflux.net ([198.145.64.163]:38497 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751286Ab1ALOB2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 09:01:28 -0500
Date: Wed, 12 Jan 2011 06:01:18 -0800
From: Kees Cook <kees.cook@canonical.com>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, spender@grsecurity.net, segooon@gmail.com,
        jreuter@yaina.de, ralf@linux-mips.org
Subject: Re: [PATCH] net: ax25: fix information leak to userland harder
Message-ID: <20110112140118.GV4979@outflux.net>
References: <20110112054022.GR4979@outflux.net>
 <20110112.003458.09752771.davem@davemloft.net>
 <20110112.003531.22531182.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110112.003531.22531182.davem@davemloft.net>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Wed, Jan 12, 2011 at 12:35:31AM -0800, David Miller wrote:
> BTW, in the future please CC: netdev@vger.kernel.org on all networking
> patches.

Yeah, I meant to, but I think my mail client ate the address somehow. Sorry about
that!

-Kees

-- 
Kees Cook
Ubuntu Security Team
