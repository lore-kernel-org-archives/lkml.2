Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689Ab2JNQkY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 12:40:24 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:43364 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754497Ab2JNQkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 12:40:23 -0400
Date: Sun, 14 Oct 2012 17:40:20 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Daniel Mack <zonque@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: [revert request for commit 9fff2fa] Re: [git pull] signals pile 3
Message-ID: <20121014164020.GV2616@ZenIV.linux.org.uk>
References: <20121013005334.GM2616@ZenIV.linux.org.uk>
 <507ADBBB.9090209@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <507ADBBB.9090209@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 14, 2012 at 05:35:23PM +0200, Daniel Mack wrote:

> I rebased my ARM development branch and figured that your patch 9fff2fa
> ("arm: switch to saner kernel_execve() semantics") breaks the boot on my
> board right after init is invoked via NFS:

OK, revert it is, then.  Nothing in the tree has dependencies on that sucker
and while it survives testing here, it's obviously not ready for mainline.
So, with abject apologies to everyone involved, please revert.
