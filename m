Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753698Ab2D0VQb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 17:16:31 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:50800 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243Ab2D0VQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 17:16:30 -0400
Date: Fri, 27 Apr 2012 14:16:25 -0700
From: Tejun Heo <tj@kernel.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Peter Zijlstra <peterz@infradead.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Lockdep false positive in sysfs
Message-ID: <20120427211625.GP26595@google.com>
References: <87haw55eed.fsf@xmission.com>
 <Pine.LNX.4.44L0.1204271410470.1690-100000@iolanthe.rowland.org>
 <20120427201704.GK26595@google.com>
 <878vhg3mrh.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878vhg3mrh.fsf@xmission.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2012 at 02:09:22PM -0700, Eric W. Biederman wrote:
> I don't mind the attitude we are clever careful programmers we can
> handle the complexity and we can get away without the tool help us, but
> I would much rather see the attitude that we are clever careful
> programmers and we can figure out how to make the tool help us instead
> of just ignoring it.

I'm okay with using static array of keys so that each level maps to
separate key or just calling it a special case and ignoring it, but I
think it's quite silly to use an async mechanism just to avoid lockdep
warning.  Things like that tend to make things obscure as people
generally don't expect lockdep annotation to dictate overall
behaviors.  It is an annotation problem.  Let's keep it that way.

Thanks.

-- 
tejun
