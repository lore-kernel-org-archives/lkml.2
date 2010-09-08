Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755014Ab0IHU6F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 16:58:05 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64900 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754283Ab0IHU6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 16:58:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer;
        b=b4UD0UD8nhpraITPpKF3hmulsoi32Fh8MVKeTmwjGZMadDBebwv8QQlPy8bb3SHo6I
         rl89p0P8y/Td1SeAecHxPc/9L1V4aCwJERI30jxOejDLIyGpMpo5mt2EYTrWmNU3V9ba
         +376l/cbTvricKyuT19WIjHmYs5Z3MTT8KD70=
From: Nikitas Angelinas <nikitasangelinas@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 0/8] use ARRAY_SIZE macro
Date: Wed,  8 Sep 2010 21:57:36 +0100
Message-Id: <1283979457-4649-1-git-send-email-nikitasangelinas@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series replaces occurrences of the type sizeof(buffer) / sizeof(buffer[0])
with ARRAY_SIZE(buffer) in different places throughout the source tree.
