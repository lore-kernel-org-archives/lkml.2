Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756569Ab2ADRSE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 12:18:04 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:51080 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756422Ab2ADRSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 12:18:03 -0500
MIME-Version: 1.0
Date: Wed, 4 Jan 2012 11:18:01 -0600
Message-ID: <CAH2r5mup_rpBGmiUGFexaaZtdN2zRP8=v9Dy5YTiQ0pY0U89nA@mail.gmail.com>
Subject: [GIT] CIFS Fixes
From: Steve French <smfrench@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-cifs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit f9fab10bbd768b0e5254e53a4a8477a94bfc4b96:

  hung_task: fix false positive during vfork (2012-01-03 16:14:32 -0800)

are available in the git repository at:
  git://git.samba.org/sfrench/cifs-2.6.git master

Jeff Layton (1):
      cifs: fix bad buffer length check in coalesce_t2

Steve French (1):
      [CIFS] default ntlmv2 for cifs mount delayed to 3.3

 fs/cifs/connect.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)


-- 
Thanks,

Steve
