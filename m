Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758344Ab2FOW2d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 18:28:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20230 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758254Ab2FOW2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 18:28:32 -0400
X-Authority-Analysis: v=2.0 cv=eIiRfQV1 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=MgfmKKM-MiAA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=ruXDgcNOlVdrFi6PYCkA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1339799310.25903.23.camel@gandalf.stny.rr.com>
Subject: RE: [PATCH 3/6] pstore: Add persistent function tracing
From: Steven Rostedt <rostedt@goodmis.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Anton Vorontsov <anton.vorontsov@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        John Stultz <john.stultz@linaro.org>, Shuah Khan <shuahkhan@gmail.com>,
        "arve@android.com" <arve@android.com>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Jesper Juhl <jj@chaosbits.net>, Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Boyd <sboyd@codeaurora.org>, Thomas Meyer <thomas@m3y3r.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        WANG Cong <xiyou.wangcong@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "kernel-team@android.com" <kernel-team@android.com>
Date: Fri, 15 Jun 2012 18:28:30 -0400
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F19320CC9@ORSMSX104.amr.corp.intel.com>
References: <20120615170659.GA4060@lizard>
	 <1339780111-12075-3-git-send-email-anton.vorontsov@linaro.org>
	 <3908561D78D1C84285E8C5FCA982C28F1931FC30@ORSMSX104.amr.corp.intel.com>
	 <1339797308.25903.8.camel@gandalf.stny.rr.com>
	 <3908561D78D1C84285E8C5FCA982C28F1931FC85@ORSMSX104.amr.corp.intel.com>
	 <1339798214.25903.17.camel@gandalf.stny.rr.com>
	 <3908561D78D1C84285E8C5FCA982C28F19320CC9@ORSMSX104.amr.corp.intel.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-15 at 22:19 +0000, Luck, Tony wrote:

> Binary makes sense too - but I'll stick with my comment that a different
> kernel must be able to do the decode. Or we need to spell out clearly
> that you must have the same, or compatible kernel booted to make any
> sense of the saved ftrace record.

I 100% agree here. I haven't looked at how the data gets stored, but it
should definitely be consistent across kernels.

Maybe store metadata in the persistent storage that explains how to
parse the binary data? Similar to /debug/tracing/events/ftrace/function/format
is done.


-- Steve


