Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672Ab2JAQxi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 12:53:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27211 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753584Ab2JAQxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 12:53:36 -0400
X-Authority-Analysis: v=2.0 cv=WKj9rwQR c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=cSvWQCJQSpIA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=jn3ofMSl3B8A:10 a=oetpzP3o9FDJfgyfjuEA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1349110415.22822.122.camel@gandalf.local.home>
Subject: Re: Re: [PATCH -tip  0/3] Move kprobes files under the kprobes
 directory
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com
Date: Mon, 01 Oct 2012 12:53:35 -0400
In-Reply-To: <5068FF21.1080601@hitachi.com>
References: <20120928081509.3560.8860.stgit@ltc138.sdl.hitachi.co.jp>
	 <1348835692.22822.97.camel@gandalf.local.home>
	 <5068FF21.1080601@hitachi.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-10-01 at 11:25 +0900, Masami Hiramatsu wrote:

> Thank you for asking, this is just a kind of cleanup, so I think stable
> enough for 3.7. At least, it is better to push this into tip tree
> for future works. :)

Unfortunately since the merge window opened last night, I'll hold these
changes off till v3.8. I don't push to Ingo till after the merge window
closes so I'll just keep these in my v3.8 queue for now. I'll run them
through tests in the mean time.

Thanks,

-- Steve


