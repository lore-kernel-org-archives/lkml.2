Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502Ab0DZWuV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 18:50:21 -0400
Received: from tundra.namei.org ([65.99.196.166]:57776 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755477Ab0DZWuT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 18:50:19 -0400
Date: Tue, 27 Apr 2010 08:50:16 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: David Howells <dhowells@redhat.com>
cc: linux-security-module@vger.kernel.org, serue@us.ibm.com,
       paulmck@us.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] CRED: Holding a spinlock does not imply the holding of
 RCU read lock
In-Reply-To: <20100426105849.26489.72831.stgit@warthog.procyon.org.uk>
Message-ID: <alpine.LRH.2.00.1004270850050.13362@tundra.namei.org>
References: <20100426105849.26489.72831.stgit@warthog.procyon.org.uk>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Apr 2010, David Howells wrote:

> From: Serge E. Hallyn <serue@us.ibm.com>
> 
> Change the credentials documentation to make it clear that the RCU read lock
> must be explicitly held when accessing credentials pointers in some other task
> than current.  Holding a spinlock does not implicitly hold the RCU read lock.
> 
> Signed-off-by: Serge Hallyn <serue@us.ibm.com>
> Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Signed-off-by: David Howells <dhowells@redhat.com>


Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next


-- 
James Morris
<jmorris@namei.org>
