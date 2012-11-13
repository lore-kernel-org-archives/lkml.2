Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051Ab2KMP4Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 10:56:25 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:54136 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851Ab2KMP4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 10:56:23 -0500
Date: Tue, 13 Nov 2012 16:56:12 +0100
From: Robert Richter <rric@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, jun.zhang@intel.com,
        tglx@linutronix.de, hpa@linux.intel.com, wei.yang@windriver.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86-32: Fix invalid stack address while in
 softirq
Message-ID: <20121113155612.GH2504@rric.localhost>
References: <20120912135059.GZ8285@erda.amd.com>
 <tip-fa22b5dfbea95c14dd96da264e80cac68857ceb7@git.kernel.org>
 <20121113151727.GA20400@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121113151727.GA20400@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13.11.12 16:17:27, Ingo Molnar wrote:
> 
> * tip-bot for Robert Richter <robert.richter@amd.com> wrote:
> 
> > Commit-ID:  fa22b5dfbea95c14dd96da264e80cac68857ceb7
> > Gitweb:     http://git.kernel.org/tip/fa22b5dfbea95c14dd96da264e80cac68857ceb7
> > Author:     Robert Richter <robert.richter@amd.com>
> > AuthorDate: Mon, 3 Sep 2012 20:54:48 +0200
> > Committer:  H. Peter Anvin <hpa@linux.intel.com>
> > CommitDate: Wed, 31 Oct 2012 14:25:18 -0700
> > 
> > x86-32: Fix invalid stack address while in softirq
> 
> Had to remove this one because it broke the 32-bit allmodconfig 
> build:
> 
> ERROR: "kernel_stack_pointer" [arch/x86/oprofile/oprofile.ko] undefined!

Argh! Will look at this.

-Robert
