Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758Ab2AXHl7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 02:41:59 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:55392 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754065Ab2AXHl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 02:41:58 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 24 Jan 2012 16:40:08 +0900
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
Message-Id: <20120124164008.aa1714bd.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20120124073842.GE29735@moon>
References: <20120123142036.025893883@openvz.org>
	<20120123142436.258631438@openvz.org>
	<20120124111655.b29264d2.kamezawa.hiroyu@jp.fujitsu.com>
	<20120124064719.GA29735@moon>
	<4F1E57F3.6020607@zytor.com>
	<20120124071716.GC29735@moon>
	<20120124162031.a3956058.kamezawa.hiroyu@jp.fujitsu.com>
	<20120124073842.GE29735@moon>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jan 2012 11:38:42 +0400
Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> On Tue, Jan 24, 2012 at 04:20:31PM +0900, KAMEZAWA Hiroyuki wrote:
> ...
> > > > 
> > > > That's not a reason to put it in arch/ ... that's possibly a reason to
> > > > not map the system call on other architectures yet.
> > > > 
> > > 
> > > Where it should live then? In kernel/ or mm/ ?
> > > 
> > 
> > kernel/checkpoint_restart ?
> > 
> > gathering related changes to a directory may help developpers joins later....
> > To me, this makes seeing git log easy ;)
> >  
> 
> Such separate directory implies everything related to c/r should live there,
> it also implies (I think) that code which is under CHECKPOINT_RESTORE should
> be moved there as well, so I'm not sure, Kame ;) I guess mm/ will be a good
> place since these are operations with memory pointers.
> 

please do as you like. 
-Kame

