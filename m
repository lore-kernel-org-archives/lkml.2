Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525Ab2BFGW0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 01:22:26 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:62917 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752005Ab2BFGWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 01:22:25 -0500
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sun, 5 Feb 2012 23:22:04 -0700
X-Google-Sender-Auth: jqhNVFfdxaRKWH4h7MU3BDLalRY
Message-ID: <CACxGe6uAmPaxrnVcB0Qd3Lc33c2K0bq0z6V_FAMVG3rJ9RAPsg@mail.gmail.com>
Subject: [git pull] GPIO bug fixes
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

GPIO bug fixes here. Description embedded in the signed tag.

g.


The following changes since commit 23783f817bceedd6d4e549385e3f400ea64059e5:

  Merge tag 'pm-fixes-for-3.3-rc3' of
git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm
(2012-02-04 15:21:39 -0800)

are available in the git repository at:

  git://git.secretlab.ca/git/linux-2.6 gpio-for-linus

Axel Lin (2):
      gpio: Add missing spin_lock_init in gpio-pch driver
      gpio: Add missing spin_lock_init in gpio-ml-ioh driver

Roland Stigge (1):
      Correct bad gpio naming

Thomas Abraham (1):
      gpio: samsung: adapt to changes in gpio specifier translator
function declaration

 drivers/gpio/gpio-lpc32xx.c |    2 +-
 drivers/gpio/gpio-ml-ioh.c  |    1 +
 drivers/gpio/gpio-pch.c     |    1 +
 drivers/gpio/gpio-samsung.c |   23 +++++++++++++----------
 4 files changed, 16 insertions(+), 11 deletions(-)


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
