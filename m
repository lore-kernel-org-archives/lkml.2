Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593Ab1HHX4S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 19:56:18 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46117 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782Ab1HHX4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 19:56:17 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 9 Aug 2011 08:48:58 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] vmscan: reverse lru scanning order
Message-Id: <20110809084858.cab100e4.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110808110207.30777.30800.stgit@localhost6>
References: <20110727111002.9985.94938.stgit@localhost6>
	<20110808110207.30777.30800.stgit@localhost6>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Aug 2011 15:02:07 +0400
Konstantin Khlebnikov <khlebnikov@openvz.org> wrote:

> LRU scanning order was accidentially changed in commit v2.6.27-5584-gb69408e:
> "vmscan: Use an indexed array for LRU variables".
> Before that commit reclaimer always scan active lists first.
> 
> This patch just reverse it back.
> 
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>

makes sense...but what real problem do you see ?

