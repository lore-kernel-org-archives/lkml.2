Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932133Ab0FCQOz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 12:14:55 -0400
Received: from mail-pz0-f185.google.com ([209.85.222.185]:64049 "EHLO
	mail-pz0-f185.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932079Ab0FCQOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 12:14:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=xMVu3PUGXwjVqsPy5pF9y3881QRikezngsQ+UHwUArIRi7sJCLverKW9vGL1FAwfFm
         mn1CqcBAncw+0sQcHccCvwLWoVtK0vTFIDtz/O3vwQ7EWmz81W0Mq+10DZYVlGd87noE
         VVGk4Borta/0tzaK0yAocnyobCZYKR+8jceZ0=
From: Rabin Vincent <rabin@rab.in>
To: mmarek@suse.cz
Cc: linux-kernel@vger.kernel.org, Rabin Vincent <rabin@rab.in>
Subject: [PATCH] scripts: decodecode: use /bin/bash
Date: Thu,  3 Jun 2010 21:44:46 +0530
Message-Id: <1275581686-19745-1-git-send-email-rabin@rab.in>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

5358db ("scripts: add ARM support to decodecode") added a few bashims to
the decodecode script, so explicitly ask for bash.

Signed-off-by: Rabin Vincent <rabin@rab.in>
---
Alternatively, I have a patch to remove the bashisms, if that's preferred.

 scripts/decodecode |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/decodecode b/scripts/decodecode
index 8b30cc3..405cfac 100755
--- a/scripts/decodecode
+++ b/scripts/decodecode
@@ -1,4 +1,4 @@
-#!/bin/sh
+#!/bin/bash
 # Disassemble the Code: line in Linux oopses
 # usage: decodecode < oops.file
 #
-- 
1.7.1

