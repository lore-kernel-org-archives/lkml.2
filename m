Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757595Ab0KOPoK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 10:44:10 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:54636 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757069Ab0KOPoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 10:44:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer;
        b=ft9KbRfoY+ZvNw9ym6aVDWPN7lRwytEEm4u9LBXzlo1UHGKN00DuYl4yR9lRt8P8vU
         WIhMd1MXseL9k2kiCZS9fvl/xkLnVlf8Om0XYbHHaaib1YRI/iQU5FRGVSy7rSvlmfUi
         +LiUpV4pRogGEyulEHvgFtWqEHzc9UeSrPrJ0=
From: Hai Shan <haishan.bai@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: mpage: some code cleanups
Date: Mon, 15 Nov 2010 23:43:51 +0800
Message-Id: <1289835832-1907-1-git-send-email-shan.hai@windriver.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Merged mpage_end_io_read() and mpage_end_io_write() to mpage_end_io(),
because they share three of four codes.

---
 fs/mpage.c |   49 +++++++++++++++++--------------------------------
 1 files changed, 17 insertions(+), 32 deletions(-)

