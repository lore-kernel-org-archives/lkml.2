Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752409Ab1LROjr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 09:39:47 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52207 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677Ab1LROjp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 09:39:45 -0500
MIME-Version: 1.0
From: Hamo <hamo.by@gmail.com>
Date: Sun, 18 Dec 2011 22:39:23 +0800
Message-ID: <CAO_0yfPxRmz1_CfZZvib8ncSSs8Vbn2ccagH3c9Vnu8yKTUaUg@mail.gmail.com>
Subject: [PATCH][RESEND] MAINTAINERS: update gpio subsystem file list
To: grant.likely@secretlab.ca, akpm@linux-foundation.org, joe@perches.com,
        gregkh@suse.de, davem@davemloft.net
Cc: linux-kernel@vger.kernel.org, hamo.by@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yang Bai <hamo.by@gmail.com>
Signed-off-by: Yang Bai <hamo.by@gmail.com>--- MAINTAINERS |    1 + 1
files changed, 1 insertions(+), 0 deletions(-)
diff --git a/MAINTAINERS b/MAINTAINERSindex 51a8160..c1029e4 100644---
a/MAINTAINERS+++ b/MAINTAINERS@@ -2851,6 +2851,7 @@ T:        git
git://git.secretlab.ca/git/linux-2.6.git F:     Documentation/gpio.txt
F:     drivers/gpio/ F:     include/linux/gpio*+F:
include/asm-generic/gpio.h
 GRE DEMULTIPLEXER DRIVER M:     Dmitry Kozlov <xeb@mail.ru>

--1.7.7
