Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039Ab0FSOJh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 10:09:37 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39936 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755978Ab0FSOJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 10:09:35 -0400
Date: Sat, 19 Jun 2010 16:09:33 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, fengguang.wu@intel.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] [31/31] HWPOISON: Add a madvise() injector for soft
 page offlining
Message-ID: <20100619140933.GM18946@basil.fritz.box>
References: <200912081016.198135742@firstfloor.org>
 <20091208211647.9B032B151F@basil.firstfloor.org>
 <AANLkTimBhQAYn7BDXd1ykSN90v0ClWybIe2Pe1qv_6vA@mail.gmail.com>
 <20100619132055.GK18946@basil.fritz.box>
 <AANLkTin-lj5ZgtcvJhWcNiMuWSCQ39N8mqe_2fm8DDVR@mail.gmail.com>
 <20100619133000.GL18946@basil.fritz.box>
 <AANLkTiloIXtCwBeBvP32hLBBvxCWrZMMwWTZwSj475wi@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTiloIXtCwBeBvP32hLBBvxCWrZMMwWTZwSj475wi@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 19, 2010 at 03:43:28PM +0200, Michael Kerrisk wrote:
> Is there a userspace operation to unpoison (i.e., reverse MADV_SOFT_OFFLINE)?

Yes, but it's only a debugfs interface currently.

> I ask because I wondered if there is something additional to be documented.

I don't think debugfs needs manpages atm.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
