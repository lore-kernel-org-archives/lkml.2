Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756121Ab2DIK0X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 06:26:23 -0400
Received: from serv04.lahn.de ([213.239.197.57]:48781 "EHLO serv04.lahn.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753051Ab2DIK0W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 06:26:22 -0400
Date: Mon, 9 Apr 2012 12:25:49 +0200
From: Michael Leun <lkml20120218@newton.leun.net>
To: Mohammed Shafi <shafi.wireless@gmail.com>
Cc: Ben Greear <greearb@candelatech.com>, casteyde.christian@free.fr,
        Kelly Anderson <kelly@silka.with-linux.com>,
        "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felix Fietkau <nbd@openwrt.org>,
        linux-wireless Mailing List <linux-wireless@vger.kernel.org>,
        Sergio Correia <lists@uece.net>
Subject: Re: 3.4-rc ath9k regression (Re: [ath9k-devel] 3.3.1 ath9k
 regression)
Message-ID: <20120409122549.7469543a@xenia.leun.net>
In-Reply-To: <CAD2nsn3-C8ZLmUpTDeA6HuPr-+=V5KkPJb6h5e7ZJsGi4v9p0g@mail.gmail.com>
References: <4F7A8EB7.4060200@silka.with-linux.com>
	<4F7A923D.5000002@candelatech.com>
	<CAD2nsn0vKPEOFp08WGYAGh0vEHPbShP4yMo5HzEGc8SrTmTZmQ@mail.gmail.com>
	<4F7A9D5C.8040402@silka.with-linux.com>
	<CAD2nsn2ONstURLWBSPkNrDfFOeePWMWGQeGrEUkU3Wh4kUo+sg@mail.gmail.com>
	<4F7AAAD9.2040307@silka.with-linux.com>
	<CAD2nsn0G8_vDQug-u=4PRWMwRLPX-zp1z0X5gOVNaxk=V+daWw@mail.gmail.com>
	<CAD2nsn0kogfuMhCN7tNNkiKF4PN-mG2Fa3gu0CGfw01qj-MWyg@mail.gmail.com>
	<4F7AB6FE.3080009@silka.with-linux.com>
	<20120403200306.0afbb48b@xenia.leun.net>
	<CAD2nsn2k3mKMm3gK=fXqDYcOeKBwkyqGz9RWz1KOe=6=CDyhHA@mail.gmail.com>
	<CAD2nsn1AshPTYd-FcydV-5HpiXPb0FfqLQPTqFYyw3kJX+fXEA@mail.gmail.com>
	<20120404235104.682cfad3@xenia.leun.net>
	<4F7DE3A4.1040705@candelatech.com>
	<CAD2nsn16AozFF2QhiY063-48bKiXdyQLmSqJLLHPpsZ3H3JtHQ@mail.gmail.com>
	<4F7F52BD.7060906@candelatech.com>
	<20120409010816.36244f17@xenia.leun.net>
	<CAD2nsn3-C8ZLmUpTDeA6HuPr-+=V5KkPJb6h5e7ZJsGi4v9p0g@mail.gmail.com>
Organization: Not Organized
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Apr 2012 11:58:06 +0530
Mohammed Shafi <shafi.wireless@gmail.com> wrote:

> On Mon, Apr 9, 2012 at 4:38 AM, Michael Leun
> <lkml20120218@newton.leun.net> wrote:
> > After an suspend to disk / resume cycle (in kernel suspend to disk,
> > openSuSE) with 3.4-rc2 my ath9k wireless does not ping
> > anymore.
> >
> > Output of iwconfig wlan0 looks just as usual (associated to AP).
> >
> > iwconfig wlan0 essid <myssid> fixes this (causes an
> > deauthenticate/authenticate with AP) - then connectivity is there
> > again.
> >
> > Guess what: "Of course" does not happen when reverting
> > c1afdaff90538ef085b756454f12b29575411214 ath9k: fix going to
> > full-sleep on PS idle.
> >
> > So, in my opinion it should be seriously considered to revert that
> > patch until it is fully understood what is going on and why.
> 
> please try with the attached patch to see if it helps.

Yes, this patch helps with the issue I see in 3.4-rc2 described above.

But I agree with Ben and Sergio that it does NOT help with the issue in
3.3.1 we all see.

-- 
MfG,

Michael Leun

