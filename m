Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573Ab2BDBds (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 20:33:48 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:45309 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750844Ab2BDBdr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 20:33:47 -0500
Message-ID: <1328319226.21255.28.camel@joe2Laptop>
Subject: Re: [PATCH] checkpatch: Warn on code with 6+ tab indentation
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andy Whitcroft <apw@shadowen.org>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>, linux-kernel@vger.kernel.org,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andi Kleen <andi@firstfloor.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>, Valdis.Kletnieks@vt.edu
Date: Fri, 03 Feb 2012 17:33:46 -0800
In-Reply-To: <CA+55aFxHih0+P=aNromTy+f_Rt+++QWgaEdvqLsXg_q_hu_q2A@mail.gmail.com>
References: <20120130140905.441199885@openvz.org>
	 <20120130141852.309402052@openvz.org> <20120203074656.GC30543@elte.hu>
	 <20120203083530.GD1968@moon> <20120203090929.GA23996@elte.hu>
	 <20120203012241.bcd3d0c8.akpm@linux-foundation.org>
	 <20120203095227.GA13162@elte.hu> <20120203100743.GA3334@elte.hu>
	 <CA+55aFxjPAsfsSSOsX9eyts6EP6dEyieGS_YJs-4HLuTKNfzZg@mail.gmail.com>
	 <1328311239.21255.24.camel@joe2Laptop>
	 <CA+55aFxHih0+P=aNromTy+f_Rt+++QWgaEdvqLsXg_q_hu_q2A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-02-03 at 17:27 -0800, Linus Torvalds wrote:
> On Fri, Feb 3, 2012 at 3:20 PM, Joe Perches <joe@perches.com> wrote:
> > Overly indented code should be refactored.
> > Suggest refactoring excessive indentation of
> > of if/else/for/do/while/switch statements.
> I hate this patch.

You liked the same premise, but a worse
implementation, a couple years ago.
https://lkml.org/lkml/2009/12/18/289

> Why? Because mindless checks like this would just lead to people
> making things worse and intermixing spaces there instead.

Can't happen.
They'll get a different warning about mixing tabs
and spaces or starting a line with spaces only.

> Don't warn about things that will just result in people working around
> the warnings with worse code!

It merely suggests refactoring. ie: better code.

