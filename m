Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854Ab0HQHwH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 03:52:07 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:56958 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337Ab0HQHwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 03:52:05 -0400
Message-Id: <201008170751.o7H7pmAl038739@www262.sakura.ne.jp>
Subject: Re: [2.6.36-rc1] List corruption when using initrd.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: tim.c.chen@linux.intel.com, hughd@google.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Tue, 17 Aug 2010 16:51:47 +0900
References: <201008170517.o7H5HbCT002910@www262.sakura.ne.jp>
In-Reply-To: <201008170517.o7H5HbCT002910@www262.sakura.ne.jp>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 17082010 #3879376, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tetsuo Handa wrote:
> I get list_add corruption message when booting with initrd on Debian Sarge.

Bisection completed.

commit 7e496299d4d2ad8083effed6c5a18313a919edc6
tmpfs: make tmpfs scalable with percpu_counter for used blocks

Regards.
