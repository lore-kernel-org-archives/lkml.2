Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757836Ab2CaJtG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 05:49:06 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:59622 "EHLO violet"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754331Ab2CaJtF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 05:49:05 -0400
Date: Sat, 31 Mar 2012 11:46:05 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Mike Sinkovsky <msink@permonline.ru>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 2/2] Ethernet driver for the WIZnet W5100 chip
Message-ID: <20120331094605.GA7876@electric-eye.fr.zoreil.com>
References: <1332752876-1650-1-git-send-email-msink@permonline.ru> <1333090806-27988-2-git-send-email-msink@permonline.ru> <1333099431.19659.15.camel@edumazet-laptop> <20120331094014.GA7746@electric-eye.fr.zoreil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120331094014.GA7746@electric-eye.fr.zoreil.com>
User-Agent: Mutt/1.4.2.2i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Francois Romieu <romieu@fr.zoreil.com> :
[...]
> The start_tx logic seems broken anyway: it claims it always can take
> packets until it is given one it can't process. The driver should rather
> do the opposite and stop queueing as soon as there is no guarantee for
> the next packet.

Forget it: the driver stops queuing in this path anyway.

-- 
Ueimor
