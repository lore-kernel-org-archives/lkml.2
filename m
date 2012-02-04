Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272Ab2BDSsX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 13:48:23 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:50338 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753381Ab2BDSsW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 13:48:22 -0500
Message-ID: <1328381300.5996.2.camel@joe2Laptop>
Subject: Re: [PATCH, v2] checkpatch: Warn on code with 6+ tab indentation,
 remove 80col warning
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Whitcroft <apw@shadowen.org>,
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
Date: Sat, 04 Feb 2012 10:48:20 -0800
In-Reply-To: <20120204180237.GA7682@elte.hu>
References: <20120203074656.GC30543@elte.hu> <20120203083530.GD1968@moon>
	 <20120203090929.GA23996@elte.hu>
	 <20120203012241.bcd3d0c8.akpm@linux-foundation.org>
	 <20120203095227.GA13162@elte.hu> <20120203100743.GA3334@elte.hu>
	 <CA+55aFxjPAsfsSSOsX9eyts6EP6dEyieGS_YJs-4HLuTKNfzZg@mail.gmail.com>
	 <1328311239.21255.24.camel@joe2Laptop> <20120204130330.GA30198@elte.hu>
	 <1328372536.5766.3.camel@joe2Laptop> <20120204180237.GA7682@elte.hu>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-02-04 at 19:02 +0100, Ingo Molnar wrote:
> * Joe Perches <joe@perches.com> wrote:
> 
> > On Sat, 2012-02-04 at 14:03 +0100, Ingo Molnar wrote:
> > > * Joe Perches <joe@perches.com> wrote:
> > > > Overly indented code should be refactored.
> > > _AND_ the 80 cols warning should be removed. The overwhelming 
> > > majority of developers either ignore the 80 cols warning or make 
> > > the code worse as a result of the warning.
> > 
> > Perhaps, but it should be a separate patch
> > and you'd still need to update CodingStyle.
> 
> Why would I have to update CodingStyle? The 80col limit remains, 
> it's just removed from *checkpatch*.

If that's your intent, I disagree with your patch.

There are some truly _ugly_ > 80 char lines that
people attempt where checkpatch should issue some
"don't do that" message.

