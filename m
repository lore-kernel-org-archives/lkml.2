Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477Ab0DVWrM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 18:47:12 -0400
Received: from tundra.namei.org ([65.99.196.166]:43381 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753306Ab0DVWrJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 18:47:09 -0400
Date: Fri, 23 Apr 2010 08:46:27 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: David Howells <dhowells@redhat.com>, linux-security-module@vger.kernel.org,
       mathieu.desnoyers@efficios.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] CRED: Fix double free in prepare_usermodehelper_creds()
 error handling
In-Reply-To: <20100422112307.5375e085.akpm@linux-foundation.org>
Message-ID: <alpine.LRH.2.00.1004230845580.18002@tundra.namei.org>
References: <20100420214117.10400.82534.stgit@warthog.procyon.org.uk> <20100422112307.5375e085.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Apr 2010, Andrew Morton wrote:

> >  #ifdef CONFIG_KEYS
> >  	kfree(tgcred);
> 
> Oleg's umh-creds-kill-subprocess_info-cred-logic.patch removes
> prepare_usermodehelper_creds() altogether.  An option would have been
> to promote that into 2.6.34?

FYI, this fix is in Linus' tree, now.

-- 
James Morris
<jmorris@namei.org>
