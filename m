Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964932Ab1JGJbV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 05:31:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61715 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759580Ab1JGJbT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 05:31:19 -0400
Date: Fri, 7 Oct 2011 11:31:13 +0200
From: Johannes Weiner <jweiner@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Stephen Wilson <wilsons@start.ca>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: replace mm_context_t.ia32_compat by MMF_COMPAT
Message-ID: <20111007093113.GB6791@redhat.com>
References: <20110927170448.GA15977@redhat.com>
 <20110928020724.GA4524@wicker.gateway.2wire.net>
 <20110928155655.GB10550@redhat.com>
 <20110928184149.GA31060@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110928184149.GA31060@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 28, 2011 at 08:41:49PM +0200, Oleg Nesterov wrote:
> Kill mm_context_t.ia32_compat in favour of arch-independent MMF_COMPAT
> flag. This saves a word in mm_struct, and the new flag can be probably
> use outside of arch/x86/.
> 
> Also, remove the "if (current->mm)" check from set_personality_*().
> This can only be called after exec_mmap() installs the new mm != NULL.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Johannes Weiner <jweiner@redhat.com>
