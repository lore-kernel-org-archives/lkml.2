Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113Ab2IJBNf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 21:13:35 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:51614 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755851Ab2IJBNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 21:13:34 -0400
Date: Mon, 10 Sep 2012 02:13:32 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [signal] WARNING: at kernel/lockdep.c:2623
 trace_hardirqs_off_caller()
Message-ID: <20120910011332.GN13973@ZenIV.linux.org.uk>
References: <20120910004753.GB27699@localhost>
 <20120910010706.GA28067@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120910010706.GA28067@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2012 at 09:07:07AM +0800, Fengguang Wu wrote:
> Not sure if it's an unrelated warning, but anyway.
> 
> commit: c2865bb326476f031ce7121e876c656cdc12c894 [13/18] x86, um/x86: switch to generic sys_execve and kernel_execve

[commit in experimental-kernel_thread, not one in execve2/for-next/master]

Again, experimental-kernel_thread is build-only for now.  Is there any
regular way to tell your script that it should be either skipped or
only build-tested?
