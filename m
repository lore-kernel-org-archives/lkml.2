Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870Ab1AUQF0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 11:05:26 -0500
Received: from sycorax.lbl.gov ([128.3.11.121]:34025 "EHLO sycorax.lbl.gov"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751980Ab1AUQFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 11:05:25 -0500
From: Alex Romosan <romosan@sycorax.lbl.gov>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: xfs used disk space bug in 2.6.38-rc1 (commit 6e857567dbbfe14dd6cc3f7414671b047b1ff5c7)
References: <87zkqvtet2.fsf@sycorax.lbl.gov> <20110121034208.GZ16267@dastard>
Date: Fri, 21 Jan 2011 08:05:16 -0800
In-Reply-To: <20110121034208.GZ16267@dastard> (message from Dave Chinner on
	Fri, 21 Jan 2011 14:42:08 +1100)
Message-ID: <87bp3a8coz.fsf@sycorax.lbl.gov>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Chinner <david@fromorbit.com> writes:

> When you quote a commit, can you please include the name of the
> commit. e.g:
>
> 6e85756 ("xfs: don't truncate prealloc from frequently accessed inodes")
>

sorry.

> Is the one with the known bug that causes excessive preallocation
> when files are zero sized. The candidate fix is here:
>
> http://oss.sgi.com/archives/xfs/2011-01/msg00281.html
>
> Can you see if that solves your problem?

i've tried it and disk usage is back to normal. thanks.

--alex--

-- 
| I believe the moment is at hand when, by a paranoiac and active |
|  advance of the mind, it will be possible (simultaneously with  |
|  automatism and other passive states) to systematize confusion  |
|  and thus to help to discredit completely the world of reality. |
