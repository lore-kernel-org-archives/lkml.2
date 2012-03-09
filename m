Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758705Ab2CIStb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 13:49:31 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:60489 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751478Ab2CISt3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 13:49:29 -0500
Message-ID: <1331318968.13055.8.camel@joe2Laptop>
Subject: Re: [PATCH 1/4] jffs2: Convert most D1/D2 macros to jffs2_dbg
From: Joe Perches <joe@perches.com>
To: dedekind1@gmail.com
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Fri, 09 Mar 2012 10:49:28 -0800
In-Reply-To: <1331294012.29445.10.camel@sauron.fi.intel.com>
References: <cover.1329349881.git.joe@perches.com>
	 <2d68e76db16d42f451370714f03ef952e0839692.1329349881.git.joe@perches.com>
	 <1330965033.7220.16.camel@golum> <1330966615.3140.6.camel@joe2Laptop>
	 <1331294012.29445.10.camel@sauron.fi.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-03-09 at 13:53 +0200, Artem Bityutskiy wrote:
> OK, pushed these ones, although I think that mechanical D1->jffs2_dbg()
> conversion is not very useful and to make your patch-set worth the
> trouble you should do few more clean-up steps, like I suggested.

Do you want me to remove the D2/jffs2_dbg(2, ...) instances
or just eliminate the first arg to jffs2_dbg and keep the
current jffs2_dbg(2,...) instances?


