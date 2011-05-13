Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758009Ab1EMAch (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 20:32:37 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55816 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab1EMAcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 20:32:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=W0jSCbC0aluOqbRg5UAiXmxnGIdxuTTLepJq7zL8glm2vkAqBERyYkWwkaaojn62SI
         C0lIaBxDgIr7N3OraP8DyHaD1Yn6ygN7zQH4RaKJdoUCcGy3QLEWE5tqIPBxSBBTi105
         0A++YD+ACCLfQtH6Wb4XLGEOR+uKyRYpqDcis=
MIME-Version: 1.0
Date: Thu, 12 May 2011 19:32:34 -0500
Message-ID: <BANLkTikOB5f6s9GRgSkMPuAg3_qVP2nRtA@mail.gmail.com>
Subject: [GIT PULL] 9p: memory leak fix against -rc7
From: Eric Van Hensbergen <ericvh@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: V9FS Developers <v9fs-developer@lists.sourceforge.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One last fix if there is still time, its a memory leak, so it can wait
till the merge window if necessary.

         -eric


The following changes since commit 411f05f123cbd7f8aa1edcae86970755a6e2a9d9:

  vsprintf: Turn kptr_restrict off by default (2011-05-12 15:18:16 -0700)

are available in the git repository at:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/ericvh/v9fs.git for-linus

Pedro Scarapicchia Junior (1):
      net/9p/protocol.c: Fix a memory leak

 net/9p/protocol.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)
