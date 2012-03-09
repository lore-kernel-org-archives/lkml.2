Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756795Ab2CIOgB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 09:36:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8304 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756621Ab2CIOf6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 09:35:58 -0500
Subject: [GIT PULL] C6X: fix KSTK_EIP and KSTK_ESP macros
From: Mark Salter <msalter@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Date: Fri, 09 Mar 2012 09:35:56 -0500
Organization: Red Hat, Inc
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <1331303757.12805.65.camel@deneb.redhat.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 6b21d18ed50c7d145220b0724ea7f2613abf0f95:

  Linux 3.3-rc5 (2012-02-25 12:18:16 -0800)

are available in the git repository at:

  git://linux-c6x.org/git/projects/linux-c6x-upstreaming.git tags/for-linus

for you to fetch changes up to 4cd7c0a03ea44ef88fa0d3901d671798d23cbc35:

  C6X: fix KSTK_EIP and KSTK_ESP macros (2012-03-07 11:28:22 -0500)

----------------------------------------------------------------
Fix for C6X KSTK_EIP and KSTK_ESP macros.

----------------------------------------------------------------
Mark Salter (1):
      C6X: fix KSTK_EIP and KSTK_ESP macros

 arch/c6x/include/asm/processor.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)


