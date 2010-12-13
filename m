Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178Ab0LMAdk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 19:33:40 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48359 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752978Ab0LMAdj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 19:33:39 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: [RFC][PATCH 0/4] PM: Use separate lists of devices at each stage of suspend/resume
Date: Mon, 13 Dec 2010 01:28:31 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc5+; KDE/4.4.4; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>
MIME-Version: 1.0
Message-Id: <201012130128.31243.rjw@sisk.pl>
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

Some time ago Linus suggested that we might use a separate list of devices
at each stage of device suspend/resume and you seemed to like the idea.

The following patches implement that and remove some code that's not necessary
any more in the wake of this change.

Please let me know what you think.

Thanks,
Rafael

