Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756709Ab1KRVpc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 16:45:32 -0500
Received: from toast.topped-with-meat.com ([204.197.218.159]:35268 "EHLO
	topped-with-meat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756183Ab1KRVpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 16:45:30 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@hack.frob.com>
To: Kees Cook <keescook@chromium.org>
X-Fcc: ~/Mail/lkml
Cc: oleg@redhat.com, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        James Morris <jmorris@namei.org>
Subject: Re: [PATCH v6 0/3] security: Yama LSM
In-Reply-To: Kees Cook's message of  Friday, 18 November 2011 13:39:38 -0800 <CAGXu5jJ4h+uCF50DqbLe1m6CRr_Mw3pWq4mEm8nRtDPKV9C2Rg@mail.gmail.com>
References: <1319672956-17114-1-git-send-email-keescook@chromium.org>
	<alpine.LRH.2.00.1111181514220.30965@tundra.namei.org>
	<CAGXu5jJ4h+uCF50DqbLe1m6CRr_Mw3pWq4mEm8nRtDPKV9C2Rg@mail.gmail.com>
X-Windows: don't get frustrated without it.
Message-Id: <20111118214527.CE6AC2C0E7@topped-with-meat.com>
Date: Fri, 18 Nov 2011 13:45:27 -0800 (PST)
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.0 cv=fe7WOzsF c=1 sm=1 a=74MF-9sPDx4A:10
		a=kj9zAlcOel0A:10 a=yS0oSsgtZTRCe0vpyAEA:9 a=az6JLkA_BeJq6HI5FZsA:7
		a=CjuIK1q_8ugA:10 a=WkljmVdYkabdwxfqvArNOQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Do you have any objection to my LSM performing ptrace restrictions?
> It's entirely self-contained, and all the major upstream crash
> handlers are already using the prctl() interface it uses to declare
> ptrace attach relationships.

I don't have the context of what your LSM does.  But other LSMs apply their
own rules in security_ptrace().  That's what the hook is for.  I'm not sure
why we would object from the perspective of core ptrace functionality.
LSMs are LSMs.  Their behavior is between you and your users, as far as I
am concerned.  As experts on ptrace and aficionados of its users, we may
have thoughts on what constraints on ptrace users would find annoying.
But that doesn't mean we'd object per se to whatever bizarre constraints
users want to ask an LSM to put on them.


Thanks,
Roland
