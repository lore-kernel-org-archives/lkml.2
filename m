Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932305Ab0LTOSL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 09:18:11 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57916 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757829Ab0LTOSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 09:18:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=OH+wNGKf0z1NK3l1y3zZaKUdqqXW2ASDULR9dNGM43HypM3XT3OVW9D5o5sCYjVO2u
         yN1z+F2q/oxOqyGI2SpqGRfEEFOzIyY9eYHcHQwlBFkiGehdntGuo3/8selX4oIlOFzZ
         UhuNiTebouaoPgf6oQqCzpyvdEhBA/zHWpLPk=
From: Franck Bui-Huu <vagabon.xyz@gmail.com>
To: masami.hiramatsu.pt@hitachi.com
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] Minor cleanups & fixes for perf-probe(1)
Date: Mon, 20 Dec 2010 15:17:59 +0100
Message-Id: <1292854685-8230-1-git-send-email-fbuihuu@gmail.com>
X-Mailer: git-send-email 1.7.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Franck Bui-Huu <fbuihuu@gmail.com>

Hi,

This small patchset is just some random cosmetic cleanups I did when
starting to read perf-probe(1) stuffs.

The 3 last patches of this serie are minor fixes though.

---

Franck Bui-Huu (6):
  perf-tools: make perf-probe -L display the absolute path of the dumped file
  perf-probe: rewrite show_one_line() to make it simpler
  perf-probe: clean up redundant tests in show_line_range()
  perf-probe: Fix line range description since a single file is allowed
  perf-probe: don't always consider EOF as an error when listing source code
  perf-probe: handle gracefully some stupid and buggy line syntaxes

 tools/perf/Documentation/perf-probe.txt |    2 +-
 tools/perf/util/probe-event.c           |  190 +++++++++++++++++++------------
 2 files changed, 117 insertions(+), 75 deletions(-)

-- 
1.7.3.2

