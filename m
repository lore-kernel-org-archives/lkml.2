Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414Ab2HUFJp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 01:09:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21124 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751487Ab2HUFJm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 01:09:42 -0400
Date: Tue, 21 Aug 2012 10:39:05 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        linux-kernel@vger.kernel.org, Anthony Liguori <anthony@codemonkey.ws>,
        Arnd Bergmann <arnd@arndb.de>, Borislav Petkov <bp@amd64.org>,
        "Franch Ch. Eigler" <fche@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Ingo Molnar <mingo@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        virtualization@lists.linux-foundation.org, qemu-devel@nongnu.org,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [RFC PATCH 0/6] virtio-trace: Support virtio-trace
Message-ID: <20120821050905.GE29197@amit.redhat.com>
References: <20120724023657.6600.52706.stgit@ltc189.sdl.hitachi.co.jp>
 <20120809101620.GN3280@amit.redhat.com>
 <87393h3s5v.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87393h3s5v.fsf@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Tue) 21 Aug 2012 [11:47:16], Rusty Russell wrote:
> On Thu, 9 Aug 2012 15:46:20 +0530, Amit Shah <amit.shah@redhat.com> wrote:
> > Hi,
> > 
> > On (Tue) 24 Jul 2012 [11:36:57], Yoshihiro YUNOMAE wrote:
> > > Hi All,
> > > 
> > > The following patch set provides a low-overhead system for collecting kernel
> > > tracing data of guests by a host in a virtualization environment.
> > 
> > So I just have one minor comment, please post a non-RFC version of the
> > patch.
> > 
> > Since you have an ACK from Steven for the ftrace patch, I guess Rusty
> > can push this in via his virtio tree?
> > 
> > I'll ack the virtio-console bits in the next series you send.
> 
> You didn't Ack, BTW.  At least, AFAICT.

Ah, sorry.  Will do that now.

		Amit
