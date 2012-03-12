Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491Ab2CLNJi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 09:09:38 -0400
Received: from mga01.intel.com ([192.55.52.88]:33575 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754261Ab2CLNJe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 09:09:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="127781417"
Message-ID: <1331557935.12037.11.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 1/4] jffs2: Convert most D1/D2 macros to jffs2_dbg
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Joe Perches <joe@perches.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Mon, 12 Mar 2012 15:12:15 +0200
In-Reply-To: <1331318968.13055.8.camel@joe2Laptop>
References: <cover.1329349881.git.joe@perches.com>
	 <2d68e76db16d42f451370714f03ef952e0839692.1329349881.git.joe@perches.com>
	 <1330965033.7220.16.camel@golum> <1330966615.3140.6.camel@joe2Laptop>
	 <1331294012.29445.10.camel@sauron.fi.intel.com>
	 <1331318968.13055.8.camel@joe2Laptop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-03-09 at 10:49 -0800, Joe Perches wrote:
> On Fri, 2012-03-09 at 13:53 +0200, Artem Bityutskiy wrote:
> > OK, pushed these ones, although I think that mechanical D1->jffs2_dbg()
> > conversion is not very useful and to make your patch-set worth the
> > trouble you should do few more clean-up steps, like I suggested.
> 
> Do you want me to remove the D2/jffs2_dbg(2, ...) instances
> or just eliminate the first arg to jffs2_dbg and keep the
> current jffs2_dbg(2,...) instances?

Just remove. There were few other suggestions as well :-)

-- 
Best Regards,
Artem Bityutskiy

