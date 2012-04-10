Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758368Ab2DJBtA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 21:49:00 -0400
Received: from zfrontend1.aha.ru ([195.2.83.147]:57499 "EHLO zfrontend1.aha.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753691Ab2DJBs7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 21:48:59 -0400
X-iZenGuard: ZMAIL
From: "werner" <w.landgraf@ru.ru>
Subject: Re: v3.4-rc2 out-of-memory problems (was Re: 3.4-rc1
 sticks-and-crashs)
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, werner <w.landgraf@ru.ru>,
        Rik van Riel <riel@redhat.com>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Christian Bejram <christian.bejram@stericsson.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, rientjes@google.com
X-Mailer: CommuniGate Pro WebUser Interface v.4.3.12
Date: Mon, 09 Apr 2012 21:52:53 -0400
Message-ID: <web-723115389@zbackend1.aha.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At least until now, and also tested hard by starting and 
stopping several memory-consuming operations,   I'm happy 
to can inform that the computer didnt yet crash again, and 
that also slownessnesses what I observed under 3.3 (but 
without crashs) don't occure and kmemleak (or a similar 
name) what sometimes started and I had to shut down under 
3.3 for recover normal speed, I dont see longer,  so that 
the the patch suggested by D.R. and L.T. cured the crashs 
(at least phenomenologically).    For be sure, however, 
it's still too early, only if the computer dont crash 
until tomorrow.

If there is found an agreement about something else what's 
senseful to test out, I can do that.

wl
---
Professional hosting for everyone - http://www.host.ru

