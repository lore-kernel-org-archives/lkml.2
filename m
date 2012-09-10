Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581Ab2IJWUL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 18:20:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30451 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752686Ab2IJWUI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 18:20:08 -0400
From: Mark Salter <msalter@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Mark Salter <msalter@redhat.com>
Subject: Re: [RFC] status of execve() work - per-architecture patches solicited
Date: Mon, 10 Sep 2012 18:20:01 -0400
Message-Id: <1347315603-30027-1-git-send-email-msalter@redhat.com>
In-Reply-To: <20120907182004.GE13973@ZenIV.linux.org.uk>
References: <20120907182004.GE13973@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

C6X works fine with these patches to switch over to generic code.


Mark Salter (2):
  c6x: implement ret_from_kernel_execve() and switch to generic
    kernel_execve()
  c6x: switch to generic sys_execve()

 arch/c6x/include/asm/syscalls.h |    5 ---
 arch/c6x/include/asm/unistd.h   |    3 ++
 arch/c6x/kernel/entry.S         |   54 +++++++++++++++++---------------------
 arch/c6x/kernel/process.c       |   22 ----------------
 4 files changed, 27 insertions(+), 57 deletions(-)

-- 
1.7.9.1

