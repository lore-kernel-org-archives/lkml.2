Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549Ab1IZJNd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 05:13:33 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:43898 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833Ab1IZJNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 05:13:32 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 26 Sep 2011 18:12:30 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <containers@lists.linux-foundation.org>, <paul@paulmenage.org>,
        <lizf@cn.fujitsu.com>, <bsingharora@gmail.com>,
        <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH] mm/page_cgroup.c: quiet sparse noise
Message-Id: <20110926181230.a5240774.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <201109221815.08891.hartleys@visionengravers.com>
References: <201109221815.08891.hartleys@visionengravers.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Sep 2011 18:15:08 -0700
H Hartley Sweeten <hartleys@visionengravers.com> wrote:

> Quite the sparse noise:
> 
> warning: symbol 'swap_cgroup_ctrl' was not declared. Should it be static?
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Paul Menage <paul@paulmenage.org>
> Cc: Li Zefan <lizf@cn.fujitsu.com>
> Cc: Balbir Singh <bsingharora@gmail.com>
> Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 

Thank you.

Acked-by: KAMEZAWA hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

