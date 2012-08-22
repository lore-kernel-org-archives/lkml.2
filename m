Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635Ab2HVLw5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 07:52:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52122 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750805Ab2HVLwx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 07:52:53 -0400
Date: Wed, 22 Aug 2012 12:52:44 +0100
From: "Richard W.M. Jones" <rjones@redhat.com>
To: Hugh Dickins <hughd@google.com>
Cc: Jeff Moyer <jmoyer@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <jaxboe@fusionio.com>,
        Torsten Hilbrich <torsten.hilbrich@secunet.com>,
        Josh Boyer <jwboyer@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: replace __getblk_slow misfix by grow_dev_page fix
Message-ID: <20120822115243.GU1448@rhmail.home.annexia.org>
References: <alpine.LSU.2.00.1208211826270.2488@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1208211826270.2488@eggly.anvils>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2012 at 06:33:45PM -0700, Hugh Dickins wrote:
> Jeff,
> 
> Your commit 91f68c89d8f3 ("block: fix infinite loop in __getblk_slow"),
> already gone into 3.* stable, is not good.  Could you and your testers
> please give this alternative a try - I think it should work, and have
> started it on a few days' memory load on 3.5, but not tried your case.

I have tested your patch and it does NOT fix the problem in
http://bugzilla.redhat.com/835019
Kernel 3.6.0 + your patch => mount goes into a loop when mounting
a small empty partition.  Please do NOT apply this as it will
cause a regression!

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
libguestfs lets you edit virtual machines.  Supports shell scripting,
bindings from many languages.  http://libguestfs.org
