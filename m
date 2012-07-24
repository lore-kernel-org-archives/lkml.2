Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480Ab2GXNlp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 09:41:45 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61832 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754124Ab2GXNlo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 09:41:44 -0400
MIME-Version: 1.0
In-Reply-To: <500E84D7.7060103@hitachi.com>
References: <20120724023657.6600.52706.stgit@ltc189.sdl.hitachi.co.jp>
	<CAJSP0QW_2JJ0nf=NW0y30VSid2HSxaqb=mRGV8CTtAKj0ujDWw@mail.gmail.com>
	<500E810A.4030309@hitachi.com>
	<500E84D7.7060103@hitachi.com>
Date: Tue, 24 Jul 2012 14:41:42 +0100
Message-ID: <CAJSP0QVuQnE68n=jyW+AE=WF3yDHjgdn7tdiz7rPTbtqGYFL4w@mail.gmail.com>
Subject: Re: Re: [RFC PATCH 0/6] virtio-trace: Support virtio-trace
From: Stefan Hajnoczi <stefanha@gmail.com>
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com, qemu-devel@nongnu.org,
        Borislav Petkov <bp@amd64.org>,
        virtualization@lists.linux-foundation.org,
        "Franch Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Anthony Liguori <anthony@codemonkey.ws>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Amit Shah <amit.shah@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2012 at 12:19 PM, Yoshihiro YUNOMAE
<yoshihiro.yunomae.ez@hitachi.com> wrote:
>>> Are you using text formatted ftrace?
> No, currently using raw format, but　we'd like to reformat it in text.

Capturing the info necessary to translate numbers into symbols is one
of the problems of host<->guest tracing so I'm curious how you handle
this :).

Apologies for my lack of ftrace knowledge but how useful is the raw
tracing data on the host?  How do you pretty-print it in
human-readable form?

Stefan
