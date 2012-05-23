Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085Ab2EWMyZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 08:54:25 -0400
Received: from ozlabs.org ([203.10.76.45]:46134 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752273Ab2EWMyX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 08:54:23 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] Guard check in module loader against integer overflow
In-Reply-To: <20120522145613.32115.21217.stgit@warthog.procyon.org.uk>
References: <20120522145613.32115.21217.stgit@warthog.procyon.org.uk>
User-Agent: Notmuch/0.12 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Wed, 23 May 2012 21:41:54 +0930
Message-ID: <87r4ubxfjp.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 May 2012 15:56:13 +0100, David Howells <dhowells@redhat.com> wrote:
> The check:
> 
> 	if (len < hdr->e_shoff + hdr->e_shnum * sizeof(Elf_Shdr))
> 
> may not work if there's an overflow in the right-hand side of the condition.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>

Thanks; though the sanity checks are merely against accidents, not
malice, it's worth fixing.

Applied,
Rusty.
