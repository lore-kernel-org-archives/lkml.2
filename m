Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756403Ab0H3Ryz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 13:54:55 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:49400 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755674Ab0H3Ryy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 13:54:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=rfieD7dBVVR3V3tNT0+JVd0JsDhfeL8SoKfJIcURx1NLFxYH7F6ej9BC9i4D3pNJ7Y
         x/QZ9G/MF29WE3sUCbW5jJ6/K7UzAcX8kZqGkZ/twduvRiYe6JWvarsKOnDy8HaOzFtZ
         hz5RfXuu2tJKpD6V2IT9313+BZbHrYQCzUVcQ=
MIME-Version: 1.0
Date: Mon, 30 Aug 2010 12:54:53 -0500
Message-ID: <AANLkTikNn-t9OazAau6ArCzs1WRbW+QNfF_X=S_NwZUW@mail.gmail.com>
Subject: [GIT PULL] 9p file system bug fixes for 2.6.36-rc4
From: Eric Van Hensbergen <ericvh@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 2bfc96a127bc1cc94d26bfaa40159966064f9c8c:
  Linus Torvalds (1):
        Linux 2.6.36-rc3

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/ericvh/v9fs.git for-linus

Dan Carpenter (1):
      9p: potential ERR_PTR() dereference

 fs/9p/fid.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)
