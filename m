Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754922Ab0GLG5n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 02:57:43 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:62840 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145Ab0GLG5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 02:57:42 -0400
From: Thomas Weber <weber@corscience.de>
To: lenb@kernel.org
Cc: Thomas Weber <weber@corscience.de>, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] idle: intel_idle: Change mode 755 => 644
Date: Mon, 12 Jul 2010 08:56:43 +0200
Message-Id: <1278917804-4456-1-git-send-email-weber@corscience.de>
X-Mailer: git-send-email 1.7.1
X-Provags-ID: V02:K0:MWKzVglHXVEs4ej5P6i/T0pmCzWJPGJoez1Py35MzuZ
 MCRGkk7d2G/d745NAqpvCqCYPXlCUh18M6XOGj9oGRm2IsBN42
 bFd1mJZoxSSFy7JBkW30q5jxSYdjOzKR8DJPSlHbTo3DSU/mzu
 JMmxyuC+CCd+yTQZTIaaFrkfbq/8E5A0gClom98p2mo78h1ZiQ
 E4Zi6iaOrV7iKzmEc0JaA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove execution permission from source file.

Signed-off-by: Thomas Weber <weber@corscience.de>
---
 0 files changed, 0 insertions(+), 0 deletions(-)
 mode change 100755 => 100644 drivers/idle/intel_idle.c

diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
old mode 100755
new mode 100644
-- 
1.7.1

