Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757510Ab2HUMdH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 08:33:07 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:44025 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757225Ab2HUMdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 08:33:02 -0400
X-AuditID: b753bd60-8ecbeba0000047ca-fc-50337ffbf3a4
X-AuditID: b753bd60-8ecbeba0000047ca-fc-50337ffbf3a4
Message-ID: <50338008.6000708@hitachi.com>
Date: Tue, 21 Aug 2012 21:33:12 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Amit Shah <amit.shah@redhat.com>
Cc: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        linux-kernel@vger.kernel.org, Anthony Liguori <anthony@codemonkey.ws>,
        Arnd Bergmann <arnd@arndb.de>, Borislav Petkov <bp@amd64.org>,
        "Franch Ch. Eigler" <fche@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Ingo Molnar <mingo@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Steven Rostedt <rostedt@goodmis.org>,
        virtualization@lists.linux-foundation.org, qemu-devel@nongnu.org,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: Re: [PATCH V2 0/6] virtio-trace: Support virtio-trace
References: <20120809123029.8542.38311.stgit@ltc189.sdl.hitachi.co.jp> <20120821051619.GF29197@amit.redhat.com>
In-Reply-To: <20120821051619.GF29197@amit.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/08/21 14:16), Amit Shah wrote:
> On (Thu) 09 Aug 2012 [21:30:29], Yoshihiro YUNOMAE wrote:
>> Hi All,
>>
>> The following patch set provides a low-overhead system for collecting kernel
>> tracing data of guests by a host in a virtualization environment.
> 
> ACK this series.

Thank you!

> I ran it through the virtio-serial test suite, and there's no
> regression in existing functionality.
> 
> I encourage you to check out the virtio-serial test suite[1] as well
> as the virtio-serial unit tests in the autotest[2] code, and
> contribute to them to add tests for the new functionality you've
> added.

Ah, OK we'll look into them for adding some tests for
splice support :)

> 
> [1]
> http://fedorapeople.org/cgit/amitshah/public_git/test-virtserial.git/
> 
> [2]
> https://github.com/autotest/autotest/blob/e91cd67b845b291622c8d079a8289c4b0cb1e6ae/client/tests/kvm/tests/virtio_console.py
> 
> 

Thank you again,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


