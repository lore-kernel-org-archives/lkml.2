Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542Ab2ACAPY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 19:15:24 -0500
Received: from ozlabs.org ([203.10.76.45]:60196 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753468Ab2ACAPW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 19:15:22 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jiri Kosina <jkosina@suse.cz>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] module: log OOT_MODULE tainting
In-Reply-To: <alpine.LNX.2.00.1201021456120.24984@pobox.suse.cz>
References: <alpine.LNX.2.00.1201021456120.24984@pobox.suse.cz>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Tue, 03 Jan 2012 09:20:12 +1030
Message-ID: <87zke5en2z.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Jan 2012 14:58:51 +0100 (CET), Jiri Kosina <jkosina@suse.cz> wrote:
> Follow what we do with other taints and output a message into kernel ring 
> buffer once tainting a kernel because out-of-tree module is being loaded.
> 
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>

I don't like this, actually.  There's a wish among some distributions to
know that OOT modules are in use in panic messages, but not by others.
Certainly, there's no reason to warn the user.

Thanks,
Rusty.
