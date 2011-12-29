Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900Ab1L3ACD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 19:02:03 -0500
Received: from violet.fr.zoreil.com ([92.243.8.30]:47226 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754816Ab1L3ACB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 19:02:01 -0500
Date: Fri, 30 Dec 2011 00:53:12 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: Bjarke Istrup Pedersen <gurligebis@gentoo.org>
Cc: David Miller <davem@davemloft.net>, shemminger@vyatta.com,
        bhutchings@solarflare.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, rl@hellgate.ch
Subject: Re: [PATCH 1/1] via-rhine: Fix hanging with high CPU load on low-end broads.
Message-ID: <20111229235312.GA27092@electric-eye.fr.zoreil.com>
References: <CACPM=kXOddA+T6vQPijR6sh8x5cMO=4baKGeKxEmMKG896Lz4g@mail.gmail.com> <20111229153902.GB21946@electric-eye.fr.zoreil.com> <20111229183902.GC21946@electric-eye.fr.zoreil.com> <20111229.170514.1766899380937848638.davem@davemloft.net> <CACPM=kV8NwYLAdODQHxYmJ21X0RmZ8KJT9szKdY2xa-DsesvQg@mail.gmail.com> <CACPM=kVfsXgFhKheevTS1pm7kCoezKO3M+102O=PRbXzxebxxg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACPM=kVfsXgFhKheevTS1pm7kCoezKO3M+102O=PRbXzxebxxg@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjarke Istrup Pedersen <gurligebis@gentoo.org> :
[...]
> Would it be a problem if I try and use the patch on top of a clean
> 3.1.6 kernel ?

You will have to "cd drivers/net && patch -p5 ..." as the paths are
different. Avoid suspend/resume/runtime PM.

-- 
Ueimor
