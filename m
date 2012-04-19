Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932496Ab2DSU0y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 16:26:54 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:60547 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932385Ab2DSU0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 16:26:52 -0400
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Thu, 19 Apr 2012 13:26:30 -0700
X-Google-Sender-Auth: YX5hQajS2mFG6lPmL0N1WptXzwM
Message-ID: <CAB=NE6W9dFr4X=nVtwYtGuPv90cZUat2b8vRb90mdM+8AEOf=w@mail.gmail.com>
Subject: compat-wireless-3.4-rc3-1.tar.bz2 released
To: lf_driver_backport@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've kicked out a new compat-wireless release based on 3.4-rc3 [0],
check out the ChangeLog-3.4-rc3 [1] for more details and if you are
interested in the build log check out the ckmake-3.4-rc1-2.log.bz2
[2].  Below are the code metrics and the ckmake log summary:

compat-wireless code metrics

    829063 - Total upstream lines of code being pulled
      2748 - backport code changes
      2333 - backport code additions
       415 - backport code deletions
      9575 - backport from compat module
     12323 - total backport code
    1.4864 - % of code consists of backport work

Base tree: linux-stable.git
Base tree version: v3.4-rc3
compat-wireless release: compat-wireless-v3.4-rc3-1

Trying kernel 3.2.2-030202-generic	[OK]
Trying kernel 3.1.10-030110-generic	[OK]
Trying kernel 3.0.18-030018-generic	[OK]
Trying kernel 2.6.39-02063904-generic	[OK]
Trying kernel 2.6.38-02063808-generic	[OK]
Trying kernel 2.6.37-02063706-generic	[OK]
Trying kernel 2.6.36-02063604-generic	[OK]
Trying kernel 2.6.35-02063512-generic	[OK]
Trying kernel 2.6.34-02063410-generic	[OK]
Trying kernel 2.6.33-02063305-generic	[OK]
Trying kernel 2.6.32-02063255-generic	[OK]
Trying kernel 2.6.31-02063113-generic	[OK]
Trying kernel 2.6.30-02063010-generic	[OK]
Trying kernel 2.6.29-02062906-generic	[OK]
Trying kernel 2.6.28-02062810-generic	[OK]
Trying kernel 2.6.27-020627-generic	[OK]
Trying kernel 2.6.26-020626-generic	[OK]
Trying kernel 2.6.25-020625-generic	[OK]
Trying kernel 2.6.24-020624-generic	[OK]

[0] http://www.orbit-lab.org/kernel/compat-wireless-3-stable/v3.4/compat-wireless-3.4-rc3-1.tar.bz2
[1] http://www.orbit-lab.org/kernel/compat-wireless-3-stable/v3.4/ChangeLog-3.4-rc3
[2] http://www.orbit-lab.org/kernel/compat-wireless-3-stable/v3.4/ckmake-3.4-rc1-2.log.bz2

  Luis
