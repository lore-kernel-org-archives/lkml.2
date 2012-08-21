Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685Ab2HUFQy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 01:16:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23927 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752191Ab2HUFQv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 01:16:51 -0400
Date: Tue, 21 Aug 2012 10:46:19 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Anthony Liguori <anthony@codemonkey.ws>,
        Arnd Bergmann <arnd@arndb.de>, Borislav Petkov <bp@amd64.org>,
        "Franch Ch. Eigler" <fche@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Ingo Molnar <mingo@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Steven Rostedt <rostedt@goodmis.org>,
        virtualization@lists.linux-foundation.org, qemu-devel@nongnu.org,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH V2 0/6] virtio-trace: Support virtio-trace
Message-ID: <20120821051619.GF29197@amit.redhat.com>
References: <20120809123029.8542.38311.stgit@ltc189.sdl.hitachi.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120809123029.8542.38311.stgit@ltc189.sdl.hitachi.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Thu) 09 Aug 2012 [21:30:29], Yoshihiro YUNOMAE wrote:
> Hi All,
> 
> The following patch set provides a low-overhead system for collecting kernel
> tracing data of guests by a host in a virtualization environment.

ACK this series.

I ran it through the virtio-serial test suite, and there's no
regression in existing functionality.

I encourage you to check out the virtio-serial test suite[1] as well
as the virtio-serial unit tests in the autotest[2] code, and
contribute to them to add tests for the new functionality you've
added.

[1]
http://fedorapeople.org/cgit/amitshah/public_git/test-virtserial.git/

[2]
https://github.com/autotest/autotest/blob/e91cd67b845b291622c8d079a8289c4b0cb1e6ae/client/tests/kvm/tests/virtio_console.py


Thanks,

		Amit
