Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183Ab2A0Sp0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 13:45:26 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:57576 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383Ab2A0SpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 13:45:25 -0500
Date: Fri, 27 Jan 2012 22:45:19 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@openvz.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Andrey Vagin <avagin@openvz.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Alexey Dobriyan <adobriyan@gmail.com>, Valdis.Kletnieks@vt.edu
Subject: Re: [RFC c/r 2/4] [RFC] syscalls, x86: Add __NR_kcmp syscall v7
Message-ID: <20120127184519.GJ11086@moon>
References: <20120127175342.273260614@openvz.org>
 <20120127175939.795551339@openvz.org>
 <m1zkd92dl5.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1zkd92dl5.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 27, 2012 at 10:40:54AM -0800, Eric W. Biederman wrote:
> Can you make the prototype:
> static int kcmp_ptr(void *v1, void *v2, enum kcmp_type type)
> 
> So the caller does not need to have casts?

Sure.

> I believe I commented on this earlier but it looks like it got lost in
> the noise.
> 
> file == NULL != file == NULL.
> 
> When you can't lookup the file kcmp should return -EBADF.
> 

Yes, Eric, I somehow missed it in replies flowing. I'll update.
Thanks!

	Cyrill
