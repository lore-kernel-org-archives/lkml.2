Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761158Ab2C3UzP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 16:55:15 -0400
Received: from mga14.intel.com ([143.182.124.37]:17829 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757036Ab2C3UzM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 16:55:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="125389892"
From: Andi Kleen <andi@firstfloor.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: GIT PULL] ext4 updates for 3.4
References: <E1SCEK7-0008CY-LJ@tytso-glaptop.cam.corp.google.com>
	<CA+55aFwxWZ9-xLsZoi+iFMjkt-+V64q4jfMz=dampgJrMX5Ncw@mail.gmail.com>
Date: Fri, 30 Mar 2012 13:54:17 -0700
In-Reply-To: <CA+55aFwxWZ9-xLsZoi+iFMjkt-+V64q4jfMz=dampgJrMX5Ncw@mail.gmail.com>
	(Linus Torvalds's message of "Wed, 28 Mar 2012 16:36:23 -0700")
Message-ID: <m2y5qhyfly.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Mon, Mar 26, 2012 at 11:07 AM, Theodore Ts'o <tytso@mit.edu> wrote:
>>
>> Ext4 commits for 3.3 merge window; mostly cleanups and bug fixes
>
> Ted, is there any chance that the dirty handling (or something else)
> has some serious latency bug?

There's at least a serious scalability bug. That new extent cache 
statistic count in the super block is showing up badly on IO profiles
on larger systems.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
