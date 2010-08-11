Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257Ab0HKWv0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 18:51:26 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45348
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753630Ab0HKWvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 18:51:24 -0400
Date: Wed, 11 Aug 2010 15:51:41 -0700 (PDT)
Message-Id: <20100811.155141.71103284.davem@davemloft.net>
To: dhowells@redhat.com
Cc: torvalds@osdl.org, akpm@linux-foundation.org, viro@ZenIV.linux.org.uk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Mark arguments to certain syscalls as being const
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100811102622.30362.70210.stgit@warthog.procyon.org.uk>
References: <20100811102622.30362.70210.stgit@warthog.procyon.org.uk>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>
Date: Wed, 11 Aug 2010 11:26:22 +0100

> Mark arguments to certain system calls as being const where they should be but
> aren't.  The list includes:
> 
>  (*) The filename arguments of various stat syscalls, execve(), various utimes
>      syscalls and some mount syscalls.
> 
>  (*) The filename arguments of some syscall helpers relating to the above.
> 
>  (*) The buffer argument of various write syscalls.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>

Acked-by: David S. Miller <davem@davemloft.net>
