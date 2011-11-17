Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802Ab1KQW3S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 17:29:18 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53080 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322Ab1KQW3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 17:29:17 -0500
Subject: Re: [PATCH] UBIFS: Use kmemdup rather than duplicating its
 implementation
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Thomas Meyer <thomas@m3y3r.de>
Cc: adrian.hunter@intel.com, linux-kernel@vger.kernel.org
Date: Fri, 18 Nov 2011 00:29:12 +0200
In-Reply-To: <1321099416.1668.16.camel@localhost.localdomain>
References: <1321099416.1668.16.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1321568954.2272.36.camel@koala>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-11-12 at 13:03 +0100, Thomas Meyer wrote:
> From: Thomas Meyer <thomas@m3y3r.de>
> 
> Use kmemdup rather than duplicating its implementation
> 
> The semantic patch that makes this change is available
> in scripts/coccinelle/api/memdup.cocci.
> 
> Signed-off-by: Thomas Meyer <thomas@m3y3r.de>

Thanks, but could you please send a patch which I can apply using git
am? This one does not apply:

[dedekind@koala ubifs-2.6 (master)]$ patch --dry-run -p1 < ~/tmp/x.mbox 
patching file fs/ubifs/tnc.c
patching file fs/ubifs/xattr.c
patch: **** malformed patch at line 94: diff -u -p a/fs/ubifs/lpt.c b/fs/ubifs/lpt.c

Artem.


