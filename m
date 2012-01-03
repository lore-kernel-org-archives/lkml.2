Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522Ab2ACR62 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 12:58:28 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:35269 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754494Ab2ACR6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 12:58:16 -0500
X-Sasl-enc: 4OE8+aPOOykLq8ZVm6vrhLx6OM/1fMkTr00LIEOe02Hm 1325613495
Date: Tue, 3 Jan 2012 09:57:44 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net
Subject: Re: Linux 2.6.32.52
Message-ID: <20120103175744.GB16335@kroah.com>
References: <20120103175717.GA16335@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120103175717.GA16335@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index 1c640ea..8f775f5 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 32
-EXTRAVERSION = .51
+EXTRAVERSION = .52
 NAME = Man-Eating Seals of Antiquity
 
 # *DOCUMENTATION*
diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index b38baff..0d809ae 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -221,7 +221,6 @@ void clockevents_exchange_device(struct clock_event_device *old,
 	 * released list and do a notify add later.
 	 */
 	if (old) {
-		old->event_handler = clockevents_handle_noop;
 		clockevents_set_mode(old, CLOCK_EVT_MODE_UNUSED);
 		list_del(&old->list);
 		list_add(&old->list, &clockevents_released);
