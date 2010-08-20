Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752957Ab0HTAPX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 20:15:23 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35954 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701Ab0HTAPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 20:15:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=mxsBHveulmrcjWapiiDq7GUBzdTmUrIFraqa9/lj5MTEMXOq0y2Th9QIDuOebKRQ+J
         +EfqR+PaOh8/sW8ssEi3WVsrkB2QszQTyEgzvxETlsmlijvJgc5fhzbxtbAWTABQk+9Q
         yO53FoHj0bAEFHFY9XbdvXwjOR32fMyp6YW44=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] My work on MemoryStick system
Date: Fri, 20 Aug 2010 03:15:02 +0300
Message-Id: <1282263305-4048-1-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch series contains the work I did for memorystick subsystem.

I resend slightly cleaned up driver for my card reader in patch #2
patch #1 and #3 are new and add support for Legacy MemorySticks (<= 128MB)

Everything works and more or less tested.

Best regards,
	Maxim Levitsky


