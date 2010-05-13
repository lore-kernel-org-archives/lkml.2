Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757646Ab0EMRc4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 13:32:56 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:56927 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757281Ab0EMRcw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 13:32:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=NQFCwesDzlC0uLNOK6lar6ORj5topoJbuBn0fxcHXsp4UCXC5ZCrKc+uvZnOSPQMla
         1wZHRDv07th3re4CpDFc8XC+nJ025BylMtcf3kHE5JfFUUXxksDneMani1FukX5BBT82
         R3aZTrOVjClonlY6N8/dq9+leB6gjZTKwvKU0=
MIME-Version: 1.0
Date: Thu, 13 May 2010 12:32:50 -0500
Message-ID: <AANLkTinjz1gTR6-zZVePSNLOd5bnnft-SCdGyPr-bFE7@mail.gmail.com>
Subject: [GIT] CIFS fix
From: Steve French <smfrench@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeff Layton <jlayton@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 05ce7bfe547c9fa967d9cab6c37867a9cb6fb3fa:

 Merge branch 'for_linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs-2.6
(2010-04-20 09:39:40 -0700)

are available in the git repository at:

 git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6.git for-linus

Jeff Layton (1):
     cifs: guard against hardlinking directories

fs/cifs/cifsglob.h |    1 +
fs/cifs/inode.c    |   21 +++++++++++++++++++--
2 files changed, 20 insertions(+), 2 deletions(-)


--
Thanks,

Steve
