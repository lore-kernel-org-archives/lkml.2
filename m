Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011Ab2HUIA2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 04:00:28 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:63797 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900Ab2HUIAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 04:00:24 -0400
Date: Tue, 21 Aug 2012 10:00:19 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] x86 fixes
Message-ID: <20120821080019.GB11135@gmail.com>
References: <20120820092114.GA9875@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120820092114.GA9875@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@kernel.org> wrote:

> Linus,
> 
> Please pull the latest x86-urgent-for-linus git tree from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-urgent-for-linus
> 
>    HEAD: 515c7af85ed92696c311c53d53cb4898ff32d784 x32: Use compat shims for {g,s}etsockopt
> 
> Please have an extra look at:
> 
>   515c7af85ed9 x32: Use compat shims for {g,s}etsockopt
> 
> Which contains a socket ABI fix with a -stable backport tag.

Otherwise the rest are small fixlets.

Thanks,

	Ingo
