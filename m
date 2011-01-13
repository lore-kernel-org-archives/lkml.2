Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756586Ab1AMAgU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 19:36:20 -0500
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:52992 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755961Ab1AMAgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 19:36:19 -0500
Date: Thu, 13 Jan 2011 09:28:20 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-mm@kvack.org, Balbir Singh <balbir@linux.vnet.ibm.com>,
        Pavel Emelianov <xemul@openvz.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH] mm: Remove two memset calls in mm/memcontrol.c by using
 the zalloc variants of alloc functions
Message-Id: <20110113092820.811e34ae.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <alpine.LNX.2.00.1101122135070.22297@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1101122135070.22297@swampdragon.chaosbits.net>
Organization: NEC Soft, Ltd.
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

Acked-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
