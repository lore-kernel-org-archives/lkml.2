Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345Ab2LaCrc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2012 21:47:32 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:49460 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054Ab2LaCra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2012 21:47:30 -0500
From: Michel Lespinasse <walken@google.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>
Subject: [PATCH 0/2] extend synchro-test module to test spinlocks too
Date: Sun, 30 Dec 2012 18:47:12 -0800
Message-Id: <1356922034-25165-1-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wanted a synthetic test to help me understand the performance of Rik's
proposed spinlock proportional backoff patches, and the synchro-test
in andrew's mmotm tree looked like an obvious candidate to be extended,
so I ended up with the following couple patches.

I'm not sure whats' the back story with synchro-test though - they seem
to have been stuck in andrew's tree for a very long time now. Is there
any reason delaying their inclusion or is it just that nobody's been
pushing for them ?

Michel Lespinasse (2):
  add spinlock test to synchro-test module
  Document default load and interval values in synchro-test module

 Documentation/synchro-test.txt |    4 +-
 kernel/synchro-test.c          |   76 ++++++++++++++++++++++++++++++++++++---
 2 files changed, 72 insertions(+), 8 deletions(-)

-- 
1.7.7.3

