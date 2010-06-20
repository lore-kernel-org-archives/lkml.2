Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757342Ab0FTWaG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 18:30:06 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58668 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757297Ab0FTW3s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 18:29:48 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Chris Clayton" <chris2553@googlemail.com>,
       "John Fastabend" <john.r.fastabend@intel.com>
References: <lc60d4toGTL.A.QzD._LpHMB@chimera>
In-Reply-To: <lc60d4toGTL.A.QzD._LpHMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <W8JfMs9cZw.A.xkE.aMpHMB@chimera>
Subject: [Bug #16231] Noticeable slow-down in 2.6.35-rc3
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 21 Jun 2010 00:17:45 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.34.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16231
Subject		: Noticeable slow-down in 2.6.35-rc3
Submitter	: Chris Clayton <chris2553@googlemail.com>
Date		: 2010-06-13 20:15 (8 days old)
First-Bad-Commit: http://git.kernel.org/linus/597a264b1a9c7e36d1728f677c66c5c1f7e3b837
Message-ID	: <AANLkTimDUf0N6b5PBy2wTGeAWEIY-lUvQPHQ7D7Gyrq4@mail.gmail.com>
References	: http://marc.info/?l=linux-kernel&m=127646015226601&w=2
Handled-By	: John Fastabend <john.r.fastabend@intel.com>
Patch		: https://patchwork.kernel.org/patch/105859/


