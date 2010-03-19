Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751176Ab0CSE5x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 00:57:53 -0400
Received: from mail-yw0-f198.google.com ([209.85.211.198]:43818 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087Ab0CSE5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 00:57:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=M7tTSOh7oIRaFh8HkDV3nA1t3rndLQq/3+0GDwYCjM/BO3OscgvUA0p2Q7L8uu9Yac
         wLLTc/M3L8oIIfQedPrBO+xxob4ZLraOZ0DbjwunPWOlYc09icLtCecVWl6HouugnlHK
         hLWBEHVnY80XOYwRx0CYqIqgx2YJlDwNTe50Q=
MIME-Version: 1.0
Date: Fri, 19 Mar 2010 00:57:50 -0400
Message-ID: <b4198de61003182157wd019926o4bc1cff1faf898ce@mail.gmail.com>
Subject: [PULL] alpha-2.6
From: Matt Turner <mattst88@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-alpha@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the 'for-linus' branch from
ssh://master.kernel.org/pub/scm/linux/kernel/git/mattst88/alpha-2.6.git
for-linus

It contains a couple trivial changes and a build fix for a recent regression.

Thanks,
Matt Turner

The following changes since commit 39710479303fd3affb3e204e9a7a75cc676977b5:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../vapier/blackfin

are available in the git repository at:

git://git.kernel.org/pub/scm/linux/kernel/git/mattst88/alpha-2.6.git  for-linus

Akinobu Mita (1):
      alpha: use __ratelimit

FUJITA Tomonori (1):
      alpha: fix compile errors in dma-mapping-common.h

Frans Pop (1):
      alpha: remove trailing spaces in messages

 arch/alpha/include/asm/core_marvel.h  |    1 -
 arch/alpha/include/asm/core_mcpcia.h  |    1 -
 arch/alpha/include/asm/core_titan.h   |    1 -
 arch/alpha/include/asm/core_tsunami.h |    1 -
 arch/alpha/kernel/sys_dp264.c         |    2 +-
 arch/alpha/kernel/sys_titan.c         |    2 +-
 arch/alpha/kernel/traps.c             |   10 +++-------
 7 files changed, 5 insertions(+), 13 deletions(-)
