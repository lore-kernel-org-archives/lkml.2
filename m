Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030344Ab2CNCKR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 22:10:17 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46655 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030183Ab2CNCKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 22:10:16 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 14 Mar 2012 11:08:44 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: seq_put_decimal_ull() et al
Message-Id: <20120314110844.d1654724.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20120314093156.2bc3d3c5.kamezawa.hiroyu@jp.fujitsu.com>
References: <CACVxJT_UWzpVo1Jfbf5Z2A-s16QjEv05MiNSY_EGihKTPuMyxg@mail.gmail.com>
	<20120314093156.2bc3d3c5.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Mar 2012 09:31:56 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Tue, 13 Mar 2012 15:35:54 +0200
> Alexey Dobriyan <adobriyan@gmail.com> wrote:
> 
> > > Subject:    + procfs-add-num_to_str-to-speed-up-proc-stat-fix-2.patch added to -mm tree
> > 
> > I think the fix is to create proper binary interface for exporting
> > interrupt counts.
> > Programs can parse raw data equally well if programming language is
> > even minimally reasonable
> > (POSIX shell may not qualify, though).
> 
> Ok, please try with all tool-chain updates.
> procps, top, sar, and more ?
> 
One concern is maintainance of 2 files of the same data.

Thanks,
-Kame

