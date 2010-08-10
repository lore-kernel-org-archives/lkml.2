Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757943Ab0HJUfv (ORCPT <rfc822;list-kernel77@spinics.net>);
	Tue, 10 Aug 2010 16:35:51 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:56470 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1757843Ab0HJUft (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 16:35:49 -0400
X-Authenticated: #8143315
X-Provags-ID: V01U2FsdGVkX1/u5xgA6U/uU/9kQYfvy92Ko++uxk27gEcWwrEqQ5
	rhsO4nxg+bGR9B
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: jkosina@suse.cz, "Tetsuo Handa" <penguin-kernel@i-love.sakura.ne.jp>
Cc: linux-kernel@vger.kernel.org
Subject: Re: tomoyo-init (tomoyo-tools) results in kernel panic on kernel
 2.6.35-git2/3
References: <op.vg0yh9gtgp7xae@127.0.0.1>
 <201008070504.o7754Daw083381@www262.sakura.ne.jp>
 <alpine.LRH.2.00.1008101443340.2372@twin.jikos.cz>
 <201008102014.o7AKEwte077880@www262.sakura.ne.jp>
Date: Tue, 10 Aug 2010 22:35:44 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
FROM: Karsten Mehrhoff <kawime@gmx.de>
Message-ID: <op.vg8otu2fgp7xae@127.0.0.1>
In-Reply-To: <201008102014.o7AKEwte077880@www262.sakura.ne.jp>
User-Agent: Opera Mail/10.61 (Linux)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Am 10.08.2010, 22:14 Uhr, schrieb Tetsuo Handa  
<penguin-kernel@i-love.sakura.ne.jp>]

> Jiri Kosina wrote:
>> Still, if a legacy userspace application is able to cause kernel panic,
>> that sounds like something we'd rather fix immediately.
>
> I assume the panic message which Karsten encountered is either
>
>   Profile version %u is not supported.
>
> or
>
>   Profile %u (used by '%s') not defined.
>
> which happens only if access control rules (a.k.a. policy) was not
> loaded when /sbin/init starts.
>
> If what Karsten encountered is not the cases above,
> I agree that we need to fix immediately.
>
> Regards.

The panic message was:
>   Profile %u (used by '%s') not defined.

Profile 0 (used by '0') not defined.


Regards

Karsten
