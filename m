Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933740Ab0KQN3r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 08:29:47 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:56956 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932615Ab0KQN3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 08:29:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=d1GOla5zcFvgIcQ6zluNo9DxgjgjiMRXEjDlUeO+9Ma2n8u06I6I8rQUfsOVNqlVEW
         LDejEnr8eMjOhwuG/DcTwj2Agv0jjbUssSE/16MAn67n/r1G45ob67wTBTVQH9ZcxVup
         yoKiksdCCwEa1cECQUlfGyNFWDcqGPOLQcY4o=
From: Hai Shan <haishan.bai@gmail.com>
To: viro@zeniv.linux.org.uk, axboe@kernel.dk
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: mpage: some code cleanups
Date: Wed, 17 Nov 2010 21:29:22 +0800
Message-Id: <1290000563-1803-1-git-send-email-shan.hai@windriver.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Merged mpage_end_io_read() and mpage_end_io_write() to mpage_end_io(),
because they share three of four codes.

---
 fs/mpage.c |   49 +++++++++++++++++--------------------------------
 1 files changed, 17 insertions(+), 32 deletions(-)
