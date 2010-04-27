Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619Ab0D0Hur (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 03:50:47 -0400
Received: from smtp.nokia.com ([192.100.122.233]:34091 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547Ab0D0Huq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 03:50:46 -0400
Subject: Re: [PATCHv2] MTD: Suppress warnings in inline_map_read()
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Kevin Cernekee <cernekee@gmail.com>
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <e970485f0e9f4c9e1cb6e594a45dd11308683197@localhost.localdomain>
References: <1270891582.4704.102.camel@macbook.infradead.org>
	 <e970485f0e9f4c9e1cb6e594a45dd11308683197@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Apr 2010 10:46:28 +0300
Message-ID: <1272354388.26036.4.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 27 Apr 2010 07:50:36.0339 (UTC) FILETIME=[52846830:01CAE5DE]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-04-10 at 11:18 -0700, Kevin Cernekee wrote:
> With gcc 4.4.3 -O2 on MIPS32:
> 
> drivers/mtd/chips/cfi_util.c: In function 'cfi_qry_present':
> include/linux/mtd/map.h:390: warning: 'r' may be used uninitialized in this function
> include/linux/mtd/map.h:375: note: 'r' was declared here
> include/linux/mtd/map.h:390: warning: 'r' may be used uninitialized in this function
> include/linux/mtd/map.h:375: note: 'r' was declared here
> 
> Signed-off-by: Kevin Cernekee <cernekee@gmail.com>

Pushed to l2-mtd-2.6 / dunno

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

