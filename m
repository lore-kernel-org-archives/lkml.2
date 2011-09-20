Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751730Ab1ITEtS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 00:49:18 -0400
Received: from mail-qw0-f42.google.com ([209.85.216.42]:60676 "EHLO
	mail-qw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836Ab1ITEtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 00:49:16 -0400
MIME-Version: 1.0
Date: Mon, 19 Sep 2011 23:49:14 -0500
Message-ID: <CAH2r5munKhMMq3GpRp_iEmrb7t3ATZjkubciwTyCe_R2aUdodw@mail.gmail.com>
Subject: [GIT] CIFS Fixes
From: Steve French <smfrench@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-cifs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 9d037a777695993ec7437e5f451647dea7919d4c:
  Linus Torvalds (1):
        Merge branch 'irq-fixes-for-linus' of
git://tesla.tglx.de/git/linux-2.6-tip

are available in the git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git master

Jeff Layton (1):
      cifs: fix possible memory corruption in CIFSFindNext

Pavel Shilovsky (1):
      CIFS: Fix ERR_PTR dereference in cifs_get_root

Shirish Pargaonkar (1):
      cifs: Fix broken sec=ntlmv2/i sec option (try #2)

Steve French (1):
      Fix the conflict between rwpidforward and rw mount options


-- 
Thanks,

Steve
