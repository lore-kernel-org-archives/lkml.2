Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751676Ab0DJJ1N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Apr 2010 05:27:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:38330 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108Ab0DJJ1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Apr 2010 05:27:11 -0400
Subject: Re: [PATCH] MTD: Suppress warnings in inline_map_read()
From: David Woodhouse <dwmw2@infradead.org>
To: Kevin Cernekee <cernekee@gmail.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <fb80b9139bec21ac8bd4ddcec0abeb9c1ad39ad5@localhost.localdomain>
References: <fb80b9139bec21ac8bd4ddcec0abeb9c1ad39ad5@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 10 Apr 2010 10:26:22 +0100
Message-ID: <1270891582.4704.102.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-04-09 at 15:45 -0700, Kevin Cernekee wrote:
> With gcc 4.4.3 -O2 on MIPS32:
> 
> drivers/mtd/chips/cfi_util.c: In function 'cfi_qry_present':
> include/linux/mtd/map.h:390: warning: 'r' may be used uninitialized in this function
> include/linux/mtd/map.h:375: note: 'r' was declared here
> include/linux/mtd/map.h:390: warning: 'r' may be used uninitialized in this function
> include/linux/mtd/map.h:375: note: 'r' was declared here
> 
> Signed-off-by: Kevin Cernekee <cernekee@gmail.com>

I suspect 'else BUG()' would be a better fix.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

