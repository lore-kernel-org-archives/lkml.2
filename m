Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757406Ab2BXP2o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 10:28:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62094 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756111Ab2BXP2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 10:28:43 -0500
Subject: [GIT PULL] c6x fix for dtc -d option
From: Mark Salter <msalter@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Date: Fri, 24 Feb 2012 10:28:40 -0500
Organization: Red Hat, Inc
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <1330097321.17322.83.camel@deneb.redhat.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit dcd6c92267155e70a94b3927bce681ce74b80d1f:

  Linux 3.3-rc1 (2012-01-19 15:04:48 -0800)

are available in the git repository at:

  git://linux-c6x.org/git/projects/linux-c6x-upstreaming.git tags/for-linus

for you to fetch changes up to 62e37ca78b1a4ca2eb77875bfd7ac63a7e068c67:

  Kbuild: Use dtc's -d (dependency) option (2012-02-14 21:14:44 -0500)

----------------------------------------------------------------
This is the arch/c6x part of commit 7c43185138cf523b0810ffd2c9e18e2ecb356730
which was dropped because c6x had not yet been merged at the time.

----------------------------------------------------------------
Stephen Warren (1):
      Kbuild: Use dtc's -d (dependency) option

 arch/c6x/boot/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


