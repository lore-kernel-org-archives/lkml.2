Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932611Ab2HVNli (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 09:41:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28618 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932429Ab2HVNlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 09:41:35 -0400
X-Authority-Analysis: v=2.0 cv=IOWA+3TG c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=YOaqkLwX9aQA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=7mug7doFhEcA:10 a=meVymXHHAAAA:8 a=3nbZYyFuAAAA:8 a=W6GRgLaN4YcdezI8Cx0A:9 a=PUjeQqilurYA:10 a=EvKJbDF4Ut8A:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1345642893.5069.31.camel@gandalf.local.home>
Subject: Re: [PATCH 2/5] trace-cmd: Use tracing directory to count CPUs
From: Steven Rostedt <rostedt@goodmis.org>
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Amit Shah <amit.shah@redhat.com>, Anthony Liguori <anthony@codemonkey.ws>,
        Arnd Bergmann <arnd@arndb.de>, Borislav Petkov <bp@amd64.org>,
        "Franch Ch. Eigler" <fche@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Ingo Molnar <mingo@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, qemu-devel@nongnu.org,
        yrl.pp-manager.tt@hitachi.com
Date: Wed, 22 Aug 2012 09:41:33 -0400
In-Reply-To: <20120822084312.17293.47596.stgit@ltc189.sdl.hitachi.co.jp>
References: <20120822084251.17293.69086.stgit@ltc189.sdl.hitachi.co.jp>
	 <20120822084312.17293.47596.stgit@ltc189.sdl.hitachi.co.jp>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-08-22 at 17:43 +0900, Yoshihiro YUNOMAE wrote:
> From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> 
> Count debugfs/tracing/per_cpu/cpu* to determine the
> number of CPUs.

I'm curious, do you find that sysconf doesn't return the # of CPUs the
system has? I've had boxes where the per_cpu/cpu* had more cpus than the
box actually holds. But this was a bug in the kernel, not the tool. This
change log needs to have rational instead of just explaining what the
patch does.

Thanks,

-- Steve

> 
> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
> ---


