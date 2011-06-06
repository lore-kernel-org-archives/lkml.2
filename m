Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757395Ab1FFS6p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 14:58:45 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34179 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756562Ab1FFS6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 14:58:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=LwOzLNjUPQSwXReZM966cACwGDfs4KPpkmvqeMaQkrVQjrT0YoGu3ZUsI1C5qa0CTr
         LHh9VNMPA5RSaspxvD0DFkZqD7SsAul4xXOtRGo6pIb4oUH7jpFXYXXtZ47nIRH0OK0P
         uLdWcGQNkAVpPwcW02dreWwpKFAUXHcolUW9I=
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Michal Marek <mmarek@suse.cz>, Arnaud Lacombe <lacombar@gmail.com>
Subject: [PATCH 0/9] Random kconfig patches
Date: Mon,  6 Jun 2011 14:58:22 -0400
Message-Id: <1307386711-8866-1-git-send-email-lacombar@gmail.com>
X-Mailer: git-send-email 1.7.3.4.574.g608b.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

You'll find hereafter a serie of relatively trivial (I hope) patches
concerning kconfig. Mostly annotation, deadcode removal, and correctness.
This serie is based on top of v3.0-rc1.

As always, it is also available on my git repo on github:

 git://github.com/lacombar/linux-2.6.git kconfig-trivial

Regards,
 - Arnaud

Arnaud Lacombe (9):
  kconfig: annotate non-trivial fall-trough
  kconfig: fix return code for invalid boolean symbol in
    conf_set_sym_val()
  kconfig: add missing <stdarg.h> inclusion
  kconfig: add missing <ctype.h> inclusion
  kconfig: add missing <stdlib.h> inclusion
  kconfig: nuke reference to SWIG
  kconfig: nuke LKC_DIRECT_LINK cruft
  kconfig/gconf: kill deadcode
  kconfig/gconf: silent missing prototype warnings

 scripts/kconfig/Makefile            |   23 +++++++-------------
 scripts/kconfig/conf.c              |    5 +++-
 scripts/kconfig/confdata.c          |    9 ++++++-
 scripts/kconfig/expr.c              |    1 -
 scripts/kconfig/expr.h              |    3 --
 scripts/kconfig/gconf.c             |   38 +----------------------------------
 scripts/kconfig/kconfig_load.c      |   35 --------------------------------
 scripts/kconfig/kxgettext.c         |    1 -
 scripts/kconfig/lex.zconf.c_shipped |    1 -
 scripts/kconfig/lkc.h               |    5 ----
 scripts/kconfig/mconf.c             |    2 +-
 scripts/kconfig/menu.c              |    3 +-
 scripts/kconfig/nconf.c             |    2 +-
 scripts/kconfig/qconf.cc            |    4 ---
 scripts/kconfig/symbol.c            |    1 -
 scripts/kconfig/util.c              |    2 +
 scripts/kconfig/zconf.l             |    1 -
 scripts/kconfig/zconf.tab.c_shipped |    1 -
 scripts/kconfig/zconf.y             |    1 -
 19 files changed, 26 insertions(+), 112 deletions(-)
 delete mode 100644 scripts/kconfig/kconfig_load.c

-- 
1.7.3.4.574.g608b.dirty

