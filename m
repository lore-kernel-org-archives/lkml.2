Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933699Ab0JSHRI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 03:17:08 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:45260 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414Ab0JSHRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 03:17:07 -0400
Date: Tue, 19 Oct 2010 16:03:02 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: Greg Thelen <gthelen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, containers@lists.osdl.org,
        Andrea Righi <arighi@develer.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Ciju Rajan K <ciju@linux.vnet.ibm.com>,
        David Rientjes <rientjes@google.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH v3 06/11] memcg: add kernel calls for memcg dirty page
 stats
Message-Id: <20101019160302.273f1bd1.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <1287448784-25684-7-git-send-email-gthelen@google.com>
References: <1287448784-25684-1-git-send-email-gthelen@google.com>
	<1287448784-25684-7-git-send-email-gthelen@google.com>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Oct 2010 17:39:39 -0700
Greg Thelen <gthelen@google.com> wrote:

> Add calls into memcg dirty page accounting.  Notify memcg when pages
> transition between clean, file dirty, writeback, and unstable nfs.
> This allows the memory controller to maintain an accurate view of
> the amount of its memory that is dirty.
> 
> Signed-off-by: Greg Thelen <gthelen@google.com>
> Signed-off-by: Andrea Righi <arighi@develer.com>

Reviewed-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
