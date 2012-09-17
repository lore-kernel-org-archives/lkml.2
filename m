Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757411Ab2IQWYa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 18:24:30 -0400
Received: from utopia.booyaka.com ([74.50.51.50]:52630 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755340Ab2IQWY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 18:24:28 -0400
Date: Mon, 17 Sep 2012 22:24:27 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Tony Lindgren <tony@atomide.com>
cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, Fengguang Wu <fengguang.wu@intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Samuel Ortiz <sameo@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>, Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH] mfd: Fix compile for twl-core.c by removing cpu_is_omap
 usage
In-Reply-To: <20120917221406.GG11762@atomide.com>
Message-ID: <alpine.DEB.2.00.1209172222570.18885@utopia.booyaka.com>
References: <20120917202943.GV4521@atomide.com> <alpine.DEB.2.00.1209172207480.16117@utopia.booyaka.com> <20120917221406.GG11762@atomide.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Sep 2012, Tony Lindgren wrote:

> We need to queue this ASAP and before other patches to fix the
> build breakage in linux next. Then you can merge in that commit
> too, does that work for you?

That's fine, we'll just need a stable commit then that the CCF patches can 
be based on.


- Paul
