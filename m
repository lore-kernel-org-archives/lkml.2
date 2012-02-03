Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382Ab2BCJ3s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 04:29:48 -0500
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:3927 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558Ab2BCJ3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 04:29:46 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>, Jonathan Corbet <corbet@lwn.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Davide Libenzi <davidel@xmailserver.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Enke Chen <enkechen@cisco.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH 0/6] Add poll_requested_events() function.
Date: Fri,  3 Feb 2012 10:28:39 +0100
Message-Id: <1328261325-8452-1-git-send-email-hverkuil@xs4all.nl>
X-Mailer: git-send-email 1.7.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This is the eighth version of this patch series and the last as far as
I am concerned.

See this link for the previous version and the associated thread:

http://www.gossamer-threads.com/lists/linux/kernel/1486261

The changes compared to version 7 are:

- rebased to the linux-media staging/for_v3.4 branch.
- renamed the poll_table fields to _qproc and _key as per Andrew's suggestion.
- all poll changes are back in one patch (the first). With the renaming of
  fields it made more sense to have it as one patch.
- added the video4linux changes as well that depend on this new poll
  behavior. This makes it ready to be merged in linux-media and linux-next.

Mauro, can you get this patch series in linux-next as soon as possible?

If anyone has any problems/comments/remarks regarding this patch series,
then please speak up now and not one day before the 3.4 merge window opens...

Regards,

	Hans

