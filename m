Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760308Ab2EQQCz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 12:02:55 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59024 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760102Ab2EQQCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 12:02:53 -0400
Date: Thu, 17 May 2012 09:02:48 -0700
From: Tejun Heo <tj@kernel.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] floppy: convert to delayed work and single-thread wq
Message-ID: <20120517160248.GJ21275@google.com>
References: <20120516195332.GC21275@google.com>
 <alpine.LNX.2.00.1205162156120.8796@pobox.suse.cz>
 <20120516200147.GD21275@google.com>
 <alpine.LNX.2.00.1205162216390.8796@pobox.suse.cz>
 <20120516202924.GE21275@google.com>
 <CA+55aFyX3OgdcWuYQO+YuS3fF_Wt1p8w-G33C5MCkiR-3ncfVA@mail.gmail.com>
 <20120517145519.GF21275@google.com>
 <alpine.LNX.2.00.1205171705520.8796@pobox.suse.cz>
 <20120517150923.GH21275@google.com>
 <alpine.LNX.2.00.1205171744490.8796@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1205171744490.8796@pobox.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, May 17, 2012 at 05:46:50PM +0200, Jiri Kosina wrote:
> Well, seeing almost 200 occurences of create_singlethread_workqueue() (and 
> not talking about non-singlethread ones) doesn't really hint about this 
> interface being deprecated :) But whatever. The patch below uses 
> alloc_ordered_workqueue() instead. I have given it the same round of 
> testing, it passed.

Yeah, I need to audit them and convert them to one of the newer
interfaces according to the actual requirements of each.
Eh... someday. ;)

Thanks.

-- 
tejun
