Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757208Ab2BGXW7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 18:22:59 -0500
Received: from zep00a03.dent.med.uni-muenchen.de ([138.246.161.8]:36606 "HELO
	md.dent.med.uni-muenchen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757141Ab2BGXW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 18:22:58 -0500
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Feb 2012 18:22:58 EST
Date: 8 Feb 2012 00:16:15 +0100
Message-ID: <20120207231615.11358.qmail@md.dent.med.uni-muenchen.de>
From: Wolfram Gloger <wmglo@dent.med.uni-muenchen.de>
To: jack@suse.cz
CC: linux-kernel@vger.kernel.org
In-reply-to: <20120207225246.GA18832@quack.suse.cz> (message from Jan Kara on
	Tue, 7 Feb 2012 23:52:46 +0100)
Subject: Re: Soft lockup problem
References: <20120207215737.10744.qmail@md.dent.med.uni-muenchen.de> <20120207225246.GA18832@quack.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for your response.

> From: Jan Kara <jack@suse.cz>

>   Hmm, then this isn't really a deadlock (at least in your case) but only a
> rather unresponsive system.

Well, like the subject says this is a "soft lockup"..
When it happened the first time the system actually recovered
after some hours.
But like Gerard said, there is no apparent ground for this
unresponsiveness, there are tons of memory free and no swapping.

> Looking at the backtraces you provided I don't
> see anything really suspicious. Only maybe fsnotify_mark process - do you
> use fsnotify?

I have configured CONFIG_FSNOTIFY=y indeed but don't think I'm using it
from userspace..

Regards,
Wolfram.
