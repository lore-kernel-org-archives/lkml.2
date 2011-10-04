Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347Ab1JDBSe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 21:18:34 -0400
Received: from ozlabs.org ([203.10.76.45]:50329 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753005Ab1JDBSb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 21:18:31 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jiri Kosina <jkosina@suse.cz>, Andrew Morton <akpm00@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kmod: prevent kmod_loop_msg overflow in __request_module()
In-Reply-To: <alpine.LNX.2.00.1109292337030.24692@pobox.suse.cz>
References: <alpine.LNX.2.00.1109291749000.24692@pobox.suse.cz> <20110929143129.e7c3c7e2.akpm00@gmail.com> <alpine.LNX.2.00.1109292337030.24692@pobox.suse.cz>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Tue, 04 Oct 2011 10:47:28 +1030
Message-ID: <87zkhhhap3.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Sep 2011 00:18:17 +0200 (CEST), Jiri Kosina <jkosina@suse.cz> wrote:
> On Thu, 29 Sep 2011, Andrew Morton wrote:
> > Well, it will take two billion passes through here to cause the
> > overflow.  I really hope you found this problem by inspection!
> 
> Unfortunately not, it was more painful experience than code reading :)

Cool!

Changing it to unsigned would have helped too.  But I've applied
this....

Thanks,
Rusty.
