Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752270Ab2KTTzM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 14:55:12 -0500
Received: from smtp.outflux.net ([198.145.64.163]:45644 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751530Ab2KTTzK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 14:55:10 -0500
Date: Tue, 20 Nov 2012 11:55:03 -0800
From: Kees Cook <keescook@chromium.org>
To: James Morris <jmorris@namei.org>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Johansen <john.johansen@canonical.com>,
        Kees Cook <keescook@chromium.org>,
        "Serge E. Hallyn" <serge.hallyn@ubuntu.com>
Subject: [PULL] Yama update (3.8)
Message-ID: <20121120195503.GA28563@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

Please pull these Yama changes for 3.8. Thanks!

-Kees,

The following changes since commit b5666502700855a1eb1a15482005b22478b9460e:

  drivers/char/tpm: remove tasklet and cleanup (2012-11-01 15:23:14 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git tags/yama-3.8

for you to fetch changes up to 235e752789eb65a81477bb82845323dfcbf93012:

  Yama: remove locking from delete path (2012-11-20 10:32:08 -0800)

----------------------------------------------------------------
Yama features for 3.8:
- replacing locks with RCU
- replacing in-place delete with workqueue

----------------------------------------------------------------
Kees Cook (2):
      Yama: add RCU to drop read locking
      Yama: remove locking from delete path

 security/yama/yama_lsm.c |   88 ++++++++++++++++++++++++++++++++--------------
 1 file changed, 62 insertions(+), 26 deletions(-)

-- 
Kees Cook
Chrome OS Security
