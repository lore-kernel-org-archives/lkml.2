Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933230Ab1CWXoJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 19:44:09 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45114 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932945Ab1CWXoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 19:44:07 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 24 Mar 2011 08:37:09 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Paul Menage <menage@google.com>,
        Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org
Subject: Re: [PATCH] memcg: move page-freeing code out of lock
Message-Id: <20110324083709.d9c9cb75.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1300881558-13523-1-git-send-email-namhyung@gmail.com>
References: <20110323133614.95553de8.kamezawa.hiroyu@jp.fujitsu.com>
	<1300881558-13523-1-git-send-email-namhyung@gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Mar 2011 20:59:18 +0900
Namhyung Kim <namhyung@gmail.com> wrote:

> Move page-freeing code out of swap_cgroup_mutex in the hope that it
> could reduce few of theoretical contentions between swapons and/or
> swapoffs.
> 
> This is just a cleanup, no functional changes.
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> Cc: Paul Menage <menage@google.com>
> Cc: Li Zefan <lizf@cn.fujitsu.com>
> Cc: containers@lists.linux-foundation.org

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


