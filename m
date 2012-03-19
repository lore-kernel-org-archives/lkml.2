Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495Ab2CSUrU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 16:47:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50376 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752998Ab2CSUrJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 16:47:09 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH for 3.4] poll: add poll_requested_events() and poll_does_not_wait() functions
Date: Mon, 19 Mar 2012 21:48:59 +0100
Message-Id: <1332190140-16090-1-git-send-email-hdegoede@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The attached patch adds the useful functionality for drivers to be able to
tell which events are being polled for when their poll function gets called.

It has been reviewed by Al Viro, and he sees no problems with it. Al has asked
me to send this patch directly to you because he believes you should make the
decision on merging this, as it may break drivers not in the mainline.

This patch is esp. useful for the v4l subsystem, and it has been ready and
waiting for merging in one form or another for 2 full release-cycles now (*),
so we (the v4l devs) would very much like to get this upstream for 3.4 .

Note that I'm not the original author of this patch, the original author is
Hans Verkuil, who unfortunately won't be able to do kernel development for
a while due to personal circumstances.

Thanks & Regards,

Hans


*) Although the adding of this functionality is uncontroversial, getting this
patch upstream has been troublesome since it touches some pretty core code,
and it was hard to find the right person to review and sign-off on it.
