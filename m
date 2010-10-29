Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761938Ab0J2UUo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 16:20:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33528 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761922Ab0J2UUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 16:20:43 -0400
Date: Fri, 29 Oct 2010 13:19:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Greg Thelen <gthelen@google.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        containers@lists.osdl.org, Andrea Righi <arighi@develer.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Minchan Kim <minchan.kim@gmail.com>,
        Ciju Rajan K <ciju@linux.vnet.ibm.com>,
        David Rientjes <rientjes@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH v4 09/11] memcg: CPU hotplug lockdep warning fix
Message-Id: <20101029131957.e0ea4013.akpm@linux-foundation.org>
In-Reply-To: <1288336154-23256-10-git-send-email-gthelen@google.com>
References: <1288336154-23256-1-git-send-email-gthelen@google.com>
	<1288336154-23256-10-git-send-email-gthelen@google.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Oct 2010 00:09:12 -0700
Greg Thelen <gthelen@google.com> wrote:

> From: Balbir Singh <balbir@linux.vnet.ibm.com>
> 
> memcg has lockdep warnings (sleep inside rcu lock)
> >
> ...
>
> Acked-by: Greg Thelen <gthelen@google.com>

You were on the patch delivery path, so this should be Signed-off-by:. 
I made that change to my copy.

> Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>


