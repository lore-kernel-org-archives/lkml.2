Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751641Ab0DCFUP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Apr 2010 01:20:15 -0400
Received: from kroah.org ([198.145.64.141]:53247 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751058Ab0DCFUK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Apr 2010 01:20:10 -0400
Date: Fri, 2 Apr 2010 22:15:31 -0700
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
       linux-kernel@vger.kernel.org, Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Catalin Marinas <catalin.marinas@arm.com>,
       Serge Hallyn <serue@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org,
       Alan Cox <alan@linux.intel.com>
Subject: Re: [stable] [PATCH 0/1] tty: release_one_tty() forgets to put pids
Message-ID: <20100403051531.GA2309@kroah.com>
References: <201003272121.ADE39095.JLFHOOMtSVOFQF@I-love.SAKURA.ne.jp> <tnxbpe5ygfy.fsf@e102109-lin.cambridge.arm.com> <20100331151719.8a92b302.akpm@linux-foundation.org> <20100402160447.GA19920@redhat.com> <alpine.LFD.2.00.1004022007300.3634@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1004022007300.3634@i5.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 02, 2010 at 08:08:55PM -0700, Linus Torvalds wrote:
> 
> 
> Ok, I committed this, but after committing I realized that the patch 
> didn't have the "Cc: stable@kernel.org", even if the email did.
> 
> So Greg et al: it's now commit 6da8d866d0d39e9509ff826660f6a86a6757c966 in 
> mainline. 

Thanks, I'll queue it up in the morning.

greg k-h
