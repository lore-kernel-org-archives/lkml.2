Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758826Ab0JZJQE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 05:16:04 -0400
Received: from canuck.infradead.org ([134.117.69.58]:33948 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753061Ab0JZJQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 05:16:02 -0400
Subject: Re: linux-next: build warnings after merge of the final tree (mtd
 tree related)
From: David Woodhouse <dwmw2@infradead.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        H Hartley Sweeten <hartleys@visionengravers.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20101026134959.86b807d1.sfr@canb.auug.org.au>
References: <20101026134959.86b807d1.sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Oct 2010 10:15:39 +0100
Message-ID: <1288084539.29264.15.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.0 (2.32.0-2.fc14) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-26 at 13:49 +1100, Stephen Rothwell wrote:
> Hi David,
> 
> After merging the final tree, today's linux-next build (powerpc
> ppc44x_defconfig) produced these warnings:
> 
> In file included from drivers/mtd/mtdchar.c:36:
> include/linux/mtd/map.h:145:2: warning: #warning "No CONFIG_MTD_MAP_BANK_WIDTH_xx selected. No NOR chip support can work"

432dc821c90114f9b0e00f6752a700e937516ade is the first bad commit
commit 432dc821c90114f9b0e00f6752a700e937516ade
Author: H Hartley Sweeten <hartleys@visionengravers.com>
Date:   Thu Aug 19 18:18:21 2010 -0700

    mtd: cleanup Kconfig dependencies

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

