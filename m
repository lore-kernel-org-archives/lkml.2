Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933177Ab1FACTZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 22:19:25 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63866 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933082Ab1FACTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 22:19:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=l7mUztZhr2h4xh7UEoBJYVl9CUlA3A3+nMo7btPfiBb8DvPVEeLRVfHYNef1y4CtQI
         Q8xCnvswAXOwcBBQ7zkLWLKR3Q37fXw6TDxzoiGHJ6NHjqBvh/i8eC7OmLd7opG4+1h/
         8rO9TcVsTWIGJNeAZ3IkUkVx49fYiqj3SouNI=
MIME-Version: 1.0
In-Reply-To: <20110601101117.6c9792a1.sfr@canb.auug.org.au>
References: <20110527151135.cd6f758a.sfr@canb.auug.org.au> <1306591465-9622-1-git-send-email-vapier@gentoo.org>
 <4DE3688A.4040600@mvista.com> <BANLkTind_F4-5sLUO1GVxK_yY_eXz_J0Vg@mail.gmail.com>
 <20110601101117.6c9792a1.sfr@canb.auug.org.au>
From: Mike Frysinger <vapier@gentoo.org>
Date: Tue, 31 May 2011 22:19:02 -0400
X-Google-Sender-Auth: cNxvbM6Ja1tgKvDw54Ry7DfjiS0
Message-ID: <BANLkTimSJm8Un8dPzCw8Y-J8R5w-Dqm44Q@mail.gmail.com>
Subject: Re: [Kgdb-bugreport] [PATCH] kgdbts: only use new asm-generic/ptrace.h
 api when needed
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus <torvalds@linux-foundation.org>,
        Sergei Shtylyov <sshtylyov@mvista.com>,
        kgdb-bugreport@lists.sourceforge.net,
        Jason Wessel <jason.wessel@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 31, 2011 at 20:11, Stephen Rothwell wrote:
> It would have been nice if the original patch had been in linux-next at
> some point (especially given that I have a "kgdb" tree in linux-next).

complain to akpm.  the patches sat in his tree for some time with no complaints.
-mike
