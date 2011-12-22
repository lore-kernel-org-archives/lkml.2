Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464Ab1LVRHa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 12:07:30 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34963 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050Ab1LVRH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 12:07:28 -0500
Date: Thu, 22 Dec 2011 09:07:23 -0800
From: Tejun Heo <tj@kernel.org>
To: Ben Hutchings <ben@decadent.org.uk>, Dave Jones <davej@redhat.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: out-of-tree module shouldn't disable lockdep
Message-ID: <20111222170723.GI17084@google.com>
References: <20111222165952.GH17084@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111222165952.GH17084@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 22, 2011 at 08:59:52AM -0800, Tejun Heo wrote:
> Hello, guys.
> 
> 2449b8ba074 "module,bug: Add TAINT_OOT_MODULE flag for modules not
> built in-tree" added TAINT_OOT_MODULE to mark kernel which has
> out-of-tree module loaded, which might be a good idea but an
> unfortunate side effect of tainting is that it disables lockdep.  So,
> now, none of my test modules is watched by lockdep.  This is a bad bad
> idea.  People use oot modules to write test code and disabling lockdep
> for test codes is silly.  Can we please fix this?

Ingo just told me it's already fixed and scheduled for upstream, so
please forget about this thread.

Thanks.

-- 
tejun
