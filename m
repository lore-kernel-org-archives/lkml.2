Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569Ab2CDVo6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 16:44:58 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:54719 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755090Ab2CDVo5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 16:44:57 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiri Kosina <jkosina@suse.cz>
Subject: Re: [Bug #42649] Regression 3.2 -> 3.3-rc1 commit b4b583d4 inet/media keyboard: stuck "extra" keys
Date: Sun, 4 Mar 2012 22:43:42 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>, Duncan <1i5t5.duncan@cox.net>,
        Nikolai Kondrashov <spbnick@gmail.com>
References: <FNlNbnGKWLP.A.dME.3F9UPB@chimera> <hq7dqombK_C.A.UsF.mG9UPB@chimera> <alpine.LNX.2.00.1203042201220.23367@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1203042201220.23367@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201203042243.43003.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, March 04, 2012, Jiri Kosina wrote:
> On Sun, 4 Mar 2012, Rafael J. Wysocki wrote:
> 
> > This message has been generated automatically as a part of a summary report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 3.2.  Please verify if it still should be listed and let the tracking team
> > know (either way).
> > 
> > 
> > Bug-Entry	: https://bugzilla.kernel.org/show_bug.cgi?id=42649
> > Subject		: Regression 3.2 -> 3.3-rc1 commit b4b583d4 inet/media keyboard: stuck "extra" keys
> > Submitter	: Duncan <1i5t5.duncan@cox.net>
> > Date		: 2012-01-24 18:18 (41 days old)
> > First-Bad-Commit: http://git.kernel.org/linus/b4b583d4e9a5ff28c4a150bb25a4fff5cd4dfbbd
> 
> [ adding Nikolai to CC ]
> 
> Nikolai already submitted a fix for b4b583d4e here: 
> http://www.spinics.net/lists/linux-input/msg19542.html

Thanks, added to the bug entry.

Rafael
