Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932406Ab0FDOj1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 10:39:27 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59724 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932293Ab0FDOj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 10:39:26 -0400
To: Nick Piggin <npiggin@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, Al Viro <viro@ZenIV.linux.org.uk>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Frank Mayhar <fmayhar@google.com>, John Stultz <johnstul@us.ibm.com>,
       Andi Kleen <ak@linux.intel.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [patch 1/4] fs: cleanup files_lock
From: Andi Kleen <andi@firstfloor.org>
References: <20100604064307.737085373@suse.de>
	<20100604072618.227745945@suse.de>
	<20100604083818.GA9987@infradead.org> <20100604142052.GD26335@laptop>
Date: Fri, 04 Jun 2010 16:39:20 +0200
In-Reply-To: <20100604142052.GD26335@laptop> (Nick Piggin's message of "Sat\, 5 Jun 2010 00\:20\:52 +1000")
Message-ID: <87mxvax3on.fsf@basil.nowhere.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <npiggin@suse.de> writes:
>
> Again, this would be nice, but I didn't see an easy way to do it.
> Even if refcounting obsoleted may_remount_ro, we still have
> mark_files_ro. It's no more complex to rip this all out after my
> patch. I don't see the problem in doing this patch. It has good
> numbers.

Yes agreed. The global lock is currently really painful on workloads
that do a lot of opens and anything to make this better would be good asap.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
