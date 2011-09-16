Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687Ab1IPGQe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 02:16:34 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:42736 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398Ab1IPGQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 02:16:33 -0400
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, Joe Perches <joe@perches.com>,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org
Subject: [PATCH 00/44] Staging: cx25821: Fix style issues
Date: Fri, 16 Sep 2011 14:14:33 +0800
Message-Id: <1316153717-7272-1-git-send-email-leonidsbox@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series fixes up style issues in cx25821-video.{c,h} files in
drivers/staging/cx25821

What the heck with patches 5-39? ... Well, in cx25821-video.c file there
are lots of lines starting with 7 spaces where clearly this intented to
be a tab; that is reported by checkpatch.pl script. And even more lines
that start with one or more tabs and 7 spaces; this is intented to be 2
or more tabs instead and this is not reported by checkpatch.pl script
(obviously). So, first, I fix up all that kind of wrong indents and
resulting patch was too big and unreviewable. (around 2K lines) So,
since I haven't thought of better way to make the patch reviewable, I
decided to split that huge patch into small reviewable patches. The
result is 35 patches. %-) If you can think of a better way to deal with
this, let me know.

Leonid V. Fedorenchik (44):
      Staging: cx25821: Fix labels' placement in cx25821-video.c
      Staging: cx25821: Fix function signatures
      Staging: cx25821: Fix obscure line endings
      Staging: cx25821: Fix indent in comment
      Staging: cx25821: Change indent with spaces to tabs 1
      Staging: cx25821: Change indent with spaces to tabs 2
      Staging: cx25821: Change indent with spaces to tabs 3
      Staging: cx25821: Change indent with spaces to tabs 4
      Staging: cx25821: Change indent with spaces to tabs 5
      Staging: cx25821: Change indent with spaces to tabs 6
      Staging: cx25821: Change indent with spaces to tabs 7
      Staging: cx25821: Change indent with spaces to tabs 8
      Staging: cx25821: Change indent with spaces to tabs 9
      Staging: cx25821: Change indent with spaces to tabs 10
      Staging: cx25821: Change indent with spaces to tabs 11
      Staging: cx25821: Change indent with spaces to tabs 12
      Staging: cx25821: Change indent with spaces to tabs 13
      Staging: cx25821: Change indent with spaces to tabs 14
      Staging: cx25821: Change indent with spaces to tabs 15
      Staging: cx25821: Change indent with spaces to tabs 16
      Staging: cx25821: Change indent with spaces to tabs 17
      Staging: cx25821: Change indent with spaces to tabs 18
      Staging: cx25821: Change indent with spaces to tabs 19
      Staging: cx25821: Change indent with spaces to tabs 20
      Staging: cx25821: Change indent with spaces to tabs 21
      Staging: cx25821: Change indent with spaces to tabs 22
      Staging: cx25821: Change indent with spaces to tabs 23
      Staging: cx25821: Change indent with spaces to tabs 24
      Staging: cx25821: Change indent with spaces to tabs 25
      Staging: cx25821: Change indent with spaces to tabs 26
      Staging: cx25821: Change indent with spaces to tabs 27
      Staging: cx25821: Change indent with spaces to tabs 28
      Staging: cx25821: Change indent with spaces to tabs 29
      Staging: cx25821: Change indent with spaces to tabs 30
      Staging: cx25821: Change indent with spaces to tabs 31
      Staging: cx25821: Change indent with spaces to tabs 32
      Staging: cx25821: Change indent with spaces to tabs 33
      Staging: cx25821: Change indent with spaces to tabs 34
      Staging: cx25821: Change indent with spaces to tabs 35
      Staging: cx25821: Fix braces around statements in cx25821-video.c
      Staging: cx25821: Replace :? by if-else in cx25821-video.c
      Staging: cx25821: cx25821-video.h: Line up constant
      Staging: cx25821: cx25821-video.h: Fix indent
      Staging: cx25821: cx25821-video.h: Fix long lines

 drivers/staging/cx25821/cx25821-video.c | 1244 ++++++++++++++++---------------
 drivers/staging/cx25821/cx25821-video.h |   79 ++-
 2 files changed, 669 insertions(+), 654 deletions(-)

