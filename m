Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760726Ab0HEPXn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 11:23:43 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38720 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759191Ab0HEPXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 11:23:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Ik5dKz3RBOMHpcAgjVB0l81mpAa2/+xAb3841XVVsJ/sTPBeXl5ecFSrH9JShOQWfF
         cpb0p8KQ2gU7LlLXuKYFJKMonxtQNif8o8f5CMDgPyuU0NJoLSkoIAjlSy1EzwupqBrT
         uQIKDEaObnySoh05QZIFsH7HDLZ2U5PjJdxCY=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2 V3] Driver for Ricoh cardreader + few fixes
Date: Thu,  5 Aug 2010 18:23:26 +0300
Message-Id: <1281021809-20924-1-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is third revision of my patches that conatains one more fix, and few fixes
for the driver.

Changes since V2:
* Removed accidently added hunk from r852.c
* Few cosmetic cleanups in the driver


--- original description from v2 ---

Patches 1-2 have no reason to be held  back from beeing merged in 2.6.35
In fact patch #2 should be added to -stable as well.

The actual driver (patch #3) is new driver, so it can't introduce regressions,
thus I think it can go to 2.6.36 as well.

I already have report form one user that driver works.

Best regards,
	Maxim Levitsky


