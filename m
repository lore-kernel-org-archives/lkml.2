Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996Ab2GLAoy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 20:44:54 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62902 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717Ab2GLAox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 20:44:53 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: Richard Fontana <fontana2012@gmail.com>
Cc: "Bradley M. Kuhn" <bkuhn@ebb.org>, linux-kernel@vger.kernel.org,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 0/4] copyleft-next: first set of patches
Date: Wed, 11 Jul 2012 17:44:45 -0700
Message-Id: <1342053889-32066-1-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 1.7.10.rc1.22.gf5241
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

Fontana,

Here is my first series of patches against the new copyleft-next.git
project [0]. These patches consists of a few cosmetic changes along
with the idea of embracing the usage of the Signed-off-by tag. I've
decided to use lkml given since there is no mailing list set up yet
and I could not think of a more public mailing list I could use.
Maybe we could just use it for now, what's a little more lkml spam ?

I've decided to Cc bkuhn, perhaps he doesn't want to be, but oh well,
he knows a lot on these matters.

[0] git://gitorious.org/copyleft-next/copyleft-next.git

Luis R. Rodriguez (4):
  copyleft-next: remove issue tracker references
  copyleft-next: more project name updates Copyleft.next->copyleft-next
  copyleft-next: rename the file COPYLEFT.next to copyleft-next
  copyleft-next: embrace the Signed-off-by practice

 ABOUT                          |   10 ++++-----
 CONTRIBUTING                   |   45 ++++++++++++++++++++++++++++------------
 COPYLEFT.next => copyleft-next |    6 +++---
 3 files changed, 40 insertions(+), 21 deletions(-)
 rename COPYLEFT.next => copyleft-next (99%)

-- 
1.7.10.rc1.22.gf5241

