Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577Ab2KMPRf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 10:17:35 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:56070 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779Ab2KMPRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 10:17:34 -0500
Date: Tue, 13 Nov 2012 16:17:27 +0100
From: Ingo Molnar <mingo@kernel.org>
To: hpa@zytor.com, linux-kernel@vger.kernel.org, robert.richter@amd.com,
        jun.zhang@intel.com, tglx@linutronix.de, hpa@linux.intel.com,
        wei.yang@windriver.com
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86-32: Fix invalid stack address while in
 softirq
Message-ID: <20121113151727.GA20400@gmail.com>
References: <20120912135059.GZ8285@erda.amd.com>
 <tip-fa22b5dfbea95c14dd96da264e80cac68857ceb7@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-fa22b5dfbea95c14dd96da264e80cac68857ceb7@git.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* tip-bot for Robert Richter <robert.richter@amd.com> wrote:

> Commit-ID:  fa22b5dfbea95c14dd96da264e80cac68857ceb7
> Gitweb:     http://git.kernel.org/tip/fa22b5dfbea95c14dd96da264e80cac68857ceb7
> Author:     Robert Richter <robert.richter@amd.com>
> AuthorDate: Mon, 3 Sep 2012 20:54:48 +0200
> Committer:  H. Peter Anvin <hpa@linux.intel.com>
> CommitDate: Wed, 31 Oct 2012 14:25:18 -0700
> 
> x86-32: Fix invalid stack address while in softirq

Had to remove this one because it broke the 32-bit allmodconfig 
build:

ERROR: "kernel_stack_pointer" [arch/x86/oprofile/oprofile.ko] undefined!

Thanks,

	Ingo
