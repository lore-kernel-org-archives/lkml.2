Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757385Ab2BCR5F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 12:57:05 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44715 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757113Ab2BCR5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 12:57:04 -0500
Date: Fri, 3 Feb 2012 18:56:58 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
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
Subject: Re: [PATCH] SubmittingPatches: Increase the line length limit from 80 to 100 colums
Message-ID: <20120203175658.GI11715@one.firstfloor.org>
References: <20120130140905.441199885@openvz.org> <20120130141852.309402052@openvz.org> <20120203074656.GC30543@elte.hu> <20120203083530.GD1968@moon> <20120203090929.GA23996@elte.hu> <20120203012241.bcd3d0c8.akpm@linux-foundation.org> <20120203095227.GA13162@elte.hu> <20120203100743.GA3334@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120203100743.GA3334@elte.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So lets increase the limit to 100 cols - this is a nice round 
> limit, and it also happens to match with most developer xterm 
> sizes. Code that goes over 100 cols for no good reasons will be 
> arguably something worth fixing. (100 cols is also arguably 
> closer to various brain limits such as vision of field and 
> resolution restrictions, so we'll likely not have to increase 
> this limit for a couple of million years, for all retro human 
> genome users.)

I suppose the future computer to brain interfaces will just
do away with the concept of lines @)

> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>

Acked-by: Andi Kleen <ak@linux.intel.com>

-Andi
