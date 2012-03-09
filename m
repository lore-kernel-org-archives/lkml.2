Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822Ab2CILvS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 06:51:18 -0500
Received: from mga09.intel.com ([134.134.136.24]:19406 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752365Ab2CILvR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 06:51:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="116184499"
Message-ID: <1331294012.29445.10.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 1/4] jffs2: Convert most D1/D2 macros to jffs2_dbg
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Joe Perches <joe@perches.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Fri, 09 Mar 2012 13:53:32 +0200
In-Reply-To: <1330966615.3140.6.camel@joe2Laptop>
References: <cover.1329349881.git.joe@perches.com>
	 <2d68e76db16d42f451370714f03ef952e0839692.1329349881.git.joe@perches.com>
	 <1330965033.7220.16.camel@golum> <1330966615.3140.6.camel@joe2Laptop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-05 at 08:56 -0800, Joe Perches wrote:
> On Mon, 2012-03-05 at 18:30 +0200, Artem Bityutskiy wrote:
> > On Wed, 2012-02-15 at 15:56 -0800, Joe Perches wrote:
> []
> > I would just kill all the levels and left only the first one - others
> > are not useful. This FS is in the kernel for ages and it is safe to
> > assume it is robust enough to require no level 2. And change the Kconfig
> > correspondingly.
> > 
> > I would accept that to my l2 tree, although the final word is from
> > dwmw2, of course.
> 
> Separate patch I think.

OK, pushed these ones, although I think that mechanical D1->jffs2_dbg()
conversion is not very useful and to make your patch-set worth the
trouble you should do few more clean-up steps, like I suggested.

Let's push these patches as they are anyway to make sure the work you
have done does not get lost.

Pushed to l2-mtd.git, thanks!

-- 
Best Regards,
Artem Bityutskiy

