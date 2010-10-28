Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759312Ab0J1XpF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 19:45:05 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46317 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758542Ab0J1Xo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 19:44:57 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 29 Oct 2010 08:39:17 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Dan Carpenter <error27@gmail.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] memcg: null dereference on allocation failure
Message-Id: <20101029083917.610f9b0b.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20101028111241.GC6062@bicker>
References: <20101028111241.GC6062@bicker>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Oct 2010 13:12:41 +0200
Dan Carpenter <error27@gmail.com> wrote:

> The original code had a null dereference if alloc_percpu() failed.
> This was introduced in 711d3d2c9bc3 "memcg: cpu hotplug aware percpu
> count updates"
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>


Ah, my fault. Thank you for catching.

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

