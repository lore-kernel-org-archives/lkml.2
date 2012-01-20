Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011Ab2ATX6u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 18:58:50 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54733 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754027Ab2ATX6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 18:58:49 -0500
Date: Fri, 20 Jan 2012 15:58:47 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Muthu Kumar <muthu.lkml@gmail.com>
Cc: torvalds@linux-foundation.org, dwmw2@infradead.org,
        viro@zeniv.linux.org.uk, axboe@kernel.dk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Update magic.h with some pseudofs magic.
Message-Id: <20120120155847.024ca1ad.akpm@linux-foundation.org>
In-Reply-To: <CAFR8uedLDNpU7+S+GnTJ0bG0q=JEH_W+LsQRgSsfH2AAcg3vgw@mail.gmail.com>
References: <CAFR8uecgfQiCWXcb9hBjhpJ=+Dn2AjNEMzU+eqX1QpJKZMAGjw@mail.gmail.com>
	<CAFR8uedLDNpU7+S+GnTJ0bG0q=JEH_W+LsQRgSsfH2AAcg3vgw@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jan 2012 20:31:03 -0500
Muthu Kumar <muthu.lkml@gmail.com> wrote:

> [ This time with linux-kernel ml. Sorry for the duplicate ].
> 
> While looking at bdevfs noticed that magic.h is not up to date with
> some pseudofs magic. This patch updates it.

Well that was a pretty poor changelog.  Looking at what you've done, I
thing a suitable description is:

: - Move open-coded filesystem magic numbers into magic.h
: 
: - Rearrange magic.h so that the filesystem-related constants are grouped
:   together.

At least, I *think* that's why you churned magic.h around like that. 
Help.  
