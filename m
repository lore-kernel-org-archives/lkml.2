Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760620Ab0HEOZ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 10:25:29 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56466 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758080Ab0HEOZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 10:25:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=OAJJEfQl5MxBp1LKLRgmywopsWLw660k2ryWlJCv9ctbZV7qSIqjYb8u9zJgNTBkMt
         PVzuCk+QJIvGFoW++J3qi9tzshDQEfila1E3MC13t76FTYfpxJp9dbp1Dgx8cZSQryaK
         XqjwQqoviX98TthEwxtEDaLBB/EcKOIa84DH4=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2 V2 resend] Driver for Ricoh cardreader + few fixes
Date: Thu,  5 Aug 2010 17:25:13 +0300
Message-Id: <1281018316-1466-1-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(resending because I forgot to CC LKML)

Hi,

This is second revision of my patches that conatains one more fix, and few fixes
for the driver.

Patches 1-2 have no reason to be held  back from beeing merged in 2.6.35
In fact patch #2 should be added to -stable as well.

The actual driver (patch #3) is new driver, so it can't introduce regressions,
thus I think it can go to 2.6.36 as well.

I already have report form one user that driver works.


Best regards,
        Maxim Levitsky

 

