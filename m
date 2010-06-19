Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756852Ab0FSTwo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 15:52:44 -0400
Received: from one.firstfloor.org ([213.235.205.2]:55007 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756782Ab0FSTwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 15:52:43 -0400
Date: Sat, 19 Jun 2010 21:52:42 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, fengguang.wu@intel.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] [31/31] HWPOISON: Add a madvise() injector for soft
 page offlining
Message-ID: <20100619195242.GS18946@basil.fritz.box>
References: <200912081016.198135742@firstfloor.org>
 <20091208211647.9B032B151F@basil.firstfloor.org>
 <AANLkTimBhQAYn7BDXd1ykSN90v0ClWybIe2Pe1qv_6vA@mail.gmail.com>
 <20100619132055.GK18946@basil.fritz.box>
 <AANLkTin-lj5ZgtcvJhWcNiMuWSCQ39N8mqe_2fm8DDVR@mail.gmail.com>
 <20100619133000.GL18946@basil.fritz.box>
 <AANLkTiloIXtCwBeBvP32hLBBvxCWrZMMwWTZwSj475wi@mail.gmail.com>
 <20100619140933.GM18946@basil.fritz.box>
 <AANLkTilF6m5YKMiDGaTNuoW6LxiA44oss3HyvkavwrOK@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTilF6m5YKMiDGaTNuoW6LxiA44oss3HyvkavwrOK@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> .TP
> .BR MADV_SOFT_OFFLINE " (Since Linux 2.6.33)
> Soft offline the pages in the range specified by
> .I addr
> and
> .IR length .
> This memory of each page in the specified range is copied to a new page,

Actually there are some cases where it's also dropped if it's cached page.

Perhaps better would be something more fuzzy like

"the contents are preserved"

> and the original page is offlined
> (i.e., no longer used, and taken out of normal memory management).

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
