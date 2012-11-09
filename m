Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316Ab2KIMmc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 07:42:32 -0500
Received: from zimbra.linbit.com ([212.69.161.123]:48874 "EHLO
	zimbra.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750Ab2KIMma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 07:42:30 -0500
From: Philipp Reisner <philipp.reisner@linbit.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] drbd-8.4.2 for the linux-3.8 merge window
Date: Fri, 09 Nov 2012 13:42:26 +0100
Message-ID: <4229483.8Hqs9YQUgX@fat-tyre>
User-Agent: KMail/4.8.5 (Linux/3.2.0-32-generic; KDE/4.8.5; x86_64; ; )
In-Reply-To: <509CEB9F.8080705@kernel.dk>
References: <3042269.jrNem7z1LI@fat-tyre> <509CEB9F.8080705@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[...]
> > It has the sysfs bits in again. The reason for that is that we want to
> > expose more information by that, and remove the /proc/drbd with the
> > next evolutionary step. -- In case this is a show stopper, let me
> > remove the sysfs bits.
> 
> The exact same sysfs bits I complained about last time? If yes, then I
> don't understand why you haven't changed yet. Or why you are trying to
> push the same bits again that got rejected last time.
> 

I had the impression it was rejected because I submitted the pull request
too late to you. In the sense of, it might go in, if it gets submitted
for inclusion before the merge window opens...
Apparently my impression was wrong. You will get an updated pull-request 
with the sysfs bits removed

> > Here is the git-pull-request test:
> > (The patch subjects removed to make the mail more digestible)
> 
> Please don't do that, it basically makes the pull request useless! A few
> hundred extra lines is not an issue.

Ok.

I intend to send the updated pull-request later today.

