Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993Ab1ASWFW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 17:05:22 -0500
Received: from tundra.namei.org ([65.99.196.166]:43647 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753643Ab1ASWFT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 17:05:19 -0500
Date: Thu, 20 Jan 2011 09:04:47 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] Security subsystem bugfixes for 2.6.38
Message-ID: <alpine.LRH.2.00.1101200902400.5588@tundra.namei.org>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull the following bugfixes for the trusted keys code.

The following changes since commit c56eb8fb6dccb83d9fe62fd4dc00c834de9bc470:
  Linus Torvalds (1):
        Linux 2.6.38-rc1

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6 for-linus

Mimi Zohar (1):
      trusted-keys: free memory bugfix

Tetsuo Handa (3):
      trusted-keys: another free memory bugfix
      trusted-keys: check for NULL before using it
      trusted-keys: avoid scattring va_end()

 security/keys/trusted_defined.c |   51 +++++++++++++++++++++-----------------
 1 files changed, 28 insertions(+), 23 deletions(-)


-- 
James Morris
<jmorris@namei.org>
