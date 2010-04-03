Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755801Ab0DCDNX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 23:13:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60697 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753444Ab0DCDNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 23:13:21 -0400
Date: Fri, 2 Apr 2010 20:08:55 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Alan Cox <alan@linux.intel.com>,
       Greg KH <greg@kroah.com>, Catalin Marinas <catalin.marinas@arm.com>,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
       linux-kernel@vger.kernel.org, Serge Hallyn <serue@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>, stable@kernel.org
Subject: Re: [PATCH 0/1] tty: release_one_tty() forgets to put pids
In-Reply-To: <20100402160447.GA19920@redhat.com>
Message-ID: <alpine.LFD.2.00.1004022007300.3634@i5.linux-foundation.org>
References: <201003272121.ADE39095.JLFHOOMtSVOFQF@I-love.SAKURA.ne.jp> <tnxbpe5ygfy.fsf@e102109-lin.cambridge.arm.com> <20100331151719.8a92b302.akpm@linux-foundation.org> <20100402160447.GA19920@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Ok, I committed this, but after committing I realized that the patch 
didn't have the "Cc: stable@kernel.org", even if the email did.

So Greg et al: it's now commit 6da8d866d0d39e9509ff826660f6a86a6757c966 in 
mainline. 

		Linus
