Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757920Ab0JEIsD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 04:48:03 -0400
Received: from smtp.nokia.com ([192.100.122.233]:54876 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487Ab0JEIsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 04:48:01 -0400
From: Evgeny Kuznetsov <EXT-Eugeny.Kuznetsov@nokia.com>
To: akpm@linux-foundation.org, torvalds@linux-foundation.org
Cc: phillip@lougher.demon.co.uk, hsweeten@visionengravers.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, ext-eugeny.kuznetsov@nokia.com
Subject: [PATCH 0/1] initramfs: strcpy destination string overflow
Date: Tue,  5 Oct 2010 12:44:16 +0400
Message-Id: <cover.1286193211.git.EXT-Eugeny.Kuznetsov@nokia.com>
X-Mailer: git-send-email 1.6.3.3
X-OriginalArrivalTime: 05 Oct 2010 08:47:50.0364 (UTC) FILETIME=[FDDCC9C0:01CB6469]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is patch which fixes bug in /init/initramfs.c file.
Function "strcpy" is used without check for maximum allowed source
string length and could cause destination string overflow.

Thanks,
Best Regards,
Evgeny

Evgeny Kuznetsov (1):
  initramfs: strcpy destination string overflow

 init/initramfs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

