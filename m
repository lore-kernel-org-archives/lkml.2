Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752306Ab2KLGIz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 01:08:55 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:35750 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219Ab2KLGIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 01:08:54 -0500
MIME-Version: 1.0
From: Bryan Wu <cooloney@gmail.com>
Date: Sun, 11 Nov 2012 22:08:32 -0800
Message-ID: <CAK5ve-+a==5e6rGm-5zGLh4fvOHOKonv8r+htiS98=qh_mLi9A@mail.gmail.com>
Subject: [GIT PULL] a LED fix for 3.7
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux LED Subsystem <linux-leds@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please consider the following changes since commit
77b67063bb6bce6d475e910d3b886a606d0d91f7:

  Linux 3.7-rc5 (2012-11-11 13:44:33 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cooloney/linux-leds.git
fixes-for-3.7

for you to fetch changes up to 0b8728d6f140dc20690384286ade47c956edc999:

  ledtrig-cpu: kill useless mutex to fix sleep in atomic context
(2012-11-11 12:09:43 -0800)

----------------------------------------------------------------
Nathan Lynch (1):
      ledtrig-cpu: kill useless mutex to fix sleep in atomic context

 drivers/leds/ledtrig-cpu.c |   21 ---------------------
 1 file changed, 21 deletions(-)
