Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025Ab2KUUBs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 15:01:48 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54403 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756005Ab2KUUBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 15:01:47 -0500
Date: Wed, 21 Nov 2012 12:01:44 -0800
From: Olof Johansson <olof@lixom.net>
To: Michal Simek <michal.simek@xilinx.com>
Cc: Arnd Bergmann <arnd@arndb.de>, arm@kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        Josh Cartwright <josh.cartwright@ni.com>
Subject: Re: [GIT PULL] arm-soc: Xilinx zynq multiplatform changes for v3.8
Message-ID: <20121121200144.GD15213@quad.lixom.net>
References: <CAHTX3d+bqMnsWxQp3GAmprSDzNB18otT3SrPi5MkA+d8006Aww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHTX3d+bqMnsWxQp3GAmprSDzNB18otT3SrPi5MkA+d8006Aww@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Nov 21, 2012 at 04:51:07PM +0100, Michal Simek wrote:
> Hi Olof and Arnd,
> 
> based on my chat with Olof today I have created new branch
> with 4 patches which move zynq to multiplatform.
> 
> This branch depends on arm-soc devel/debug_ll_init branch because
> we needed Rob's "ARM: implement debug_ll_io_init()"
> (sha1: afaee03511ba8002b26a9c6b1fe7d6baf33eac86)
> patch.
> 
> This branch also depends on zynq/dt branch because of previous major
> zynq changes.
> zynq/cleanup branch is subset of zynq/dt.
> 
> That's why I have merged devel/debug_ll_init branch with zynq/dt and
> add 4 patches
> on the top of it.

Nice work.

This looks quite reasonable, is small and self-contained and doesn't really
affect anyone outside of zynq. So I've pulled into next/multiplatform for 3.8.

As part of this, the next/* branches have been somewhat reordered, since
multiplatform now includes next/dt contents I've moved it down below there. It
shouldn't affect much since no other branch pulls in next/multiplatform
contents.


-Olof

