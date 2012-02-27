Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150Ab2B0XiE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 18:38:04 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18555 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754155Ab2B0XiC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 18:38:02 -0500
X-Authority-Analysis: v=2.0 cv=M9vP2lMs c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=f-yYDmgdQXkA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=VwQbUJbxAAAA:8 a=rm9a0bTRZYS0tXU1swkA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1330385881.25686.202.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH][GIT PULL][v3.3] ktest: Fix make_min_config test when
 build fails
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Mon, 27 Feb 2012 18:38:01 -0500
In-Reply-To: <CA+55aFw5hhQQU-X_n=Q98Xt_UVKUgeVJ53BhwDgFvXSSt_0Bjw@mail.gmail.com>
References: <1330370242.25686.196.camel@gandalf.stny.rr.com>
	 <CA+55aFw5hhQQU-X_n=Q98Xt_UVKUgeVJ53BhwDgFvXSSt_0Bjw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-02-27 at 15:26 -0800, Linus Torvalds wrote:
> On Mon, Feb 27, 2012 at 11:17 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > Please pull the latest for-linus tree, which can be found at:
> >
> >  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-ktest.git
> > ktest-fix-make-min-failed-build
> 
> I'm getting "Already up-to-date" with that tag. It points to your old
> commit be405f95f0a0 ("ktest: Add INGORE_ERRORS to ignore warnings in
> boot up") and normally I'd ask whether you perhaps forgot to push, but
> considering the fairly unique naming of that tag, you clearly *did*
> push.

New tag, with the real commit in it.


ktest-fix-make-min-failed-build-for-real

Thanks,

-- Steve


