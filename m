Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544Ab2AZSqt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 13:46:49 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:33552 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045Ab2AZSqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 13:46:47 -0500
Date: Thu, 26 Jan 2012 13:43:33 -0500 (EST)
Message-Id: <20120126.134333.31948964659222759.davem@davemloft.net>
To: geert@linux-m68k.org
Cc: rdunlap@xenotime.net, sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, gleb@redhat.com, netdev@vger.kernel.org,
        glommer@parallels.com
Subject: Re: linux-next: Tree for Jan 25 (net/sock.h, jump_label, memcg)
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAMuHMdWp1wEHqPXNs+kaMYpomJnfbZPJjRk5GVFCuCL4Q5zK7g@mail.gmail.com>
References: <20120125141938.c1a9460d56948e1c7b26d3f8@canb.auug.org.au>
	<4F2052DB.4060602@xenotime.net>
	<CAMuHMdWp1wEHqPXNs+kaMYpomJnfbZPJjRk5GVFCuCL4Q5zK7g@mail.gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 26 Jan 2012 10:43:35 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 26 Jan 2012 18:18:28 +0100

> On Wed, Jan 25, 2012 at 20:07, Randy Dunlap <rdunlap@xenotime.net> wrote:
>> back to net/sock.h and jump_label:
>>
>> (on i386:)
>>
>> /next/linux-next-20120125/include/net/sock.h:953:2: error: implicit declaration of function 'static_branch'
>> /next/linux-next-20120125/include/linux/jump_label.h:43:29: error: conflicting types for 'static_branch'
>>
>> Full randconfig file is attached.
> 
> Without having to add randomness, also in m68k/allmodconfig, now in Linus'
> tree :-(
> http://kisskb.ellerman.id.au/kisskb/buildresult/5491860/

Glauber are you actually going to fix this or are you going to ignore
this bug report for another couple days?!?!

Frankly, I'm so sick and tired of all of these socket mem cgroup
regressions, this is way out of control and every "fix" seems to add
more build or runtime regressions.

Glauber, this has to stabilize soon or I will revert every single one
of your changes, and it will take a nuclear war and a multi-month
audit of your code to get those changes into the tree again.

