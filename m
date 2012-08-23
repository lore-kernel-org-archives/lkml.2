Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758665Ab2HWMur (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 08:50:47 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55497 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177Ab2HWMuo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 08:50:44 -0400
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Thu, 23 Aug 2012 17:50:24 +0500
X-Google-Sender-Auth: qbEnWPcxNoa2mh1dy2Jiabr2IkQ
Message-ID: <CAB=NE6Xsx-5J_F3SA9XGzACCxvp4dnL1tKYN8X+QeqVTzjbSKQ@mail.gmail.com>
Subject: [ANN] compat-drivers
To: backports@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In synch with linux-next.git next-20120822, compat-2012-08-22,
compat-drivers-2012-08-22 now has been test compiled successfully over
21 kernels. This has the drm drivers Ozan Çağlayan added as part of
his GSoC project. For those unfamiliar with the tagging process I add
a tag to either compat or compat-drivers *only* if I can guarantee
compilation over all supported vanilla kernels, the tags will match
the same date as the ones from linux-next. Not too shabby for only
1.1645% of code being backport code. So -- it seems we're on track
with a drm driver integration set for compat-drivers for v3.7.

The new compat-drivers project wiki:

https://backports.wiki.kernel.org

mcgrof@garbanzo ~/devel/compat-drivers (git::master)$ time ckmake
Trying kernel 3.5.0-030500-generic [OK]
Trying kernel 3.4.4-030404-generic [OK]
Trying kernel 3.3.7-030307-generic [OK]
Trying kernel 3.2.2-030202-generic [OK]
Trying kernel 3.1.10-030110-generic [OK]
Trying kernel 3.0.18-030018-generic [OK]
Trying kernel 2.6.39-02063904-generic [OK]
Trying kernel 2.6.38-02063808-generic [OK]
Trying kernel 2.6.37-02063706-generic [OK]
Trying kernel 2.6.36-02063604-generic [OK]
Trying kernel 2.6.35-02063512-generic [OK]
Trying kernel 2.6.34-02063410-generic [OK]
Trying kernel 2.6.33-02063305-generic [OK]
Trying kernel 2.6.32-02063255-generic [OK]
Trying kernel 2.6.31-02063113-generic [OK]
Trying kernel 2.6.30-02063010-generic [OK]
Trying kernel 2.6.29-02062906-generic [OK]
Trying kernel 2.6.28-02062810-generic [OK]
Trying kernel 2.6.27-020627-generic [OK]
Trying kernel 2.6.26-020626-generic [OK]
Trying kernel 2.6.25-020625-generic [OK]
Trying kernel 2.6.24-020624-generic [OK]

real    26m36.168s
user    139m24.967s
sys     13m13.114s

Stats:

Updated from local tree: /home/mcgrof/linux-next
Origin remote URL:
git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
This is a linux-next.git compat-drivers release

compat-drivers code metrics

   1202023 - Total upstream lines of code being pulled
      3041 - backport code changes
      2546 - backport code additions
       495 - backport code deletions
     13767 - backport from compat module
     16808 - total backport code
    1.3983 - % of code consists of backport work
       230 - backport code changes
       180 - backport code additions
        50 - backport code deletions
     13767 - backport from compat module
     13997 - total backport code
    1.1645 - % of code consists of backport work

Base tree: linux-next.git
Base tree version: next-20120822
compat.git: compat-2012-08-22
compat-drivers release: compat-drivers-2012-08-22
Code metrics archive: http://bit.ly/H6BTF7

  Luis
