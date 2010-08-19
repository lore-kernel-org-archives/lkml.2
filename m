Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007Ab0HSPQe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 11:16:34 -0400
Received: from sh.osrg.net ([192.16.179.4]:54657 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750951Ab0HSPQb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 11:16:31 -0400
Date: Fri, 20 Aug 2010 00:15:12 +0900
To: kyungmin.park@samsung.com
Cc: m.nazarewicz@samsung.com, linux-mm@kvack.org,
        fujita.tomonori@lab.ntt.co.jp, dwalker@codeaurora.org,
        linux@arm.linux.org.uk, corbet@lwn.net, p.osciak@samsung.com,
        broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        hvaibhav@ti.com, hverkuil@xs4all.nl, kgene.kim@samsung.com,
        zpfeffer@codeaurora.org, jaeryul.oh@samsung.com,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        m.szyprowski@samsung.com
Subject: Re: [PATCH/RFCv3 0/6] The Contiguous Memory Allocator framework
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <AANLkTikp49oOny-vrtRTsJvA3Sps08=w7__JjdA3FE8t@mail.gmail.com>
References: <cover.1281100495.git.m.nazarewicz@samsung.com>
	<AANLkTikp49oOny-vrtRTsJvA3Sps08=w7__JjdA3FE8t@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100820001339N.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 20 Aug 2010 00:15:15 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Aug 2010 12:01:35 +0900
Kyungmin Park <kyungmin.park@samsung.com> wrote:

> Are there any comments or ack?
> 
> We hope this method included at mainline kernel if possible.
> It's really needed feature for our multimedia frameworks.

You got any comments from mm people?

Virtually, this adds a new memory allocator implementation that steals
some memory from memory allocator during boot process. Its API looks
completely different from the API for memory allocator. That doesn't
sound appealing to me much. This stuff couldn't be integrated well
into memory allocator?
