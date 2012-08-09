Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757665Ab2HIMfi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 08:35:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2935 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504Ab2HIMfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 08:35:36 -0400
X-Authority-Analysis: v=2.0 cv=IOWA+3TG c=1 sm=0 a=s5Htg7xnQOKvHEu9STBOug==:17 a=OpT9cpI26MMA:10 a=tzqJOWxOEVwA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=WHaCPJD69tGyA_AYuqYA:9 a=PUjeQqilurYA:10 a=s5Htg7xnQOKvHEu9STBOug==:117
X-Cloudmark-Score: 0
X-Originating-IP: 72.230.195.127
Message-ID: <1344515732.6935.30.camel@gandalf.stny.rr.com>
Subject: Re: [RFC PATCH 2/6] virtio/console: Add a failback for unstealable
 pipe buffer
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Amit Shah <amit.shah@redhat.com>,
        Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        linux-kernel@vger.kernel.org, Anthony Liguori <anthony@codemonkey.ws>,
        Arnd Bergmann <arnd@arndb.de>, Borislav Petkov <bp@amd64.org>,
        "Franch Ch. Eigler" <fche@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Ingo Molnar <mingo@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        virtualization@lists.linux-foundation.org, qemu-devel@nongnu.org,
        yrl.pp-manager.tt@hitachi.com
Date: Thu, 09 Aug 2012 08:35:32 -0400
In-Reply-To: <502381EA.80805@hitachi.com>
References: <20120724023657.6600.52706.stgit@ltc189.sdl.hitachi.co.jp>
	 <20120724023718.6600.68836.stgit@ltc189.sdl.hitachi.co.jp>
	 <20120809090312.GH3280@amit.redhat.com> <502381EA.80805@hitachi.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-08-09 at 18:24 +0900, Masami Hiramatsu wrote:

> Yeah, it is really easy to fix that.
> But out of curiosity, would that be really a problem?
> I guess that host can access any guest page if need. If that
> is right, is that really insecure to leak randomly allocated
> unused page to the host?

Yeah, it's like protecting userspace pages from the kernel ;-)

-- Steve


