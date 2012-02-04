Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044Ab2BDB2A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 20:28:00 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:34288 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002Ab2BDB17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 20:27:59 -0500
MIME-Version: 1.0
In-Reply-To: <1328311239.21255.24.camel@joe2Laptop>
References: <20120130140905.441199885@openvz.org> <20120130141852.309402052@openvz.org>
 <20120203074656.GC30543@elte.hu> <20120203083530.GD1968@moon>
 <20120203090929.GA23996@elte.hu> <20120203012241.bcd3d0c8.akpm@linux-foundation.org>
 <20120203095227.GA13162@elte.hu> <20120203100743.GA3334@elte.hu>
 <CA+55aFxjPAsfsSSOsX9eyts6EP6dEyieGS_YJs-4HLuTKNfzZg@mail.gmail.com> <1328311239.21255.24.camel@joe2Laptop>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 3 Feb 2012 17:27:36 -0800
X-Google-Sender-Auth: 9NV8lSzM6upNSngntI28qYH9YDI
Message-ID: <CA+55aFxHih0+P=aNromTy+f_Rt+++QWgaEdvqLsXg_q_hu_q2A@mail.gmail.com>
Subject: Re: [PATCH] checkpatch: Warn on code with 6+ tab indentation
To: Joe Perches <joe@perches.com>
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 3, 2012 at 3:20 PM, Joe Perches <joe@perches.com> wrote:
> Overly indented code should be refactored.
>
> Suggest refactoring excessive indentation of
> of if/else/for/do/while/switch statements.

I hate this patch.

Why? Because mindless checks like this would just lead to people
making things worse and intermixing spaces there instead.

That's the same reason the 80-character check has been a total
disaster. People shut it up by splitting long strings etc, and we've
had to change that 80-character test many times just to avoid the
crazy workarounds.

Don't warn about things that will just result in people working around
the warnings with worse code!

                 Linus
