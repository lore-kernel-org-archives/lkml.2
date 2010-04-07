Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932900Ab0DGQbN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 12:31:13 -0400
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:59372 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932695Ab0DGQbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 12:31:12 -0400
Date: Wed, 7 Apr 2010 11:30:23 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
cc: Eric Dumazet <eric.dumazet@gmail.com>, netdev <netdev@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       alex.shi@intel.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Ma, Ling" <ling.ma@intel.com>, "Chen, Tim C" <tim.c.chen@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: hackbench regression due to commit 9dfc6e68bfe6e
In-Reply-To: <1270607668.2078.259.camel@ymzhang.sh.intel.com>
Message-ID: <alpine.DEB.2.00.1004071128240.13261@router.home>
References: <1269506457.4513.141.camel@alexs-hp.sh.intel.com>  <alpine.DEB.2.00.1003250942080.2670@router.home>  <1269570902.9614.92.camel@alexs-hp.sh.intel.com>  <1270114166.2078.107.camel@ymzhang.sh.intel.com>  <alpine.DEB.2.00.1004011050340.16531@router.home>
  <1270195589.2078.116.camel@ymzhang.sh.intel.com>  <alpine.DEB.2.00.1004050853300.23149@router.home>  <i2z84144f021004051030k7ff5190cyc083aa12c552dfac@mail.gmail.com>  <4BBA8DF9.8010409@kernel.org>  <1270542497.2078.123.camel@ymzhang.sh.intel.com> 
 <alpine.DEB.2.00.1004061033330.18750@router.home>  <alpine.DEB.2.00.1004061552500.19151@router.home>  <1270591841.2091.170.camel@edumazet-laptop> <1270607668.2078.259.camel@ymzhang.sh.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Apr 2010, Zhang, Yanmin wrote:

> > booting with slub_min_order=3 do change hackbench results for example ;)
> By default, slub_min_order=3 on my Nehalem machines. I also tried different
> larger slub_min_order and didn't find help.

Lets stop fiddling with kernel command line parameters for these test.
Leave as default. That is how I tested.
