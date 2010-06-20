Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753118Ab0FTVZE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 17:25:04 -0400
Received: from eu1sys200aog116.obsmtp.com ([207.126.144.141]:60100 "EHLO
	eu1sys200aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751107Ab0FTVY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 17:24:58 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>,
       Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 00/19] DMAENGINE: ste_dma40: bugfixes v2
Date: Sun, 20 Jun 2010 23:24:36 +0200
Message-ID: <1277069076-30579-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resending this fixup patchset after review, so as to avoid
confusion of which patch goes where. Some patches were changed
in accordance with Dan's comments and that led to merge
problems with later patches so may just as well resend the
whole shebang.

Changes since v1:

- Inline d40_config_chan() into d40_alloc_chan_resources()
  in patch 02.
- Removed weird page allocation count code in patch 12, we
  don't quite know what we were up to, it looks more sane
  now. Niced up the failure code as well and make it look
  much better.
- Changed order of patch 17 & 18 to avoid compilation and
  bisection issues.
- Included the separate patch to support older silicon in
  this patch series.

Yours,
Linus Walleij
