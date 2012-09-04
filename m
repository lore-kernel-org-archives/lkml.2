Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757980Ab2IDXKY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 19:10:24 -0400
Received: from ozlabs.org ([203.10.76.45]:34019 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753090Ab2IDXKX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 19:10:23 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        linux-kernel@vger.kernel.org
Cc: Amit Shah <amit.shah@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>, yrl.pp-manager.tt@hitachi.com,
        Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Subject: Re: [PATCH] tools: Fix pthread flag for Makefile of trace-agent used by virtio-trace
In-Reply-To: <20120904005339.30804.58826.stgit@ltc189.sdl.hitachi.co.jp>
References: <20120904005339.30804.58826.stgit@ltc189.sdl.hitachi.co.jp>
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Tue, 04 Sep 2012 15:34:34 +0930
Message-ID: <87392yfhn1.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com> writes:

> pthread flag should not be -lpthread but -pthread using gcc. The -lpthread
> links the external multithread library. On the other hand, the -pthread manages
> both the gcc's preprocessor and linker to be able to compile with pthread.
>
> Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>

Applied.

Thanks,
Rusty.
