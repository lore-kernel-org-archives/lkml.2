Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758117Ab0LMPKy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 10:10:54 -0500
Received: from one.firstfloor.org ([213.235.205.2]:60229 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758073Ab0LMPKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 10:10:44 -0500
Date: Mon, 13 Dec 2010 16:10:39 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, ak@linux.intel.com,
        torvalds@linux-foundation.org, gregkh@suse.de,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] [134/223] exec: make argv/envp memory visible to
 oom-killer
Message-ID: <20101213151039.GB11449@basil.fritz.box>
References: <201012131244.547034648@firstfloor.org>
 <20101212234716.6AE2AB27C0@basil.firstfloor.org>
 <20101213111859.GA13719@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101213111859.GA13719@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 13, 2010 at 12:18:59PM +0100, Oleg Nesterov wrote:
> On 12/13, Andi Kleen wrote:
> >
> > 2.6.35-longterm review patch.  If anyone has any objections, please let me know.
> >
> > ------------------
> > From: Oleg Nesterov <oleg@redhat.com>
> 
> Nack ;)
> 
> > With this patch get_arg_page() increments current's MM_ANONPAGES
> > counter every time we allocate the new page for argv/envp. When
> > do_execve() succeds or fails, we change this counter back.
> 
> This works starting from 2.6.36.

I replaced the patch. Thanks.
-Andi
