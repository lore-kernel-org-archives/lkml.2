Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896Ab2AXHWM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 02:22:12 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53774 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754446Ab2AXHWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 02:22:10 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 24 Jan 2012 16:20:31 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Matt Helsley <matthltc@us.ibm.com>,
        Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>, Valdis.Kletnieks@vt.edu
Subject: Re: [patch 2/4] [RFC] syscalls, x86: Add __NR_kcmp syscall v4
Message-Id: <20120124162031.a3956058.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20120124071716.GC29735@moon>
References: <20120123142036.025893883@openvz.org>
	<20120123142436.258631438@openvz.org>
	<20120124111655.b29264d2.kamezawa.hiroyu@jp.fujitsu.com>
	<20120124064719.GA29735@moon>
	<4F1E57F3.6020607@zytor.com>
	<20120124071716.GC29735@moon>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jan 2012 11:17:16 +0400
Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> On Mon, Jan 23, 2012 at 11:04:19PM -0800, H. Peter Anvin wrote:
> > On 01/23/2012 10:47 PM, Cyrill Gorcunov wrote:
> > >>
> > >> Why under /arch ?
> > >>
> > > 
> > > Hi Kame,
> > > 
> > > because I've tested it under x86 only. Once someone
> > > confirm it's needed on some else arch and does work
> > > as expected -- it wont be a problem to make it system
> > > wide. Until then -- I think better to stick with
> > > at least tested case.
> > > ...
> > 
> > That's not a reason to put it in arch/ ... that's possibly a reason to
> > not map the system call on other architectures yet.
> > 
> 
> Where it should live then? In kernel/ or mm/ ?
> 

kernel/checkpoint_restart ?

gathering related changes to a directory may help developpers joins later....
To me, this makes seeing git log easy ;)
 
Thanks,
-Kame

