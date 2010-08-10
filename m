Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757797Ab0HJUPL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 16:15:11 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:50274 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013Ab0HJUPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 16:15:09 -0400
Message-Id: <201008102014.o7AKEwte077880@www262.sakura.ne.jp>
Subject: Re: tomoyo-init (tomoyo-tools) results in kernel panic on kernel 2.6.35-git2/3
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: jkosina@suse.cz
Cc: kawime@gmx.de, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Wed, 11 Aug 2010 05:14:58 +0900
References: <op.vg0yh9gtgp7xae@127.0.0.1> <201008070504.o7754Daw083381@www262.sakura.ne.jp> <alpine.LRH.2.00.1008101443340.2372@twin.jikos.cz>
In-Reply-To: <alpine.LRH.2.00.1008101443340.2372@twin.jikos.cz>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 10082010 #3872342, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:
> Still, if a legacy userspace application is able to cause kernel panic,
> that sounds like something we'd rather fix immediately.

I assume the panic message which Karsten encountered is either

  Profile version %u is not supported.

or

  Profile %u (used by '%s') not defined.

which happens only if access control rules (a.k.a. policy) was not
loaded when /sbin/init starts.

If what Karsten encountered is not the cases above,
I agree that we need to fix immediately.

Regards.
