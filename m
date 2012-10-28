Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752509Ab2J1Sbz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 14:31:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53832 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751008Ab2J1Sby (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 14:31:54 -0400
Date: Sun, 28 Oct 2012 19:31:47 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Ming Lei <ming.lei@canonical.com>
Cc: Cesar Eduardo Barros <cesarb@cesarb.net>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] firmware: use noinline_for_stack
In-Reply-To: <CACVXFVM+4_ZtPAmF6=i5zX+2XwK4kE6DfvRJ0x+e8e-nobwtmw@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1210281930360.19184@pobox.suse.cz>
References: <1351377430-21247-1-git-send-email-cesarb@cesarb.net> <CACVXFVM+4_ZtPAmF6=i5zX+2XwK4kE6DfvRJ0x+e8e-nobwtmw@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Oct 2012, Ming Lei wrote:

> > The comment above fw_file_size() suggests it is noinline for stack size
> > reasons. Use noinline_for_stack to make this more clear.
> 
> Acked-by: Ming Lei <ming.lei@canonical.com>

Although I am not completely sure that documenting the purpose of noinline 
through this attribute is the nicest thing to do, it's been acked by 
maintainer and it's being used tree-wise, so I am taking this one.

Thanks,

-- 
Jiri Kosina
SUSE Labs
