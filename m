Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757960Ab1DYAf5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Apr 2011 20:35:57 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:43569 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757850Ab1DYAfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Apr 2011 20:35:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=e79GaQ5Gk0ESEAtoB8QzITMy7h8dpGyEzi3SWznHbMG2ntLQPwvjOA+JTYllja3n6n
         fjWpTcJ2eccH/DFarWg29XPH3EiR7DBp360tL7X2BTLf7JXVJkNVxWB4pmSSMEYZmnf7
         vokFapqEHE2U+mKCpQUh7SVo0cBGy9EtnLDCc=
From: Aaron Faanes <dafrito@gmail.com>
To: John McCutchan <john@johnmccutchan.com>, Robert Love <rlove@rlove.org>,
        Eric Paris <eparis@parisplace.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Aaron Faanes <dafrito@gmail.com>
Subject: [PATCH 0/3] Documentation/filesystems/inotify.txt edits
Date: Sun, 24 Apr 2011 19:35:01 -0500
Message-Id: <1303691704-5726-1-git-send-email-dafrito@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some minor proofreading changes in inotify.txt.

Aaron Faanes (3):
  Documentation: remove some spurious spaces in inotify.txt
  Documentation: Correct a couple missing words in inotify.txt
  Documentation: Reword example about inotify's fd-per-instance design

 Documentation/filesystems/inotify.txt |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

-- 
1.7.4.4

