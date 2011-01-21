Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793Ab1AUCZJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 21:25:09 -0500
Received: from sycorax.lbl.gov ([128.3.11.121]:46492 "EHLO sycorax.lbl.gov"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751701Ab1AUCZI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 21:25:08 -0500
From: Alex Romosan <romosan@sycorax.lbl.gov>
To: linux-kernel@vger.kernel.org
Cc: xfs@oss.sgi.com
Subject: Re: xfs used disk space bug in 2.6.38-rc1 (commit 6e857567dbbfe14dd6cc3f7414671b047b1ff5c7)
References: <87zkqvtet2.fsf@sycorax.lbl.gov>
Date: Thu, 20 Jan 2011 18:25:05 -0800
In-Reply-To: <87zkqvtet2.fsf@sycorax.lbl.gov> (message from Alex Romosan on
	Thu, 20 Jan 2011 14:01:45 -0800)
Message-ID: <8739onro1q.fsf@sycorax.lbl.gov>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Romosan <romosan@sycorax.lbl.gov> writes:

> my home directory is using xfs and i noticed that when i try to compile
> a program or do any kind of disk access (like git pull, etc) the amount
> of space used jumps by tens of gigabytes causing the disk to seemingly
> become full (eventually). on reboot the used disk space goes back to the
> correct value. i did a 'git bisect start -- fs/xfs' and i tracked it
> down to commit 6e857567dbbfe14dd6cc3f7414671b047b1ff5c7. if i revert
> this patch then disk usage doesn't increase unexpectedly (i have 270GB
> free and the disk became full by simply trying to compile wine). i can
> try patches if somebody comes up with one.

actually, even with that patch reverted the disk usage still creeps up
eventually so something else is not quite right.

--alex--

-- 
| I believe the moment is at hand when, by a paranoiac and active |
|  advance of the mind, it will be possible (simultaneously with  |
|  automatism and other passive states) to systematize confusion  |
|  and thus to help to discredit completely the world of reality. |
