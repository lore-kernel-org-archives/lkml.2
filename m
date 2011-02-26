Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752444Ab1BZRyN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 12:54:13 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:53208 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373Ab1BZRyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 12:54:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=e/RKqI1rNHh6JS07qHxrXAJjVDfvX2ROoTRtTZ5iACajgG4bX+h2cmjuMriOF1/GyB
         zmFWCSGFcwBlPpRc0fKrVvl/RtirS7LX0szu8wLXGdR2T6te+i+GDHyGUWt0uD1SXOzN
         bVfmoUdOoqB1r/qtl2G0Jv0mbSKcyEN/zvkio=
From: Brian Gerst <brgerst@gmail.com>
To: hpa@zytor.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] x86 boot cleanups
Date: Sat, 26 Feb 2011 12:54:01 -0500
Message-Id: <1298742844-8256-1-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.7.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are three small patches that merge 32 and 64 bit code in the boot code.

[PATCH 1/3] x86, boot: Use common ELF header defines
[PATCH 2/3] x86, boot: Remove memptr
[PATCH 3/3] x86, boot: merge memcpy()

 arch/x86/boot/compressed/misc.c |   44 ++++++++------------------------------
 1 files changed, 10 insertions(+), 34 deletions(-)

