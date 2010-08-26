Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756657Ab0HaCYj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 22:24:39 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:59956 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756585Ab0HaCYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 22:24:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Eucc9ivg5k7zSZqPwJFPo9Q4XuaGFxb6cMdo6nyA5c/XtGEoiWrhH+N5saUjLwLpek
         CB+Cr9v3ulzf9RlVbQS3GagcgkzGmexZmNU9L8S2e+wCPp1+P3p2PFQnwk0BrUUb5w2f
         6M4ZbZgoUf1E9FjX8hu95kbsgWdJmTvJWZXmk=
From: "Mark F. Brown" <mark.brown314@gmail.com>
To: Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        "Mark F. Brown" <mark.brown314@gmail.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org
Cc: "Mark F. Brown" <mark.brown314@gmail.com>
Subject: [PATCH 0/1] ARM: pxa168: fix corrected reset vector
Date: Thu, 26 Aug 2010 05:07:28 -0400
Message-Id: <1282813649-8332-1-git-send-email-mark.brown314@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reset vector for pxa168 is 0xffff_0000 not 0x0
This fix allows reboot to work

Mark F. Brown (1):
  ARM: pxa168: fix corrected reset vector

 arch/arm/mach-mmp/include/mach/system.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

