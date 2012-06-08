Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933951Ab2FHIwj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 04:52:39 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:56854 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932819Ab2FHIwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 04:52:35 -0400
Date: Fri, 8 Jun 2012 10:52:29 +0200
From: Ingo Molnar <mingo@kernel.org>
To: hpa@zytor.com, linux-kernel@vger.kernel.org, shai@scalemp.com,
        kiran.thirumalai@gmail.com, tglx@linutronix.de, ido@wizery.com
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/platform] x86/vsmp: Ignore IOAPIC IRQ affinity if
 possible
Message-ID: <20120608085229.GA10638@gmail.com>
References: <1338675095-27260-2-git-send-email-ido@wizery.com>
 <tip-3aabb53ce5849605cee731bbc32f37120b4c4ceb@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-3aabb53ce5849605cee731bbc32f37120b4c4ceb@git.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* tip-bot for Ravikiran Thirumalai <kiran.thirumalai@gmail.com> wrote:

> Commit-ID:  3aabb53ce5849605cee731bbc32f37120b4c4ceb
> Gitweb:     http://git.kernel.org/tip/3aabb53ce5849605cee731bbc32f37120b4c4ceb
> Author:     Ravikiran Thirumalai <kiran.thirumalai@gmail.com>
> AuthorDate: Sun, 3 Jun 2012 01:11:35 +0300
> Committer:  Ingo Molnar <mingo@kernel.org>
> CommitDate: Wed, 6 Jun 2012 09:06:20 +0200
> 
> x86/vsmp: Ignore IOAPIC IRQ affinity if possible

This patch causes the following build failure:

 (.init.text+0x10626): undefined reference to `no_irq_affinity'

on UP kernels.

Thanks,

	Ingo
