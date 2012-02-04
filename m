Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565Ab2BDCqZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 21:46:25 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:49484 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751276Ab2BDCqX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 21:46:23 -0500
Message-ID: <1328323579.21255.34.camel@joe2Laptop>
Subject: Re: [PATCH] checkpatch: Warn on code with 6+ tab indentation
From: Joe Perches <joe@perches.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Whitcroft <apw@shadowen.org>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>, linux-kernel@vger.kernel.org,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andi Kleen <andi@firstfloor.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>, Valdis.Kletnieks@vt.edu
Date: Fri, 03 Feb 2012 18:46:20 -0800
In-Reply-To: <m1k443nwx8.fsf@fess.ebiederm.org>
References: <20120130140905.441199885@openvz.org>
	 <20120130141852.309402052@openvz.org> <20120203074656.GC30543@elte.hu>
	 <20120203083530.GD1968@moon> <20120203090929.GA23996@elte.hu>
	 <20120203012241.bcd3d0c8.akpm@linux-foundation.org>
	 <20120203095227.GA13162@elte.hu> <20120203100743.GA3334@elte.hu>
	 <CA+55aFxjPAsfsSSOsX9eyts6EP6dEyieGS_YJs-4HLuTKNfzZg@mail.gmail.com>
	 <1328311239.21255.24.camel@joe2Laptop> <m1k443nwx8.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-02-03 at 18:40 -0800, Eric W. Biederman wrote:
> Joe Perches <joe@perches.com> writes:
> > diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
[]
> > @@ -1924,6 +1924,12 @@ sub process {
[]
> > +
> > +			if ($line =~ /^\+\t{6,}/) {
> > +				WARN("DEEP_INDENTATION",
> > +				     "Too many leading tabs - consider code refactoring\n" . $herecurr);
> > +			}
> By any chance have you run this patch against itself?

Nope.  perl isn't a c.  Logic doesn't apply.
Some might claim perl logic an oxymoron.

checkpatch should be used for c sources only.

> I find it comical
> that there is a line 104 characters long suggesting people use shorter
> lines.

You're welcome to line wrap it if you like...
I don't actually use checkpatch much.

cheers, Joe

