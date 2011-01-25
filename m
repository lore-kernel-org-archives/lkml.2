Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128Ab1AYROp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 12:14:45 -0500
Received: from smtp.outflux.net ([198.145.64.163]:36474 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752372Ab1AYROo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 12:14:44 -0500
Date: Tue, 25 Jan 2011 09:14:38 -0800
From: Kees Cook <kees.cook@canonical.com>
To: Eugene Teo <eugeneteo@kernel.org>
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Ben Hutchings <bhutchings@solarflare.com>
Subject: Re: net: clear heap allocation for ethtool_get_regs()
Message-ID: <20110125171438.GX4979@outflux.net>
References: <20110125044910.GB8117@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110125044910.GB8117@infradead.org>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eugene,

On Tue, Jan 25, 2011 at 12:49:10PM +0800, Eugene Teo wrote:
> There is a conflict between commit b00916b1 and a77f5db3. This patch resolves
> the conflict by clearing the heap allocation in ethtool_get_regs().

Good catch! Thanks!

-Kees

-- 
Kees Cook
Ubuntu Security Team
