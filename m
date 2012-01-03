Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625Ab2ACIrF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 03:47:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52554 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752060Ab2ACIrE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 03:47:04 -0500
Date: Tue, 3 Jan 2012 09:47:02 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] module: log OOT_MODULE tainting
In-Reply-To: <87zke5en2z.fsf@rustcorp.com.au>
Message-ID: <alpine.LNX.2.00.1201030944270.24984@pobox.suse.cz>
References: <alpine.LNX.2.00.1201021456120.24984@pobox.suse.cz> <87zke5en2z.fsf@rustcorp.com.au>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Jan 2012, Rusty Russell wrote:

> > Follow what we do with other taints and output a message into kernel ring 
> > buffer once tainting a kernel because out-of-tree module is being loaded.
> > 
> > Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> 
> I don't like this, actually.  There's a wish among some distributions to
> know that OOT modules are in use in panic messages, but not by others.
> Certainly, there's no reason to warn the user.

I do get your point, but it seems to me that we are at least not 
consistent here. Why would we then log messages in cases of 
TAINT_FORCED_MODULE for example? The user knows that he has forced the 
module load, right?

-- 
Jiri Kosina
SUSE Labs
