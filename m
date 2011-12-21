Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599Ab1LUBQJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 20:16:09 -0500
Received: from tundra.namei.org ([65.99.196.166]:42224 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751977Ab1LUBQH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 20:16:07 -0500
Date: Wed, 21 Dec 2011 12:16:03 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] Security subsystem fixes
Message-ID: <alpine.LRH.2.00.1112211215260.7754@tundra.namei.org>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull these fixes.


The following changes since commit a4a4923919f2d43583789b1f3603f4e5600d8321:
  Linus Torvalds (1):
        Merge branch 'for-3.2-fixes' of git://git.kernel.org/.../tj/cgroup

are available in the git repository at:

  git://git.selinuxproject.org/~jmorris/linux-security for-linus

David Howells (1):
      SELinux: Fix RCU deref check warning in sel_netport_insert()

Dmitry Kasatkin (2):
      evm: key must be set once during initialization
      evm: prevent racing during tfm allocation

James Morris (1):
      Merge branch 'evm-fixes' of git://git.kernel.org/.../kasatkin/linux-digsig into for-linus

 security/integrity/evm/evm_crypto.c |   19 +++++++++++++++----
 security/selinux/netport.c          |    4 +++-
 2 files changed, 18 insertions(+), 5 deletions(-)
