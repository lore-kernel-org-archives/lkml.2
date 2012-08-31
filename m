Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590Ab2HaNS0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 09:18:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62059 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841Ab2HaNSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 09:18:24 -0400
From: Cruz Julian Bishop <cruzjbishop@gmail.com>
To: mcgrof@gmail.com
Cc: linux-kernel@vger.kernel.org, Cruz Julian Bishop <cruzjbishop@gmail.com>
Subject: [PATCH 0/4] scripts/checkpatch.pl: A small step for Linux...
Date: Fri, 31 Aug 2012 23:18:06 +1000
Message-Id: <1346419090-3808-1-git-send-email-cruzjbishop@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

...and a big step for learning more Perl.

Hi!

This patch set started off as an experiment, but as I continued, I
realised that I should submit this and see if it's suitable for merging
into Linux.

To start off with, here's some patches for checkincludes.pl

This set was created for the following purposes:

    1: Making it slightly easier to read
    2: Making it easier to extend and add new arguments
    3: Changing the usage output to look more "correct"
    4: Introducing a 'quiet' mode like checkpatch.pl, and printing
        messages for files without duplicated includes by default
       
Sorry if I did anything wrong - It's my first time really
experimenting with Perl. 

Thanks in advance.

~Cruz

Cruz Julian Bishop (4):
  scripts/checkincludes.pl: Print usage with heredoc
  scripts/checkincludes.pl: Simplify and shorten argument logic
  scripts/checkincludes.pl: Fix a bug introduced in the last commit
  scripts/checkincludes.pl: Introduce 'quiet' mode

 scripts/checkincludes.pl |  113 ++++++++++++++++++++++++++--------------------
 1 file changed, 65 insertions(+), 48 deletions(-)

-- 
1.7.9.5

