Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213Ab0GAATx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 20:19:53 -0400
Received: from tundra.namei.org ([65.99.196.166]:44200 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753787Ab0GAATv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 20:19:51 -0400
Date: Thu, 1 Jul 2010 10:19:24 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: David Howells <dhowells@redhat.com>
cc: linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
       linux-kernel@vger.kernel.org,
       "Justin P. Mattock" <justinmattock@gmail.com>
Subject: Re: [PATCH] KEYS: Reinstate lost passing of process keyring ID in
 call_sbin_request_key()
In-Reply-To: <20100630093911.28103.73746.stgit@warthog.procyon.org.uk>
Message-ID: <alpine.LRH.2.00.1007011019060.23781@tundra.namei.org>
References: <1277861297-13824-1-git-send-email-justinmattock@gmail.com> <20100630093911.28103.73746.stgit@warthog.procyon.org.uk>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jun 2010, David Howells wrote:

> From: Justin P. Mattock <justinmattock@gmail.com>
> 
> In commit bb952bb98a7e479262c7eb25d5592545a3af147d there was the accidental
> deletion of a statement from call_sbin_request_key() to render the process
> keyring ID to a text string so that it can be passed to /sbin/request-key.
> 
> With gcc 4.6.0 this causes the following warning:
> 
>   CC      security/keys/request_key.o
> security/keys/request_key.c: In function 'call_sbin_request_key':
> security/keys/request_key.c:102:15: warning: variable 'prkey' set but not used
> 
> This patch reinstates that statement.
> 
> Without this statement, /sbin/request-key will get some random rubbish from the
> stack as that parameter.
> 
> Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
> Signed-off-by: David Howells <dhowells@redhat.com>

Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next


-- 
James Morris
<jmorris@namei.org>
