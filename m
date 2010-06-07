Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100Ab0FGGJZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 02:09:25 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47684 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964Ab0FGGJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 02:09:23 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 7 Jun 2010 15:05:06 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Subject: Re: [cleanup][PATCH -mmotm 2/2] memcg: remove mem from arg of
 charge_common
Message-Id: <20100607150506.2c3c9a38.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100607145337.c0b5ad79.nishimura@mxp.nes.nec.co.jp>
References: <20100607145239.cb5cb917.nishimura@mxp.nes.nec.co.jp>
	<20100607145337.c0b5ad79.nishimura@mxp.nes.nec.co.jp>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Jun 2010 14:53:37 +0900
Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:

> From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> 
> mem_cgroup_charge_common() is always called with @mem = NULL, so it's
> meaningless. This patch removes it.
> 
> Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

Acked-by: KAMEZAWA Hioryuki <kamezawa.hiroyu@jp.fujitsu.com>

