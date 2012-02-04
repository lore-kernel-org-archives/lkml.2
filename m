Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137Ab2BDSyq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 13:54:46 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:55543 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753209Ab2BDSyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 13:54:45 -0500
MIME-Version: 1.0
In-Reply-To: <1328381300.5996.2.camel@joe2Laptop>
References: <20120203074656.GC30543@elte.hu>
	<20120203083530.GD1968@moon>
	<20120203090929.GA23996@elte.hu>
	<20120203012241.bcd3d0c8.akpm@linux-foundation.org>
	<20120203095227.GA13162@elte.hu>
	<20120203100743.GA3334@elte.hu>
	<CA+55aFxjPAsfsSSOsX9eyts6EP6dEyieGS_YJs-4HLuTKNfzZg@mail.gmail.com>
	<1328311239.21255.24.camel@joe2Laptop>
	<20120204130330.GA30198@elte.hu>
	<1328372536.5766.3.camel@joe2Laptop>
	<20120204180237.GA7682@elte.hu>
	<1328381300.5996.2.camel@joe2Laptop>
Date: Sat, 4 Feb 2012 20:54:42 +0200
X-Google-Sender-Auth: L0KePSeaMrj0uI2CY8lLy5odeOE
Message-ID: <CAOJsxLGtkVDZpFn3WY21Z4nqnH159KLyo7sx5rhe73bz712sYw@mail.gmail.com>
Subject: Re: [PATCH, v2] checkpatch: Warn on code with 6+ tab indentation,
 remove 80col warning
From: Pekka Enberg <penberg@kernel.org>
To: Joe Perches <joe@perches.com>
Cc: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
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
        Matt Helsley <matthltc@us.ibm.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>, Valdis.Kletnieks@vt.edu
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 4, 2012 at 8:48 PM, Joe Perches <joe@perches.com> wrote:
> There are some truly _ugly_ > 80 char lines that
> people attempt where checkpatch should issue some
> "don't do that" message.

The practical downsides of the current warning are much more severe. I
personally don't use checkpatch much these days because of the silly
fixed limit.
