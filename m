Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527Ab2CLNsr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 09:48:47 -0400
Received: from mga09.intel.com ([134.134.136.24]:52896 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752604Ab2CLNsp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 09:48:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="116886972"
Message-ID: <1331560226.12037.34.camel@sauron.fi.intel.com>
Subject: Re: [PATCH l2-mtd] jffs2: Fix build when CONFIG_JFFS2_FS_DEBUG > 0
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Joe Perches <joe@perches.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Mon, 12 Mar 2012 15:50:26 +0200
In-Reply-To: <1331330354.14442.6.camel@joe2Laptop>
References: <cover.1329349881.git.joe@perches.com>
	 <2d68e76db16d42f451370714f03ef952e0839692.1329349881.git.joe@perches.com>
	 <1330965033.7220.16.camel@golum> <1330966615.3140.6.camel@joe2Laptop>
	 <1331294012.29445.10.camel@sauron.fi.intel.com>
	 <1331330354.14442.6.camel@joe2Laptop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-03-09 at 13:59 -0800, Joe Perches wrote:
> commit c6f6dad20d71 ("jffs2: Standardize JFFS_<LEVEL> uses")
> broke the build when CONFIG_JFFS2_FS_DEBUG > 0.  Similarly,
> commit 41f75c15285c ("jffs2: Convert printks to pr_<level>")
> also broke the build.
> 
> Oops.  Insufficient compile testing...

Folded in and pushed to l2-mtd.git, thanks!

-- 
Best Regards,
Artem Bityutskiy

