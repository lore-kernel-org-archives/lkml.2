Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293Ab0IPRK1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 13:10:27 -0400
Received: from fifo99.com ([67.223.236.141]:47501 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753907Ab0IPRKZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 13:10:25 -0400
X-Greylist: delayed 591 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Sep 2010 13:10:25 EDT
Subject: Re: FW: next build fails
From: Daniel Walker <dwalker@fifo99.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Sundar R IYER <sundar.iyer@stericsson.com>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Russell King <rmk@arm.linux.org.uk>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100916164442.df749cc1.sfr@canb.auug.org.au>
References: <33A307AF30D7BF4F811B1568FE7A9B18043784FF99@EXDCVYMBSTM006.EQ1STM.local>
	 <20100916164442.df749cc1.sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 16 Sep 2010 10:00:07 -0700
Message-ID: <1284656407.2411.5.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-16 at 16:44 +1000, Stephen Rothwell wrote:

> This is due to a mismerge (in linux-next) between commit
> dc966984f44f16b8bb6b0644e501c7c2163ead69 ("ARM: Allow SMP kernels to boot
> on UP systems") from the arm tree (which renamed PMD_FLAGS to
> PMD_FLAGS_UP) and commit b7bc5d9c6556e3ca37176784036380f91b53432c ("arm:
> mm: add proc info for ARM11MPCore/Cortex-A9 from ARM") from the msm tree
> (which added a new use of PMD_FLAGS).
> 
> I will add the above patch as a merge fixup to my tree until the msm tree
> gets merged into the arm tree (or vice versa or they both are merged into
> Linus' tree).

__v7_ca9mp_proc_info should just duplicate __v7_proc_info (the one below
it) ..

Daniel

