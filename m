Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531Ab2CDVDN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 16:03:13 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41868 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755190Ab2CDVDM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 16:03:12 -0500
Date: Sun, 4 Mar 2012 22:03:10 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>, Duncan <1i5t5.duncan@cox.net>,
        Nikolai Kondrashov <spbnick@gmail.com>
Subject: Re: [Bug #42649] Regression 3.2 -> 3.3-rc1 commit b4b583d4 inet/media
 keyboard: stuck "extra" keys
In-Reply-To: <hq7dqombK_C.A.UsF.mG9UPB@chimera>
Message-ID: <alpine.LNX.2.00.1203042201220.23367@pobox.suse.cz>
References: <FNlNbnGKWLP.A.dME.3F9UPB@chimera> <hq7dqombK_C.A.UsF.mG9UPB@chimera>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 Mar 2012, Rafael J. Wysocki wrote:

> This message has been generated automatically as a part of a summary report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 3.2.  Please verify if it still should be listed and let the tracking team
> know (either way).
> 
> 
> Bug-Entry	: https://bugzilla.kernel.org/show_bug.cgi?id=42649
> Subject		: Regression 3.2 -> 3.3-rc1 commit b4b583d4 inet/media keyboard: stuck "extra" keys
> Submitter	: Duncan <1i5t5.duncan@cox.net>
> Date		: 2012-01-24 18:18 (41 days old)
> First-Bad-Commit: http://git.kernel.org/linus/b4b583d4e9a5ff28c4a150bb25a4fff5cd4dfbbd

[ adding Nikolai to CC ]

Nikolai already submitted a fix for b4b583d4e here: 
http://www.spinics.net/lists/linux-input/msg19542.html

I will be queuing that shortly, and will try to make sure that it makes it 
into 3.3 still (otherwise 3.3-stable).

Duncan, I'd be interested whether it fixes the issue you are reporting as 
well.

Thanks,

-- 
Jiri Kosina
SUSE Labs
