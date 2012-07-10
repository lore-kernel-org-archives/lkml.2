Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755691Ab2GJNAl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 09:00:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13413 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076Ab2GJNAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 09:00:40 -0400
X-Authority-Analysis: v=2.0 cv=StQSGYy0 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=MxUuJf40BnAA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=8Vm3c3B3_RMbEsspPo0A:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1341925236.14828.12.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH v4 0/8] Function tracing support for pstore
From: Steven Rostedt <rostedt@goodmis.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Anton Vorontsov <anton.vorontsov@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, John Stultz <john.stultz@linaro.org>,
        Shuah Khan <shuahkhan@gmail.com>, arve@android.com,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Jesper Juhl <jj@chaosbits.net>, Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Boyd <sboyd@codeaurora.org>, Thomas Meyer <thomas@m3y3r.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Date: Tue, 10 Jul 2012 09:00:36 -0400
In-Reply-To: <201207101201.08699.arnd@arndb.de>
References: <20120710001004.GA22744@lizard>
	 <201207101201.08699.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-07-10 at 12:01 +0000, Arnd Bergmann wrote:
> On Tuesday 10 July 2012, Anton Vorontsov wrote:
> > With this support kernel can save functions call chain log into a
> > persistent ram buffer that can be decoded and dumped after reboot
> > through pstore filesystem. It can be used to determine what function
> > was last called before a hang or an unexpected reset (caused by, for
> > example, a buggy driver that abuses HW).
> 
> I just looked at the patches, and they are all well implemented. I could
> find nothing wrong with the implementation. As to the question of whether
> we want this functionality I have to leave that to the tracing people.

I'm fine with it. You can add my:

  Acked-by: Steven Rostedt <rostedt@goodmis.org>

to the tracing specific patches (I haven't taken a deep look at the
pstore specific patches).

-- Steve


