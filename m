Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810Ab1IUUcd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 16:32:33 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43747 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317Ab1IUUca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 16:32:30 -0400
Message-ID: <4E7A47E9.3020100@suse.cz>
Date: Wed, 21 Sep 2011 22:24:09 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110918 Thunderbird/7.0
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Slaby <jirislaby@gmail.com>
Subject: s2ram broken (perf)
X-Enigmail-Version: 1.4a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this commit:
commit 144060fee07e9c22e179d00819c83c86fbcbf82c
Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date:   Mon Aug 1 12:49:14 2011 +0200

    perf: Add PM notifiers to fix CPU hotplug races

breaks resume from s2ram for me, paradoxically. The text which was on
the console before suspend appears when I resume. But the system hangs
hard at that point. Reverting that commit on the top of -next helps.

regards,
-- 
js
suse labs
