Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742Ab2DEODS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 10:03:18 -0400
Received: from serv04.lahn.de ([213.239.197.57]:32818 "EHLO serv04.lahn.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753659Ab2DEODO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 10:03:14 -0400
Date: Thu, 5 Apr 2012 15:53:05 +0200
From: Michael Leun <lkml20120218@newton.leun.net>
To: Mohammed Shafi <shafi.wireless@gmail.com>
Cc: casteyde.christian@free.fr, Kelly Anderson <kelly@silka.with-linux.com>,
        Ben Greear <greearb@candelatech.com>,
        "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felix Fietkau <nbd@openwrt.org>,
        linux-wireless Mailing List <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] 3.3.1 ath9k regression
Message-ID: <20120405155305.06f80bb0@xenia.leun.net>
In-Reply-To: <CAD2nsn0iRjxgY=EFoX2t5fFQ2_7X71WAax2M-spO=b+kBF15Fg@mail.gmail.com>
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
	<CAD2nsn0iRjxgY=EFoX2t5fFQ2_7X71WAax2M-spO=b+kBF15Fg@mail.gmail.com>
Organization: Not Organized
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Apr 2012 11:46:36 +0530
Mohammed Shafi <shafi.wireless@gmail.com> wrote:

> > Surprise, surprise: This (what I saw) really only happens in 3.3.1 -
> > 3.4-rc1 works also when the patch is in place.
> 
> thanks, if the other users can confirm it the issue is resolved, we
> can close the thread, otherwise i would spend time to recreate and fix
> it.

I agree that we then can close the issue regarding 3.4 development, but
we still have an issue in the stabile kernel 3.3.1 - either needs to be
fixed or reverted there in my opinion.


-- 
MfG,

Michael Leun

