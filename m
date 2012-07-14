Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160Ab2GNTqs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 15:46:48 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:38716 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917Ab2GNTqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 15:46:42 -0400
Message-ID: <5001CC9A.9040808@kernel.org>
Date: Sat, 14 Jul 2012 15:46:34 -0400
From: Len Brown <lenb@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-acpi <linux-acpi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] ACPI patch for Linux-3.5-rc6 - take 2
References: <5001B05D.7070408@kernel.org> <CA+55aFxmhDxZgsPy+23h0joBx4==-0jBQBoAqBbrmVOaBbSFjQ@mail.gmail.com>
In-Reply-To: <CA+55aFxmhDxZgsPy+23h0joBx4==-0jBQBoAqBbrmVOaBbSFjQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull these ACPI & Power Management patches.

this pull message is identical to take 1 except adds "release" branch.
I can't explain why it was missing, as it is hard-coded into the script
that make this message.  Perhaps a mouse error when I edited the e-mail...

thanks!

Len Brown, Intel Open Source Technology Center

The following changes since commit fdb1335a82ef1ef9442ac9377796e4e7a69d1ae4:

  Merge tag 'md-3.5-fixes' of git://neil.brown.name/md (2012-07-13 17:59:33 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux.git release

for you to fetch changes up to 46befd6b38d802dfc5998e7d7938854578b45d9d:

  ACPICA: Fix possible fault in return package object repair code (2012-07-14 11:38:41 -0400)

----------------------------------------------------------------
Bob Moore (1):
      ACPICA: Fix possible fault in return package object repair code

 drivers/acpi/acpica/nspredef.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
