Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757798Ab1LNRyJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 12:54:09 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:59779 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755484Ab1LNRyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 12:54:05 -0500
Date: Wed, 14 Dec 2011 12:53:55 -0500 (EST)
Message-Id: <20111214.125355.2114905092680399303.davem@davemloft.net>
To: slyich@gmail.com
Cc: rob@landley.net, aboriginal@lists.landley.net,
        linux-kernel@vger.kernel.org, tytso@mit.edu,
        sparclinux@vger.kernel.org, jakub@redhat.com
Subject: Re: Sparc-32 doesn't work in 3.1.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20111214204225.7c8ec86c@sf.home>
References: <20111211111801.5942ab39@sf.home>
	<4EE80891.70604@landley.net>
	<20111214204225.7c8ec86c@sf.home>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 14 Dec 2011 09:53:57 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sergei Trofimovich <slyich@gmail.com>
Date: Wed, 14 Dec 2011 20:42:25 +0300

>> ext4_kvmalloc:
> ...
>>         sethi  %hi(___i_page_kernel), %i2      !, tmp112
>>        call    __vmalloc, 0    !
>>         restore %i2, %lo(___i_page_kernel), %o2        ! tmp112,,
> ...
> 
> David: is this code correct? Or it's a compiler bug? I am sparc32 newbie.
> (C source and asm sources of function are in [1])

It is correct, it's a tail call.
