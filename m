Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362Ab1CVI0H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 04:26:07 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:29348 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753875Ab1CVI0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 04:26:05 -0400
Date: Tue, 22 Mar 2011 09:25:56 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Pekka Enberg <penberg@kernel.org>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Daniel Lezcano <daniel.lezcano@free.fr>,
        Eric Paris <eparis@redhat.com>, Roman Zippel <zippel@linux-m68k.org>,
        linux-kbuild@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: PATCH][RFC][resend] CC_OPTIMIZE_FOR_SIZE should default to N
In-Reply-To: <AANLkTinmAJsXy=iJ5Fq-+CLTAGXTtLGhULRUf=Q1rkY1@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1103220925010.30171@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1103212105490.15815@swampdragon.chaosbits.net> <AANLkTinmAJsXy=iJ5Fq-+CLTAGXTtLGhULRUf=Q1rkY1@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Mar 2011, Pekka Enberg wrote:

> Hi Jesper,
> 
> On Mon, Mar 21, 2011 at 10:08 PM, Jesper Juhl <jj@chaosbits.net> wrote:
> > I believe that the majority of systems we are built on want a -O2 compiled
> > kernel. Optimizing for size (-Os) is mainly benneficial for embedded
> > systems and systems with very small CPU caches (correct me if I'm wrong).
> 
> Please take a look at commit 0910b44 ("Expose "Optimize for size"
> option for everybody") for the reasoning behind defaulting to -Os.
> 
Thank you for that pointer Pekka. I guess I need to update my view on -Os.

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

