Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871Ab2ACTcY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 14:32:24 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:57825 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754802Ab2ACTcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 14:32:00 -0500
X-Sasl-enc: HaFITJKdaSqEpl8Eldsjw8oIUr/fKbG0c2rq9HMRo2XP 1325619118
Date: Tue, 3 Jan 2012 11:31:29 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net
Subject: Re: Linux 3.1.7
Message-ID: <20120103193129.GB1787@kroah.com>
References: <20120103193115.GA1787@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120103193115.GA1787@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index 2d6e0a8..96c48df 100644
--- a/Makefile
+++ b/Makefile
@@ -1,6 +1,6 @@
 VERSION = 3
 PATCHLEVEL = 1
-SUBLEVEL = 6
+SUBLEVEL = 7
 EXTRAVERSION =
 NAME = "Divemaster Edition"
 
diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index 13dfaab..e4c699d 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -286,7 +286,6 @@ void clockevents_exchange_device(struct clock_event_device *old,
 	 * released list and do a notify add later.
 	 */
 	if (old) {
-		old->event_handler = clockevents_handle_noop;
 		clockevents_set_mode(old, CLOCK_EVT_MODE_UNUSED);
 		list_del(&old->list);
 		list_add(&old->list, &clockevents_released);
