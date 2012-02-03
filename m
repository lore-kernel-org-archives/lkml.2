Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755726Ab2BCV2U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 16:28:20 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:63066 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754796Ab2BCV2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 16:28:18 -0500
MIME-Version: 1.0
In-Reply-To: <20120203100743.GA3334@elte.hu>
References: <20120130140905.441199885@openvz.org> <20120130141852.309402052@openvz.org>
 <20120203074656.GC30543@elte.hu> <20120203083530.GD1968@moon>
 <20120203090929.GA23996@elte.hu> <20120203012241.bcd3d0c8.akpm@linux-foundation.org>
 <20120203095227.GA13162@elte.hu> <20120203100743.GA3334@elte.hu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 3 Feb 2012 13:27:58 -0800
X-Google-Sender-Auth: SM4Me048GqweD2japp9CIvwCgaU
Message-ID: <CA+55aFxjPAsfsSSOsX9eyts6EP6dEyieGS_YJs-4HLuTKNfzZg@mail.gmail.com>
Subject: Re: [PATCH] SubmittingPatches: Increase the line length limit from 80
 to 100 colums
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
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

On Fri, Feb 3, 2012 at 2:07 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> The overwhelming majority of kernel developers have stopped
> using 80 col terminals years ago.

Quite frankly, I think we should still keep it at 80 columns.

The problem is not the 80 columns, it's that damn patch-check script
that warns about people *occasionally* going over 80 columns.

But usually it's bettre to have the *occasional* 80+ column line, than
try to split it up. So we do have lines that are longer than 80
columns, but that's not because 100 columns is ok - it's because 80+
columns is better than the alternative.

So it's a trade-off. Thinking that there is a hard limit is the
problem. And extending that hard limit (and thinking that it's "ok" to
be over 80 columns) is *also* a problem.

So no, 100-char columns are not ok.

                   Linus
