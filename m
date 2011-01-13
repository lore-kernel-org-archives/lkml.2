Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756555Ab1AMAOx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 19:14:53 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:59748 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756294Ab1AMAOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 19:14:46 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 13 Jan 2011 09:08:30 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-mm@kvack.org, Balbir Singh <balbir@linux.vnet.ibm.com>,
        Pavel Emelianov <xemul@openvz.org>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: Remove two memset calls in mm/memcontrol.c by using
 the zalloc variants of alloc functions
Message-Id: <20110113090830.3bca41ee.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.LNX.2.00.1101122135070.22297@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1101122135070.22297@swampdragon.chaosbits.net>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Jan 2011 21:39:59 +0100 (CET)
Jesper Juhl <jj@chaosbits.net> wrote:

> We can avoid two calls to memset() in mm/memcontrol.c by using 
> kzalloc_node(), kzalloc & vzalloc().
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Thank you.

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

