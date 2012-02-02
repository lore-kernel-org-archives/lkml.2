Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684Ab2BBWs2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 17:48:28 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38080 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753926Ab2BBWsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 17:48:25 -0500
Date: Thu, 2 Feb 2012 14:48:23 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Jonathan Corbet <corbet@lwn.net>,
        Davide Libenzi <davidel@xmailserver.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Enke Chen <enkechen@cisco.com>
Subject: Re: [RFCv7 PATCH 0/4] Add poll_requested_events() function.
Message-Id: <20120202144823.ce00767d.akpm@linux-foundation.org>
In-Reply-To: <1328178417-3876-1-git-send-email-hverkuil@xs4all.nl>
References: <1328178417-3876-1-git-send-email-hverkuil@xs4all.nl>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  2 Feb 2012 11:26:53 +0100
Hans Verkuil <hverkuil@xs4all.nl> wrote:

> The first version of this patch was posted July 1st, 2011. I really hope that
> it won't take another six months to get a review from a fs developer. As this
> LWN article (http://lwn.net/Articles/450658/) said: 'There has been little
> discussion of the patch; it doesn't seem like there is any real reason for it
> not to go in for 3.1.'
> 
> The earliest this can go in now is 3.4. The only reason it takes so long is
> that it has been almost impossible to get a Ack or comments or even just a
> simple reply from the fs developers. That is really frustrating, I'm sorry
> to say.

Yup.  Nobody really maintains the poll/select code.  It happens to sit
under fs/ so nominally belongs to the "fs maintainers".  The logs for
fs/select.c seem to show me as the usual committer, but I wouldn't
claim particular expertise in this area - I'm more a tube-unclogger
here.  Probably Al knows the code as well or better than anyone else. 
It's good that he looked at an earlier version of the patches.

fs/eventpoll.c has an identified maintainer, but he has been vigorously
hiding from us for a year or so.  I'm the commit monkey for eventpoll,
in a similar state to fs/select.c.

So ho hum, all we can do is our best.  You're an experienced kernel
developer who has put a lot of work into the code.  I suggest that you
get your preferred version into linux-next ASAP then send Linus a pull
request for 3.4-rc1, explaining the situation.  If the code wasn't
already in linux-next I would put it in -mm today, for 3.4-rc1.

