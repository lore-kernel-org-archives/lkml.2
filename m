Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757942Ab0JSAuk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 20:50:40 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:48496 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755809Ab0JSAuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 20:50:39 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 19 Oct 2010 09:45:12 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Greg Thelen <gthelen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, containers@lists.osdl.org,
        Andrea Righi <arighi@develer.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Minchan Kim <minchan.kim@gmail.com>,
        Ciju Rajan K <ciju@linux.vnet.ibm.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v3 04/11] memcg: add lock to synchronize page accounting
 and migration
Message-Id: <20101019094512.11eabc62.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1287448784-25684-5-git-send-email-gthelen@google.com>
References: <1287448784-25684-1-git-send-email-gthelen@google.com>
	<1287448784-25684-5-git-send-email-gthelen@google.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Oct 2010 17:39:37 -0700
Greg Thelen <gthelen@google.com> wrote:

> Performance Impact: moving a 8G anon process.
> 
> Before:
> 	real    0m0.792s
> 	user    0m0.000s
> 	sys     0m0.780s
> 
> After:
> 	real    0m0.854s
> 	user    0m0.000s
> 	sys     0m0.842s
> 
> This score is bad but planned patches for optimization can reduce
> this impact.
> 

I'll post optimization patches after this set goes to -mm.
RFC version will be posted soon.

Thanks,
-Kame

